use nutflux;

-- Views In Nutflux

-- 1. create a view to store all ratings for the film

create view combined_film_ratings as 
select f.id as filmid, f.title as films, fr.total_rating as IMDB, avg(uv.rating) as avg_user_rating, avg(cr.rating) as avg_critics_rating
from films f join film_rating fr on f.id = fr.f_id
join user_views uv on uv.f_id = f.id
join critics_reviews cr on cr.f_id = f.id
group  by f.id;


-- 2. create a view for award winning actors and their film rating

create view awarded_actors_rating as
select a.id as actor_id, a.theatre_name as actor_Name, f.id as film_id, f.title as title,r.name as role, fr.total_rating, ac.name as award, ai.name as award_institution
from films f
join filmcast fc on f.id = fc.f_id
join actors a on fc.a_id = a.id
join roles r on fc.r_id = r.id
join film_rating fr on fr.f_id = f.id 
join award_actors aa on aa.a_id = a.id and aa.f_id = f.id
join award_category ac on aa.ac_id = ac.id
join awarding_institution ai on aa.ai_id = ai.id
group by a.id, f.id;

-- 3. creating versatility score for each actor
create view versatility_score as
select  actorID, actorName, count(*) as versatility_score
from (select distinct a.id as actorID, a.theatre_name as actorName, g.name as genre
	  from actors a join filmcast fc on a.id = fc.a_id 
	  join film_genre fg on fg.f_id = fc.f_id
	  join genre g on g.id = fg.g_id 
group by a.id , g.name) as actor_genre
group by actor_genre.actorID
order by versatility_score desc;

-- 4. create a view to diplay the total number of awards and nominations won by the films
create view films_awards_nomination as
select f.id,ifnull(taa,0) as actor_awards,ifnull(tda,0) as director_awards,ifnull(twa,0) as writer_awards
from films f left join
(select f.id as filmid, f.title as film, ifnull(count(*),0) as taa
from films f
join filmcast fc on f.id= fc.f_id
join award_actors aa on aa.f_id = f.id and aa.a_id = fc.a_id
group by f.id) actors_awards on actors_awards.filmid = f.id
left join 
(select f.id as filmid, f.title as film, ifnull(count(*),0) as tda
from films f
join film_directors fd on f.id= fd.f_id 
join award_directors ad on ad.d_id = fd.d_id and ad.f_id= f.id
group by f.id) director_awards on actors_awards.filmid = director_awards.filmid
join 
(select f.id as filmid, f.title as film, ifnull(count(*),0) as twa
from films f
join film_writers fw on f.id= fw.f_id
left join award_writers aw on aw.w_id = fw.w_id and aw.f_id= f.id
group by f.id) writer_awards on writer_awards.filmid = f.id
group by f.id;	


-- TRIGGERS IN NUTFLUX

-- 1. trigger to validate password strength

DROP TRIGGER IF EXISTS nutflux.validate_password_strength ;
DELIMITER //
CREATE TRIGGER  validate_password_strength
BEFORE INSERT ON users FOR EACH ROW
Begin
	IF  New.pwd  regexp '.*[0-9]+.*' = 0  or char_length(New.pwd)<=(8) or new.pwd regexp '.*[@|%|*|!]+.*' = 0 THEN
		SIGNAL SQLSTATE VALUE '10002'
		SET MESSAGE_TEXT = "Pwd size should be greater than 8 and should have numbers and should have 1 or more special characters";
	end if;
end //

DELIMITER ;


-- 2. trigger to validate age of the new user

DROP TRIGGER IF EXISTS nutflux.user_age_verification_insert ;
DELIMITER //
CREATE TRIGGER  user_age_verification_insert
BEFORE INSERT ON users FOR EACH ROW
Begin
	declare age int;
	set age =  DATE_FORMAT(FROM_DAYS(DATEDIFF(now(),New.dob)), '%Y')+0 ;
	IF Age <18 THEN
		SIGNAL SQLSTATE VALUE '20000'
		SET MESSAGE_TEXT = "[table:users] -Age is below 18";
	else if Age >150 then 
		SIGNAL SQLSTATE VALUE '20000'
		SET MESSAGE_TEXT = "[table:users] -Age is Unrealistic";
	end if;
    end if;
end //

DELIMITER ;

-- 3.  create trigger to add film_verdict info to the table

DROP TRIGGER IF EXISTS nutflux.film_verdict_insert ;
DELIMITER //
CREATE TRIGGER  film_verdict_insert
	after INSERT
	ON films
	FOR EACH ROW
Begin
	IF NEW.GrossCollection < (NEW.production_rights + New.marketting_rights) THEN
		insert into film_verdict values (NEW.id, false);
	else
		insert into film_verdict values (NEW.id, true);
	END IF;
