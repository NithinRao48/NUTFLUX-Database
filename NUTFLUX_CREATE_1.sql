drop database if exists nutflux;
create database nutflux;
use nutflux;

-- Create all data tables

-- create users table
create table users ( id int primary key not null, name text not null, pwd varchar(15) ,dob datetime not null, subscriptionType varchar(20) not null, sub_end_date date not null,  Nationality text not null, EmailID varchar(100) unique  check (EmailID like '%_@%_.__%') , security_qn text not null, security_ans text not null,auto_extend_subscription boolean default false);

-- create director table
create table directors ( id int primary key , name text not null,gender text , Nationality text not null);

-- create actors table
create table actors ( id int primary key , real_name text not null,theatre_name text not null,gender text , Nationality text not null);

-- create roles table 
create table roles ( id int primary key , name text not null, FamousQuote text not null);

-- create production table
create table production ( id int primary key , name text not null);

-- create genre table 
create table genre ( id int primary key , name text not null);

-- create writers table
create table writers ( id int primary key , name text not null, gender text );

-- create language table
create table languages ( id int primary key , name text not null);

-- create awarding_institution table
create table awarding_institution ( id int primary key , name text not null);

-- create award_category table
create table award_category ( id int primary key , name text not null);

-- create relation table
create table relation ( id int primary key , name text not null);

-- create role_type table
create table role_type ( id int primary key , name text not null);

-- create films table
create table films (id integer PRIMARY KEY,Title text NOT NULL,YearOfRelease integer NOT NULL, runtime int not null check (runtime > 1), plot text not null,taglines text,GrossCollection decimal(20,9) NOT NULL,production_rights float not null, marketting_rights float not null 					
);

-- create critics table
create table critics ( id int primary key , name text not null, Nationality text not null);


-- create dependent tables

-- create filmcast table
create table filmcast (
	f_id integer NOT NULL,a_id integer NOT NULL,r_id integer NOT NULL,salary float NOT NULL,
    primary key (f_id, a_id, r_id),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(a_id) 
		REFERENCES actors(id) ON DELETE CASCADE ,
	FOREIGN KEY(r_id) 
		REFERENCES roles(id) ON DELETE CASCADE
);

-- create film_languages table 
create table film_languages (
	f_id integer NOT NULL,l_id integer NOT NULL,
    primary key (f_id, l_id),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(l_id) 
		REFERENCES languages(id) ON DELETE CASCADE
);


-- create film_production table 
create table film_production (
	f_id integer NOT NULL,p_id integer NOT NULL,
    primary key (f_id, p_id),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(p_id) 
		REFERENCES production(id) ON DELETE CASCADE
);


-- create film_writers table 
create table film_writers (
	f_id integer NOT NULL,w_id integer NOT NULL,
    primary key (f_id, w_id),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(w_id) 
		REFERENCES writers(id) ON DELETE CASCADE
);

-- create film_directors table 
create table film_directors (
	f_id integer NOT NULL,d_id integer NOT NULL,
    primary key (f_id, d_id),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(d_id) 
		REFERENCES directors(id) ON DELETE CASCADE
);


-- create film_genre table 
create table film_genre (
	f_id integer NOT NULL,g_id integer NOT NULL,
    primary key (f_id, g_id),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(g_id) 
		REFERENCES genre(id) ON DELETE CASCADE
);



-- create role_category table 
create table role_category (
	r_id integer NOT NULL,type_id integer NOT NULL,
    primary key (r_id, type_id),
	FOREIGN KEY(r_id) 
		REFERENCES roles(id) ON DELETE CASCADE ,
	FOREIGN KEY(type_id) 
		REFERENCES role_type(id) ON DELETE CASCADE
);


-- create connections table
create table connections (
	a1_id integer NOT NULL,a2_id integer NOT NULL,relation_id integer NOT NULL,startyear int NOT NULL, endYear int ,
    primary key (a1_id, a2_id),
	FOREIGN KEY(a1_id) 
		REFERENCES actors(id) ON DELETE CASCADE ,
	FOREIGN KEY(a2_id) 
		REFERENCES actors(id) ON DELETE CASCADE ,
	FOREIGN KEY(relation_id) 
		REFERENCES relation(id) ON DELETE CASCADE
);

-- create award_actors tables
create table award_actors (
	a_id integer NOT NULL,f_id integer NOT NULL,ai_id integer not null,ac_id integer NOT NULL,year int NOT NULL,winner_nominee bool not null,
    primary key (a_id, f_id, ac_id),
	FOREIGN KEY(a_id) 
		REFERENCES actors(id) ON DELETE CASCADE ,
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(ai_id) 
		REFERENCES awarding_institution(id) ON DELETE CASCADE,
	FOREIGN KEY(ac_id) 
		REFERENCES award_category(id) ON DELETE CASCADE
);

-- create award_writers tables
create table award_writers (
	w_id integer NOT NULL,f_id integer NOT NULL,ai_id integer not null,ac_id integer NOT NULL,year int NOT NULL, winner_nominee bool not null,
    primary key (w_id, f_id, ac_id),
	FOREIGN KEY(w_id) 
		REFERENCES writers(id) ON DELETE CASCADE ,
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(ai_id) 
		REFERENCES awarding_institution(id) ON DELETE CASCADE,
	FOREIGN KEY(ac_id) 
		REFERENCES award_category(id) ON DELETE CASCADE
);

