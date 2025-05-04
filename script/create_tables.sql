-- schemas
create schema bronze;
create schema silver;
create schema gold;

-- bronze
drop table if exists bronze.msrs;
create table bronze.msrs (
    msr_id text,
    city text,
    state text
);

drop table if exists bronze.volunteers;
create table bronze.volunteers (
    volunteer_id text,
    status text,
    city text,
    state text
);

drop table if exists bronze.matches;
create table bronze.matches (
    match_id text,
    msr_id text,
    volunteer_id text,
    created_at text
);

-- silver
drop table if exists silver.msrs cascade;
create table silver.msrs (
    msr_id varchar(20) primary key,
    city varchar(50),
    state varchar(5)
);

drop table if exists silver.volunteers cascade;
create table silver.volunteers (
    volunteer_id varchar(20) primary key,
    status varchar(15),
    city varchar(50),
    state varchar(15)
);

drop table if exists silver.matches cascade;
create table silver.matches (
    match_id varchar(20) primary key,
    msr_id varchar(20) not null,
    volunteer_id varchar(20) not null,
    created_at timestamp not null,
    foreign key (msr_id) references silver.msrs(msr_id),
    foreign key (volunteer_id) references silver.volunteers(volunteer_id)
);

-- populating the silver schema after import csv
insert into silver.msrs (msr_id, city, state)
select
  msr_id,
  city,
  state
from bronze.msrs;

insert into silver.volunteers (volunteer_id, status, city, state)
select
  volunteer_id,
  status,
  city,
  state
from bronze.volunteers;

insert into silver.matches (match_id, msr_id, volunteer_id, created_at) -- ensure referential integrity
select
  match_id,
  msr_id,
  volunteer_id,
  created_at::timestamp  -- <-- cast
from bronze.matches;

-- gold
drop table if exists gold.full_matches;
create table gold.full_matches as
select
  m.match_id
  , m.created_at
  , m.msr_id
  , ms.city as msr_city
  , ms.state as msr_state
  , m.volunteer_id
  , v.city as volunteer_city
  , v.state as volunteer_state
from silver.matches m
join silver.msrs ms
  on m.msr_id = ms.msr_id
join silver.volunteers v 
  on m.volunteer_id = v.volunteer_id;

insert into gold.full_matches (
  match_id,
  created_at,
  msr_id,
  msr_city,
  msr_state,
  volunteer_id,
  volunteer_city,
  volunteer_state
)
select
  m.match_id,
  m.created_at,
  ms.msr_id,
  ms.city as msr_city,
  ms.state as msr_state,
  v.volunteer_id,
  v.city as volunteer_city,
  v.state as volunteer_state
from silver.matches m
join silver.msrs ms 
  on m.msr_id = ms.msr_id
join silver.volunteers v 
  on m.volunteer_id = v.volunteer_id;



