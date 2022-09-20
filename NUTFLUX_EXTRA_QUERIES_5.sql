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