-- create award_directors tables
create table award_directors (
	d_id integer NOT NULL,f_id integer NOT NULL,ai_id integer not null,ac_id integer NOT NULL,year int NOT NULL,winner_nominee bool not null,
    primary key (d_id, f_id, ac_id),
	FOREIGN KEY(d_id) 
		REFERENCES directors(id) ON DELETE CASCADE ,
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE ,
	FOREIGN KEY(ai_id) 
		REFERENCES awarding_institution(id) ON DELETE CASCADE,
	FOREIGN KEY(ac_id) 
		REFERENCES award_category(id) ON DELETE CASCADE
);








-- create user_genre table 
create table user_genre (
	u_id integer NOT NULL,g_id integer NOT NULL,
    primary key (u_id, g_id),
	FOREIGN KEY(u_id) 
		REFERENCES users(id) ON DELETE CASCADE ,
	FOREIGN KEY(g_id) 
		REFERENCES genre(id) ON DELETE CASCADE
);



-- create critics_reviews table 
create table critics_reviews (
	c_id integer NOT NULL,f_id integer NOT NULL, rating decimal(4,2) not null check(rating <=10.0 and rating >=0.0), comments text ,
    primary key (c_id, f_id),
	FOREIGN KEY(c_id) 
		REFERENCES critics(id) ON DELETE CASCADE ,
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE
);

-- create film_rating table
create table film_rating (
	f_id integer NOT NULL,male_rating decimal(3,2) not null ,female_rating decimal(4,2) not null, total_rating decimal(3,2) check(total_rating<=10.0 and total_rating>=0.0),
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE
);


-- create film_verdict table
create table film_verdict (f_id int , verdict_hit boolean not null ,   
							FOREIGN KEY(f_id) 
							REFERENCES films(id) ON DELETE CASCADE);		
 
-- create user_views table
create table user_views (
	u_id integer NOT NULL,f_id integer NOT NULL, liked boolean not null,rating decimal(4,2) check(rating <=10.0 and rating >=0.0), comments text,
    primary key (u_id, f_id),
	FOREIGN KEY(u_id) 
		REFERENCES users(id) ON DELETE CASCADE ,
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE
);



-- create watchlist table for pro users
create table watchlist (
	u_id integer NOT NULL,f_id integer NOT NULL,
	FOREIGN KEY(u_id) 
		REFERENCES users(id) ON DELETE CASCADE ,
	FOREIGN KEY(f_id) 
		REFERENCES films(id) ON DELETE CASCADE
);




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


 use nutflux;
 
-- Insert data into Nutflux Database

-- Insert into Users
insert into users values (1,"Nithin","chicharito#@0M","1997-10-18","Standard","2022-10-18","Indian","nsrao48@gmail.com","My favourite Car","Audi",false);
insert into users values (2,"Paul","qwert1234M@","1993-10-23","Pro","2022-08-20","Italian","paulwalker98@gmail.com","My Favourite Film","Fast and Furious", true);
insert into users values (3,"hrithik","xecrv12@#@","1995-11-25","Pro","2022-04-30","Indian","hrithikshg98@gmail.com","My Favourite food","biryani",false);


-- Insert into directors table
insert into directors values (1,"Greg McLean","Male", "Austrailian");
insert into directors values (2,"David Twohy","Male", "American");
insert into directors values (3,"Justin Lin","Male", "American");
insert into directors values (4,"Quentin Tarantino","Male", "American");
insert into directors values (5,"Doug Limon","Male", "American");
insert into directors values (6,"Martin Campbell","Male", "English");
insert into directors values (7,"John Krasinski","Male", "English");
insert into directors values (8,"Christopher Nolan","Male", "English");
insert into directors values (9,"Francis Ford Coppola","Male", "Italian");

-- Insert into Actors table
insert into actors values (1,"Kevin Bacon","Kevin Bacon", "Male","American");
insert into actors values (2,"Radha Mitchell","Radha Mitchell", "Female","Austrailian");
insert into actors values (3,"Daniel Radcliffe","Daniel Radcliffe", "Male","English");
insert into actors values (4,"Thomas Kretschmann","Thomas Kretschmann", "Male","German");
insert into actors values (5,"Alex Russel","Alex Russel", "Male","Austrailian");	
insert into actors values (6,"Cole Hauser","Cole Hauser", "Male","American");	
insert into actors values (7,"Mark Sinclair","Vin Diesel", "Male","American");	
insert into actors values (8,"Paul Walker","Paul Walker", "Male","American");
insert into actors values (9,"Dwayne Johnson","Dwayne Johnson", "Male","American");
insert into actors values (10,"Leonardo DiCaprio","Leonardo DiCaprio", "Male","American");	
insert into actors values (11,"Brad Pitt","Brad Pitt", "Male","American");
insert into actors values (12,"Margot Robbie","Margot Robbie", "Female","Austrailian");
insert into actors values (13,"Jamie Foxx","Jamie Foxx", "Male","American");
insert into actors values (14,"Christoph Waltz","Christoph Waltz", "Male","German");
insert into actors values (15,"Angelina Jolie","Angelina Jolie","Female","American");
insert into actors values (16,'Jeniffer Aniston','Jeniffer Aniston',"Female",'American');
insert into actors values (17,'Ryan Reynolds','Ryan Reynolds',"Male",'American');
insert into actors values (18,'Blake Lively','Blake Lively',"Female",'English');
insert into actors values (19,'Emily Blunt','Emily Blunt',"Female",'English');
insert into actors values (20,'John Krasinski','John Krasinski',"Male",'Polish');
insert into actors values (21,'Christian Bale','Christian Bale',"Male",'English');
insert into actors values (22,'Heath Ledger','Heath Ledger',"Male",'Austrailian');
insert into actors values (23,'Marlon Brando','Marlon Brando',"Male",'Spanish');
insert into actors values (24,'Robert De Niro','Robert De Niro',"Male",'Spanish');





