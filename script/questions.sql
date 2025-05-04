-- How many matches were made in 2024 alone? How does this number compare with previous years?

select
	extract(year from created_at) as year -- top: 2024 = 1260
	, count(match_id) as total_matches
from gold.full_matches 
group by 1
order by 1;


-- Draw up an analysis that allows us to understand in which territories we have the most idle volunteers. 
-- We are interested in understanding:
-- - The absolute number of idle volunteers per state
-- - The percentage distribution of idle volunteers by state, 
--   i.e. which states have the highest proportion of idle volunteers in relation to the total observed.

select 
	state
	, count(volunteer_id) as total_idle_volunteers -- top: ce = 14
from silver.volunteers
where status = 'disponivel'
group by 1
order by 2 desc;

select 
	 state 
	 , count(*) as total_idle_volunteers
	 , round(100.0 * count(*) / (select count(*) from silver.volunteers where status = 'disponivel'), 2) as perc
from silver.volunteers
where status = 'disponivel'
group by 1
order by 3 desc;

select 
    state
    , count(volunteer_id) as total_volunteers,
    round(100.0 * count(volunteer_id) / total.total_volunteers, 2) as percentage
from silver.volunteers,
    (select count(*) as total_volunteers 
     from silver.volunteers 
     where status = 'disponivel') as total
where status = 'disponivel'
group by state, total.total_volunteers
order by percentage desc;


