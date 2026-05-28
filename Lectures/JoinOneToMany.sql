
use everyloop
;

create table countries1
(
	id int,
	name nvarchar(max)
);

insert into countries1
values
	(1, 'Sweden');
insert into countries1
values
	(2, 'Norway');
insert into countries1
values
	(3, 'Denmark');
insert into countries1
values
	(4, 'Finland');


create table cities1
(
	id int,
	name nvarchar(max),
	countryId int
)

insert into cities1
values
	(1, 'Stockholm', 1);
insert into cities1
values
	(2, 'Gothenburg', 1);
insert into cities1
values
	(3, 'Malm�', 1);
insert into cities1
values
	(4, 'Oslo', 2);
insert into cities1
values
	(5, 'Bergen', 2);
insert into cities1
values
	(6, 'Copenhagen', 3);
insert into cities1
values
	(7, 'London', 5);




select
	cities1.id,
	countries1.id,
	countryid,
	cities1.*,
	*
from
	countries1 
	cross join cities1;


select *
from countries1;
select *
from cities1;

select
	ci.id,
	ci.name as 'City',
	co.name as 'Country',
	co.id,
	ci.countryId
from
	countries1 co
	right join cities1 ci on co.id = ci.countryId;


-- Uppgift 1
-- Ta ut alla länder med en kolumn för namn på landet, en kolumn med antal städer, och en kolumn med kommaseparerad lista med namnen på städerna.

select
	countries1.name as 'Country',
	count(cities1.id) as 'Number of cities',
	isnull(string_agg(cities1.name, ', '), '-') as 'Cities'
from
	countries1
	full outer join cities1 on countries1.id = cities1.countryId
group BY countries1.name;


-- Gammalt sätt att joina innan JOIN keyword infärdes på 90-talet
--select * from countries, cities where countries.id = cities.countryId