-- insert into roles table
insert into roles values (1, "Peter Taylor", "You take me instead you live him alone");
insert into roles values (2, "Bronny Taylor", "You are scaring him");
insert into roles values (3, "Yossi Ghinsberg", "I told my parents I'd be back in a year, but I don't think I'm ever going back");
insert into roles values (4, "Karl", "This is the last frontier on earth. Still alive, still wild. Not for long. We don't like wild. We don't like untamed. We're obsessed with control. So, we ruin the whole planet, and pride ourselves for creating stupid national parks with stupid rangers in stupid hats to protect what's already gone. Why? Cause we're scared. The jungle shows us what we really are. We're nothing. We're a joke. God fucked up.");
insert into roles values (5, "Kevin", "");
insert into roles values (6, "Carolyn Fry", "Cause you're 79 kilos of gutless white meat, and that's why you can't think of a better plan.");
insert into roles values (7, "William J. Johns", "Somebody's gonna get hurt one of these days. It ain't gonna be me.");
insert into roles values (8, "Richar B. Riddick", "All you people are so scared of me. Most days I'd take that as a compliment. But it ain't me you gotta worry about now.");
insert into roles values (9, "Dominic Toretto", "You don't turn your back on family, even when they do.");
insert into roles values (10, "Brian O'Conner", "Hey! We do what we do best. We improvise, all right?");
insert into roles values (11, "Hobbs", " I never thought I'd trust a criminal. Till next time.");
insert into roles values (12, "Rick Dalton", "What the hell are you looking at, you little ginger-haired fucker?");
insert into roles values (13, "Cliff Booth", "Hey! You're Rick fucking Dalton. Don't you forget it.");
insert into roles values (14, "Sharon Tate", "Aww, what's the matter? You afraid I'll tell Jim Morrison you were dancing to Paul Revere & The Raiders? Are they not cool enough for you?");
insert into roles values (15, "Django", "Hey, little troublemaker.");
insert into roles values (16, "Dr. King Shultz", "You silver tongued devil, you.");
insert into roles values (17, "Calvin Candie", "Your boss looks a little green around the gills.");
insert into roles values (18,"John Smith","I can't believe I brought my real parents to our wedding.");
insert into roles values (19,"Jane Smith"," There's nowhere I'd rather be than here with you.");
insert into roles values (20,"Hal Jordan","To infinity and beyond!... By the power of Grayskull!");
insert into roles values (21,"Carol Ferris","Wait, go back. How did the ring make a mistake?");
insert into roles values (22,"Evelyn Abbott","Your father will protect you. Your father will always protect you.");
insert into roles values (23,"Lee Abbott","I love you. I've always loved you.");
insert into roles values (24,"Lt. Aldo Raine","I'm gonna give you a little somethin' you can't take off.");
insert into roles values (25,"Col. Hans landa"," I love rumors! Facts can be so misleading, where rumors, true or false, are often revealing.");
insert into roles values (26,"Bruce Wayne","I am Batman..");
insert into roles values (27,"Joker","Why so serious?");
insert into roles values (28,"Don Vito Corleone","My godson has come all the way from California. Give him a drink.");







-- insert into production table
insert into production values (1,"Blum House production");
insert into production values (2,"Chapter One Films");
insert into production values (3,"Babber Films");
insert into production values (4,"Cutting Edge Group");
insert into production values (5,"Screen Austrailia");
insert into production values (6,"Polygram Filmed Entertainment");
insert into production values (7,"Interscope Communications");
insert into production values (8,"Universal Pictures");
insert into production values (9,"Relativity Media");
insert into production values (10,"Orginal Film");
insert into production values (11,"Columbia pictures");
insert into production values (12,"Bona Film Group");
insert into production values (13,"HeyDay films");
insert into production values (14,"Weinstein Company");
insert into production values (15,"Warner Bros");
insert into production values (16,"De Line Pictures");
insert into production values (17,"DC Entertainment");






-- insert into genre table
insert into genre values (1, "Horror");
insert into genre values (2, "Thriller");
insert into genre values (3, "Action");
insert into genre values (4, "Adventure");
insert into genre values (5, "Biography");
insert into genre values (6, "Drama");
insert into genre values (7, "Sci-Fi");
insert into genre values (8, "Crime");
insert into genre values (9, "Comedy");
insert into genre values (10, "Western");
insert into genre values (11, "Romantic");
insert into genre values (12, "war");