end //

DELIMITER ;

-- 4.  trigger to validate the sum of rating of male and female is equal to total rating

DROP TRIGGER IF EXISTS nutflux.imdb_rating_verification_insert ;
DELIMITER //
CREATE TRIGGER  imdb_rating_verification_insert
	BEFORE INSERT
	ON film_rating
	FOR EACH ROW
Begin
	IF NEW.total_rating <> (NEW.male_rating + New.Female_rating) /2 THEN
		SIGNAL SQLSTATE VALUE '10580'
			SET MESSAGE_TEXT = "[table:film_rating] -Total Rating Does Not match";

	END IF;
end //

DELIMITER ;


-- PROCEDURES IN NUTFLUX

-- 1.  procedure for password recovery

drop procedure if exists nutflux.password_recovery_user ;
delimiter //
create procedure password_recovery_user(in username  text, in emailid text, in answer text,in new_pwd text)
	
begin
	declare question text ;
	if (exists (select *  from users where (name = username or EmailID=emailid) and security_ans = answer)) then 
	   update users set pwd = new_pwd where (name = username or EmailID=emailid);
    end if ;
end //

delimiter ;

-- 2. create a procedure to generate the watchlist based on favorite genre
drop procedure if exists nutflux.pro_users_watchlist ;
delimiter //
create procedure pro_users_watchlist(in user_id  int, in from_year int)
begin
	begin
	 DECLARE finished INTEGER DEFAULT 0;
     DECLARE filmid int;
    if (exists (select * from users where id = user_id and subscriptionType = "Pro" and sub_end_date > current_date())) then
       begin 
		 DECLARE wishlist_film cursor for 
		 select distinct f.id
		 from films f join film_genre fg on f.id = fg.f_id 
		 where fg.g_id in (select ug.g_id  from user_genre ug where ug.u_id = user_id) and f.id not in (select uv.f_id from user_views uv where uv.u_id = user_id) and f.YearOfRelease > from_year
		 order by f.YearOfRelease desc;
         
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
         
         open wishlist_film;
    getFilm : LOOP
			fetch wishlist_film into filmid;
            IF finished = 1 THEN LEAVE getFilm;
            END IF;
            
            -- insert into watchlist table if the film does not already exists in the table
            if filmid not in (select f_id from watchlist where u_id= user_id) then 
			insert into watchlist values (user_id, filmid);
            end if;
	END LOOP getFilm;
	CLOSE wishlist_film;
		end;
	 end if;
	end;
end //

delimiter ;

-- 3. procedure to sort the movies released in a particular period based on critics_rating /  imdb rating 

drop procedure if exists nutflux.sort_movie_ratings ;
delimiter //
create procedure sort_movie_ratings(in start_year  int, in end_year int, in sort_on text)

begin
    if sort_on = "imdb_rating" then
		select f.id, f.title, f.yearofrelease, cfr.imdb
		from films f
		join combined_film_ratings cfr
		on f.id = cfr.filmid
		where  f.YearOfRelease >start_year and f.YearOfRelease<end_year
		order by cfr.IMDB desc;
    elseif sort_on = "critics_rating" then
		select f.id, f.title, f.yearofrelease, cfr.avg_critics_rating
		from films f
		join combined_film_ratings cfr
		on f.id = cfr.filmid
		where f.YearOfRelease >start_year and f.YearOfRelease<end_year
		order by  cfr.avg_critics_rating desc;
    else 
		SIGNAL SQLSTATE VALUE '10581'
		SET MESSAGE_TEXT = "Incorrect Sorting type : Choose either imdb_rating / critics_rating";
    end if;
end //
delimiter ;

-- 4. procedure to extend the subscription

drop procedure if exists nutflux.extend_subscription ;
delimiter //
create procedure extend_subscription()

begin
		DECLARE finished INTEGER DEFAULT 0;
        DECLARE userId int;
        DECLARE pro_user_id cursor for 
			select id  from users where subscriptionType = "Pro" and sub_end_date = current_date() and auto_extend_subscription = true;
		DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finished = 1;	
        
		open pro_user_id;
		getID : LOOP
				fetch pro_user_id into userId;
				IF finished = 1 THEN 
				LEAVE getID;
				END IF;
                update users set sub_end_date = date_add(sub_end_date, interval 29 day) where id = userId;
		END LOOP getID;
		CLOSE pro_user_id;
end //
delimiter ;

-- EVENTS IN NUTFLUX

-- 1. Event to extend the subscription of pro users which occures every day

CREATE EVENT if not exists Subscription_Extension
  ON SCHEDULE EVERY 1 day
STARTS CURRENT_TIMESTAMP

DO 
	call extend_subscription;


