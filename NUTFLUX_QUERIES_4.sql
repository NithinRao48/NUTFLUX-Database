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