-- insert into writes table
insert into writers values (1,"Greg McLean","Male");
insert into writers values (2,"Shayne Armstrong","Male");
insert into writers values (3,"S.P. Krause","Male");
insert into writers values (4,"Yossi Ghinsberg","Male");
insert into writers values (5,"Justin Monjo","Male");
insert into writers values (6,"Jim Wheat","Male");
insert into writers values (7,"Ken Wheat","Male");
insert into writers values (8,"Chris Morgan","Male");
insert into writers values (9,"Gray Scott Thompson","Male");
insert into writers values (10,"Quentin Tarantino","Male");
insert into writers values (11,"Simon Kinberg","Male");
insert into writers values (12,"Greg Berlanti","Male");
insert into writers values (13,"Michael Green","Male");
insert into writers values (14,"Marc Guggenheim","Male");
insert into writers values (15,"Bryan Woods","Male");
insert into writers values (16,"Scott Beck","Male");
insert into writers values (17,"Jonathan Nolan","Male");
insert into writers values (18,"Christopher Nolan","Male");



-- insert into languages table
insert into languages values (1,"English");
insert into languages values (2,"Arabic");
insert into languages values (3,"Danish");
insert into languages values (4,"Spanish");
insert into languages values (5,"Russian");
insert into languages values (6,"Japanese");
insert into languages values (7,"Dutch");
insert into languages values (8,"Hindi");
insert into languages values (9,"Italian");
insert into languages values (10,"German");
insert into languages values (11,"French");

-- insert into awarding_institution table
insert into awarding_institution values (1,"Oscar");
insert into awarding_institution values (2,"MTV");
insert into awarding_institution values (3,"Choice");
insert into awarding_institution values (4,"NRJ Cine");
insert into awarding_institution values (5,"BAFTA");
insert into awarding_institution values (6,"Filmfare");


-- insert into award_category table
insert into award_category values (1,"Best Dramatic Feature");
insert into award_category values (2,"Best Male Action Superstar");
insert into award_category values (3,"Best Achievement in Directing");
insert into award_category values (4,"Best Original Screenplay");
insert into award_category values (5,"Best Performance by an Actor in a Supporting Role");
insert into award_category values (6,"Choice Movie Actress: Action Adventure/Thriller");
insert into award_category values (7,"Actor of the Year (Acteur de l'année)");
insert into award_category values (8,"Best Actor in Leading Role");







-- insert into relation table
insert into relation values (1,'married');
insert into relation values (2,'Divorced');
insert into relation values (3,'Dating');
insert into relation values (4,'Longtime-Friend');
insert into relation values (5,'kin');








-- insert into role_type table
insert into role_type values (1, 'doctor');
insert into role_type values (2, 'superhero');
insert into role_type values (3, 'magician');
insert into role_type values (4, 'hero');
insert into role_type values (5, 'playboy');
insert into role_type values (6, 'philanthropist');
insert into role_type values (7, 'CEO');
insert into role_type values (8, 'thief');
insert into role_type values (9, 'alien');
insert into role_type values (10, 'spy');
insert into role_type values (11, 'detective');
insert into role_type values (12, 'politician');
insert into role_type values (13, 'killer');
insert into role_type values (14, 'villian');
insert into role_type values (15, 'military');
insert into role_type values (16, 'maniac');





-- insert into films table
insert into films values (1,"The Darkness",2016,92, "A family unknowingly awakens an ancient supernatural entity on a Grand Canyon vacation, and must fight for survival when it follows them home.","Evil comes home",10898293,8000000,3000000);
insert into films values (2,"Jungle",2017,145,"In the pursuit of self-discovery and authentic experiences, the Israeli backpacker, Yossi Ghinsberg, meets a cryptic Austrian geologist in La Paz, Bolivia, and captivated by his engrossing stories of lost tribes, uncharted adventures and even gold, decides to follow him, circa 1981. Without delay and accompanied by the good friends, Kevin, an American photographer, and Marcus, a Swiss teacher, they join an expedition led by their seasoned trail-leader, deep into the emerald and impenetrable Amazonian rainforest. However, as the endless and inhospitable jungle separates the inexperienced team, before long, Yossi will find himself stranded in the depths of a nightmarish environment crawling with formidable and tireless adversaries. How can one escape this green maze?","Nature Has Only One Law - Survival.",1906640,500000,400000);
insert into films values (3,"Pitch Black",2000,109,"A commercial transport ship and its crew are marooned on a planet full of bloodthirsty creatures that only come out to feast at night. But then, they learn that a month-long eclipse is about to occur.","Fight Evil With Evil",53187659,25000000,1000000);
insert into films values (4,"Fast and Furious 6",2013,130,"Hobbs has Dominic and Brian reassemble their crew to take down a team of mercenaries: Dominic unexpectedly gets sidetracked with facing his presumed deceased girlfriend, Letty.","All roads lead to this",160000000,18000000,10000000);
insert into films values (5,"Once Upon A Time in Hollywood",2019,130,"A faded television actor and his stunt double strive to achieve fame and success in the final years of Hollywood's Golden Age in 1969 Los Angeles.","All roads lead to this",160000000,18000000,10000000);
insert into films values (6,"Django Unchained",2012,165,"With the help of a German bounty-hunter, a freed slave sets out to rescue his wife from a brutal plantation-owner in Mississippi.","Life, liberty and the pursuit of vengeance.",426074373,18000000,10000000);
insert into films values (7,"Mr And Mrs Smith",2005,120,"A bored married couple is surprised to learn that they are both assassins hired by competing agencies to kill each other.","Assasins Game of Life",487287646,280000000,30000000);
insert into films values (8,"Green Lantern",2011,114,"Reckless test pilot Hal Jordan is granted an alien ring that bestows him with otherworldly powers that inducts him into an intergalactic police force, the Green Lantern Corps.","One of us... becomes one of them.",219851172,280000000,200000000);
insert into films values (9,"Quiet Place",2018,150,"In a post-apocalyptic world, a family is forced to live in silence while hiding from monsters with ultra-sensitive hearing.","If they hear you, they hunt you.",340952971,200000000,20000000);
insert into films values (10,"Inglourious Basterds",2009,153,"In Nazi-occupied France during World War II, a plan to assassinate Nazi leaders by a group of Jewish U.S. soldiers coincides with a theatre owner's vengeful plans for the same.","If You Need Heroes, Send In The Basterds",70000000,25000000,20000000);
insert into films values (11,"The Dark Knight",2008,152,"When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.","Why So serious",185000000,25000000,20000000);
insert into films values (12,"The Godfather 1972",1972,175,"The aging patriarch of an organized crime dynasty in postwar New York City transfers control of his clandestine empire to his reluctant youngest son.","An offer you can't refuse.",250354816,18007654,89897670);
insert into films values (13,"The Godfather 1975",1975,155,"The early life and career of Vito Corleone in 1920s New York City is portrayed, while his son, Michael, expands and tightens his grip on the family crime syndicate.","All the power on earth can't change destiny.",150354816,48007654,56897670);

-- insert into critics table
insert into critics values (1,"Richard Cross","English");
insert into critics values (2,"Mathew Huntley","Austrailian");
insert into critics values (3,"Harry Wilson","American");
insert into critics values (4,"Bony Parrington","American");
insert into critics values (5,"Lisa Hessington","German");



-- insert into filmcast table
insert into filmcast values (1,1,1,1000000);
insert into filmcast values (1,2,2,500000);
insert into filmcast values (2,3,3,780000);
insert into filmcast values (2,4,4,550000);
insert into filmcast values (2,5,5,400000);
insert into filmcast values (3,2,6,400000);
insert into filmcast values (3,6,7,500000);
insert into filmcast values (3,7,8,1000000);
insert into filmcast values (4,7,9,5000000);
insert into filmcast values (4,8,10,3000000);
insert into filmcast values (4,9,11,2000000);
insert into filmcast values (5,10,12,5000000);
insert into filmcast values (5,11,13,4500000);
insert into filmcast values (5,12,14,3000000);
insert into filmcast values (6,10,16,5000000);
insert into filmcast values (6,13,15,8500000);
insert into filmcast values (6,14,16,3000000);
insert into filmcast values (7,11,18,5500000);
insert into filmcast values (7,15,19,5000000);
insert into filmcast values (8,17,20,5500000);
insert into filmcast values (8,18,21,5000000);
insert into filmcast values (9,19,22,4500000);
insert into filmcast values (9,20,23,5000000);
insert into filmcast values (10,11,24,5500000);
insert into filmcast values (10,14,25,4000000);
insert into filmcast values (11,21,26,5500000);
insert into filmcast values (11,22,27,4000000);
insert into filmcast values (12,23,28,4000000);
insert into filmcast values (13,24,28,4000000);




-- insert into connections tables

insert into connections values (11,15,2,2014,2019);
insert into connections values (11,16,2,2000,2005);
insert into connections values (17,18,1,2012,2022);
insert into connections values (19,20,1,2010,2022);


-- insert into award_actors table
insert into award_actors values (7,4,5,2,2014,1);
insert into award_actors values (11,5,1,5,2020,1);
insert into award_actors values (14,6,1,5,2013,1);
insert into award_actors values (11,7,4,7,2006,1);
insert into award_actors values (15,7,3,6,2006,1);
insert into award_actors values (14,10,1,5,2010,1);
insert into award_actors values (22,11,1,5,2009,1);
insert into award_actors values (23,12,1,8,1973,1);
insert into award_actors values (24,13,1,8,1975,1);




-- insert into award_writers table
insert into award_writers values (10,5,1,4,2020,0);
insert into award_writers values (10,6,1,4,2013,1);
insert into award_writers values (10,10,1,4,2010,0);



-- insert into award_directors table
insert into award_directors values (1,2,5,1,2017,1);
insert into award_directors values (4,5,1,3,2020,0);
insert into award_directors values (4,10,1,3,2010,0);




-- insert into film_language tables
insert into film_languages values (1,1);
insert into film_languages values (2,1);
insert into film_languages values (3,1);
insert into film_languages values (3,2);
insert into film_languages values (4,1);
insert into film_languages values (4,3);
insert into film_languages values (4,4);
insert into film_languages values (4,5);
insert into film_languages values (4,6);
insert into film_languages values (4,7);
insert into film_languages values (5,1);
insert into film_languages values (5,4);
insert into film_languages values (5,9);
insert into film_languages values (5,10);
insert into film_languages values (6,1);
insert into film_languages values (6,10);
insert into film_languages values (6,11);
insert into film_languages values (6,9);
insert into film_languages values (7,1);
insert into film_languages values (7,5);
insert into film_languages values (8,1);
insert into film_languages values (9,1);
insert into film_languages values (10,1);
insert into film_languages values (10,10);
insert into film_languages values (10,11);
insert into film_languages values (10,9);
insert into film_languages values (11,1);
insert into film_languages values (12,1);
insert into film_languages values (13,1);

-- insert into film_production tables
insert into film_production values (1,1);
insert into film_production values (1,2);
insert into film_production values (2,3);
insert into film_production values (2,4);
insert into film_production values (2,5);
insert into film_production values (3,6);
insert into film_production values (3,7);
insert into film_production values (4,8);
insert into film_production values (4,9);
insert into film_production values (4,10);
insert into film_production values (5,11);
insert into film_production values (5,12);
insert into film_production values (5,13);
insert into film_production values (6,11);
insert into film_production values (6,14);
insert into film_production values (7,9);
insert into film_production values (7,10);
insert into film_production values (8,15);
insert into film_production values (8,16);
insert into film_production values (8,17);
insert into film_production values (9,8);
insert into film_production values (9,9);
insert into film_production values (10,5);
insert into film_production values (11,15);
insert into film_production values (12,11);
insert into film_production values (13,11);

-- insert into film_writers table
insert into film_writers values (1,1);
insert into film_writers values (1,2);
insert into film_writers values (1,3);
insert into film_writers values (2,4);
insert into film_writers values (2,5);
insert into film_writers values (3,6);
insert into film_writers values (3,7);
insert into film_writers values (4,8);
insert into film_writers values (4,9);
insert into film_writers values (5,10);
insert into film_writers values (6,10);
insert into film_writers values (7,11);
insert into film_writers values (8,12);
insert into film_writers values (8,13);
insert into film_writers values (8,14);
insert into film_writers values (9,15);
insert into film_writers values (9,16);
insert into film_writers values (10,10);
insert into film_writers values (11,17);
insert into film_writers values (11,18);
insert into film_writers values (12,9);
insert into film_writers values (13,9);




-- insert into film_directors table
insert into film_directors values (1,1);
insert into film_directors values (2,1);
insert into film_directors values (3,2);
insert into film_directors values (4,3);
insert into film_directors values (5,4);
insert into film_directors values (6,4);
insert into film_directors values (7,5);
insert into film_directors values (8,6);
insert into film_directors values (9,7);
insert into film_directors values (10,4);
insert into film_directors values (11,8);
insert into film_directors values (12,9);
insert into film_directors values (13,9);

-- insert into film_genre table
insert into film_genre values (1,1);
insert into film_genre values (1,2);
insert into film_genre values (2,3);
insert into film_genre values (2,4);
insert into film_genre values (2,5);
insert into film_genre values (2,6);
insert into film_genre values (2,2);
insert into film_genre values (3,1);
insert into film_genre values (3,2);
insert into film_genre values (3,3);
insert into film_genre values (3,7);
insert into film_genre values (4,2);
insert into film_genre values (4,3);
insert into film_genre values (4,8);
insert into film_genre values (5,6);
insert into film_genre values (5,9);
insert into film_genre values (6,10);
insert into film_genre values (6,6);
insert into film_genre values (7,2);
insert into film_genre values (7,3);
insert into film_genre values (7,9);
insert into film_genre values (7,8);
insert into film_genre values (8,3);
insert into film_genre values (8,4);
insert into film_genre values (8,7);
insert into film_genre values (9,6);
insert into film_genre values (9,1);
insert into film_genre values (9,7);
insert into film_genre values (10,4);
insert into film_genre values (10,6);
insert into film_genre values (10,12);
insert into film_genre values (11,2);
insert into film_genre values (11,3);
insert into film_genre values (11,6);
insert into film_genre values (11,8);
insert into film_genre values (12,4);
insert into film_genre values (12,8);
insert into film_genre values (12,3);
insert into film_genre values (13,4);
insert into film_genre values (13,8);
insert into film_genre values (13,3);

-- insert into role_category table
insert into role_category values(18,4);
insert into role_category values(18,10);
insert into role_category values(18,13);
insert into role_category values(19,10);
insert into role_category values(19,13);
insert into role_category values(25,15);
insert into role_category values(25,14);
insert into role_category values(25,13);
insert into role_category values(27,8);
insert into role_category values(27,13);
insert into role_category values(27,14);
insert into role_category values(27,16);
insert into role_category values(26,2);
insert into role_category values(26,4);
insert into role_category values(26,6);
insert into role_category values(26,7);

-- insert into user_genre
insert into user_genre values(2, 7);
insert into user_genre values(2, 2);
insert into user_genre values(2, 5);


-- insert into user_reviews table
insert into user_views values (1,5,true,9.0,"Leanardo Dicaprio is the best actor and should definitely win an oscar.");
insert into user_views values (1,8,true,8.9,"Awww.. I love them both together. Must watch for Brad Pitt Fans");
insert into user_views values (1,2,true,7.9,"Too confusing, But one time watch");
insert into user_views values (2,1,true,8.9,"Great screen Play, Great story telling");
insert into user_views values (2,5,true,9.9,"Beautiful");
insert into user_views values (2,9,false,1.9,"LOL");
insert into user_views values (1,11,true,7.9,"Too confusing, But one time watch");
insert into user_views values (2,3,true,8.9,"Great screen Play, Great story telling");
insert into user_views values (2,4,true,10.0,"marvellous");
insert into user_views values (2,7,true,8.9,"super");
insert into user_views values (2,13,true,10.0,"marvellous");
insert into user_views values (2,12,true,8.9,"super");




-- insert into critics_reviews table
insert into critics_reviews values (1,1,6.6,"It's the sort of movie in which websites concerning the paranormal all appear to have been designed on geocities in 1999. It's the sort of movie in which every TV set glimpsed is always playing a public domain horror movie. It's the sort of movie genre snobs use as a weapon to beat on horror fans.");
insert into critics_reviews values (1,4, 8.2,"They managed to change things up while still sticking to the OG aspects including fast cars, family, and working within a team his is the best installment to the franchise since the original movie");
insert into critics_reviews values (1,7,7.5,"It may be unfair to say, but its easily admitted that the most interesting ploy this film can rely on was the media storm surrounding 'THE affair' that led to 'THE Hollywood couple to be' Brangelina. As a matter of fact, the film is actually rather good and the playful yet genuine chemistry berween Pitt and Jolie excuses the ludicrous plot and reliance on marketing gimmicks. The film really isn't a serious one, but it is a sexy one.");
insert into critics_reviews values (1,8,3.5," Worst supernatural movie till date having no basis and foundation on which the movie is scripted. Only reason to watch would be the leads");
insert into critics_reviews values (1,2,6.5,"");
insert into critics_reviews values (1,3,6.8,"");
insert into critics_reviews values (1,5,7.8,"");
insert into critics_reviews values (1,6,7.5,"");
insert into critics_reviews values (1,9,6.1,"");
insert into critics_reviews values (2,1,6.5,"");
insert into critics_reviews values (2,2,6.8,"");
insert into critics_reviews values (2,3,6.5,"");
insert into critics_reviews values (2,4,7.8,"");
insert into critics_reviews values (2,5,8.8,"");
insert into critics_reviews values (2,6,7.8,"");
insert into critics_reviews values (2,7,6.8,"");
insert into critics_reviews values (2,8,5.0,"");
insert into critics_reviews values (2,9,6.8,"");
insert into critics_reviews values (3,1,5.5,"");
insert into critics_reviews values (3,2,5.8,"");
insert into critics_reviews values (3,3,6.8,"");
insert into critics_reviews values (3,4,8.0,"");
insert into critics_reviews values (3,5,9.2,"");
insert into critics_reviews values (3,6,7.0,"");
insert into critics_reviews values (3,7,6.2,"");
insert into critics_reviews values (3,8,6.0,"");
insert into critics_reviews values (3,9,7.0,"");
insert into critics_reviews values (4,1,5.5,"");
insert into critics_reviews values (4,2,5.9,"");
insert into critics_reviews values (4,3,6.5,"");
insert into critics_reviews values (4,4,7.0,"");
insert into critics_reviews values (4,5,7.8,"");
insert into critics_reviews values (4,6,7.5,"");
insert into critics_reviews values (4,7,5.8,"");
insert into critics_reviews values (4,8,4.5,"");
insert into critics_reviews values (4,9,5.8,"");
insert into critics_reviews values (5,1,5.8,"");
insert into critics_reviews values (5,2,6.9,"");
insert into critics_reviews values (5,3,7.5,"");
insert into critics_reviews values (5,4,8.0,"");
insert into critics_reviews values (5,5,8.8,"");
insert into critics_reviews values (5,6,8.5,"");
insert into critics_reviews values (5,7,6.8,"");
insert into critics_reviews values (5,8,7.5,"");
insert into critics_reviews values (5,9,7.8,"");











-- insert into film_rating table
insert into film_rating values (1,4.4, 4.6,4.5);
insert into film_rating values (2,6.6, 6.8,6.7);
insert into film_rating values (3,7.0,7.2,7.1);
insert into film_rating values (4,7.1,6.9,7.0);
insert into film_rating values (5,7.8,7.4,7.6);
insert into film_rating values (6,8.4,8.4,8.4);
insert into film_rating values (7,4.4,5.0,4.7);
insert into film_rating values (8,5.5,5.5,5.5);
insert into film_rating values (9,7.5,7.5,7.5);
insert into film_rating values (10,8.3,8.3,8.3);
insert into film_rating values (11,9.1,8.9,9.0);
insert into film_rating values (12,9.1,9.3,9.2);
insert into film_rating values (13,9.1,8.9,9.0);


USE NUTFLUX;

-- EXAMPLE QUERIES RELATED TO VIEWS IN NUTFLUX

-- 1. Show me details of all the hit movies in which Critics Rating is greater than the IMDB rating.  

select cfr.films, cfr.imdb, cfr.avg_user_rating, cfr.avg_critics_rating, f.yearofrelease, fv.verdict_hit
from combined_film_ratings cfr
join films f on f.id = cfr.filmid
join film_verdict fv on cfr.filmid = fv.f_id
where cfr.avg_critics_rating > cfr.imdb and fv.verdict_hit = 1;

-- 2. Show me the actors who have won Choice awards for the film with IMDB rating below 5.0?

select * 
from awarded_actors_rating 
where total_rating <5.0 and award_institution= "Choice"; 

-- 3. Sort the pair of socially connected pair of actors who have the highest versatility score?

select vs1.actorName as actor1, vs2.actorName as actor2, sum(vs1.versatility_score + vs2.versatility_score) as total_score
from versatility_score vs1 join connectionS c on vs1.actorID = c.a1_id 
join versatility_score vs2 on vs2.actorID = c.a2_id 
where vs1.actorID <> vs2.actorID
group by vs1.actorID,vs2.actorID
order by total_score desc;

-- 4. Show me the movies in which actors have won at least 1 award and overall, the movie has won at least 2 awards.

select f.id, f.title,fan.actor_awards,actor_awards+director_awards+ writer_awards as total_awards
from films_awards_nomination fan join films f on f.id = fan.id
where fan.actor_awards >=1 and actor_awards+director_awards+ writer_awards >2 ;


-- SAMPLE QUERIES FOR STANDARD AND PRO USERS


-- 1. Get movie recommendations based on  previously liked films having same actors

select f.title, f.yearofrelease, f.plot, f.taglines, f.grosscollection from films f join filmcast fc on f.id = fc.f_id 
where fc.a_id in
	(select a_id
	from user_views uv
	join filmcast fc on uv.f_id = fc.f_id
	where u_id = 1 and uv.liked = 1) 
    and 
    f.id not in 	
    (select f_id 
	 from user_views  
	 where u_id = 1);
     
-- 2. Give insight about the movie ("Once Upon A time in Hollywood") with information about the previous hit of director.
select distinct title as previous_hit, d.name as director, f.YearOfRelease as year
from film_verdict fv
join films f 
on fv.f_id = f.id
join film_directors fd
on fv.f_id = fd.f_id
join directors d
on fd.d_id = d.id
where fd.d_id in 
				(select d_id 
				 from films join film_directors on id = f_id
                 where title ="Once Upon A time in Hollywood") 
		and fv.verdict_hit = 1 and f.title <> "Once Upon A time in Hollywood";
        
        
-- 3. Create a watchlist for NUTFLUX Pro user (User id = 2) which involves films released after 2000. 

call pro_users_watchlist(2,2000);
select * 
from watchlist w join films f on w.f_id  = f.id 
where u_id = 2;


-- 4. Sort the Movies based on average critics rating that were released between 2000 and 2020.

call sort_movie_ratings(2000,2020,"critics_rating");

-- 5. Show the movies in which the villain has won an Oscar for the role played in the movie.

select  a.theatre_name as actor, r.name as role, f.title as film, ai.name as awarding_institution,ac.name as award, aa.year as year
from films f join award_actors aa on aa.f_id = f.id
join award_category ac on aa.ac_id = ac.id
join actors a on aa.a_id = a.id
join filmcast fc on aa.a_id = fc.a_id and fc.f_id = aa.f_id
join roles r on r.id = fc.r_id
join awarding_institution ai on aa.ai_id = ai.id
join role_category rc on r.id = rc.r_id
join role_type rt on rc.type_id = rt.id
where ai.name = "Oscar" and rt.name = "villian";

-- 6. What is the name of the actors to win two Oscars for the same role?

select a.theatre_name as actor, r.name as role, f.title as film, f.yearofrelease 
from films f join filmcast fc on f.id = fc.f_id
join actors a on a.id = fc.a_id
join roles r on r.id = fc.r_id where r.name in 
(select role
from awarded_actors_rating aar
where award_institution = "Oscar"
group by aar.role
having count(*) =2);

-- Extra queries which is not part of the report but included in the white paper

-- List all films with starring two actors that were socially connected before the film was directed.

select a1.real_name as actor1_Name, a2.real_name as actor2_name , r.name as relation, f.title as movie_starred_together
from films f join filmcast fc1 on f.id = fc1.f_id 
join actors a1 on a1.id = fc1.a_id
join filmcast fc2 on f.id = fc2.f_id 
join actors a2 on a2.id = fc2.a_id
join connections c on (fc1.a_id= c.a1_id and fc2.a_id= c.a2_id)
join relation r on c.relation_id = r.id
where f.YearOfRelease < c.startyear;

-- List all films with starring two actors that become socially connected on or after the release of the film.
select a1.real_name as actor1_Name, a2.real_name as actor2_name , r.name as relation, f.title as movie_starred_together
from films f
	join filmcast fc1
    on f.id = fc1.f_id 
    join actors a1
    on a1.id = fc1.a_id
    join filmcast fc2
    on f.id = fc2.f_id 
    join actors a2
    on a2.id = fc2.a_id
    join connections c
    on (fc1.a_id= c.a1_id and fc2.a_id= c.a2_id)
    join relation r
    on c.relation_id = r.id
where f.YearOfRelease > c.startyear;


-- Creating view for suitability score of an actor
create view  suitabilityscore as
select a.theatre_name as actor_name,rt.name as category,count(*) as suitability_score
from films f
join filmcast fc
on f.id = fc.f_id
join actors a
on fc.a_id = a.id
join roles r 
on fc.r_id =r.id
join role_category rc
on rc.r_id = r.id
join role_type rt
on rc.type_id =rt.id
group by a.theatre_name, rc.type_id;

-- Gettign the suitablility score for each actor
select * from suitabilityscore;

-- a view that assigns a suitability score to each actor for every character they might have played, or might be asked to play in the future.
create view  actor_role_score as
select a.theatre_name as actorName, r.name as roleName, sum(suitability_score) as tot_score
from actors a
inner join roles r
join role_category rc
on r.id = rc.r_id
join role_type rt
on rt.id= rc.type_id
join suitabilityscore ss
on a.theatre_name =ss.actor_name and rt.name = ss.category
group by a.theatre_name,r.name;

select * from actor_role_score;
