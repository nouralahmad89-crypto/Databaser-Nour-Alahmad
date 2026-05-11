
use everyloop;
GO

---Moon Missions

select *
from MoonMissions;
GO
--- Select data from MoonMissions into a new tabel SuccessfulMissions
SELECT
    Spacecraft,
    [Launch date],
    [Carrier rocket],
    Operator,
    [Mission type]
INTO SuccessfulMissions
FROM MoonMissions
WHERE Outcome = 'Successful';
GO

Select *
from SuccessfulMissions ;
GO

UPDATE SuccessfulMissions
SET Operator= LTRIM(RTRIM(Operator));
GO

---  Check result after update
Select Operator
from SuccessfulMissions;
GO

--- VG update 'Spacecraft'

UPDATE SuccessfulMissions
SET Spacecraft = RTRIM(
    LEFT(Spacecraft, CHARINDEX('(', Spacecraft) - 1)
)
WHERE Spacecraft LIKE '%(%';
GO

---  Verify updated results

SELECT Spacecraft
from SuccessfulMissions;
GO

--- VG group by and order by 

SELECT
    Operator,
    [Mission type],
    COUNT(*) AS [Mission count]

FROM SuccessfulMissions

GROUP BY 
    Operator,
    [Mission type]

HAVING COUNT(*) > 1

ORDER BY 
    Operator,
    [Mission type];
GO

--- Users

Select *
from users ;
GO

--- check data type for every column

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'Users';
GO

--- select data from users into NewUsers
SELECT
    * ,
    FirstName + ' '+LastName As [Name] ,
    CASE
      when CAST(left(right(ID,2),1) AS int) %2 = 0
      THEN 'Female'
      ELSE 'Male'
    End As Gender

into NewUsers
From Users;
GO

Select *
from NewUsers ;
GO

--- Find duplicated usernames

SELECT

    UserName,
    COUNT(UserName)
from
    NewUsers

GROUP BY UserName
HAVING COUNT(UserName)> 1;
 GO
/*
I noticed that there are two duplicated usernames:
'felber' appears 2 times and 'sigpet' appears 3 times.
*/

Select *
from NewUsers
where UserName= 'sigpet'
;


---- check aother columns when username is duplicated
Select *
from NewUsers
Where 
   UserName= 'felber' or UserName='sigpet';
GO


--- check Username size

SELECT UserName, LEN(UserName)
FROM NewUsers;


-- Update column size to fit new usernames
Alter table NewUsers
Alter Column UserName VARCHAR(10);
GO


---  Update duplicated usernames
update NewUsers
set UserName = UserName + RIGHT(ID, 2)
where UserName IN
(
    select UserName
from NewUsers
group by UserName
having COUNT(*) > 1
);
GO

--- check results after update

Select
    ID,
    UserName
from NewUsers;

--- removes all women born before 1970
--- begin with select then delete

SELECT *
from NewUsers
where 
    CAST(LEFT(ID, 2) AS INT) < 70
    and CAST(left(right(ID,2),1) AS int) %2 = 0;
GO
-- After checking that we got the correct data, we can go ahead with the DELETE.

DELETE 
from NewUsers
where 
    CAST(LEFT(ID, 2) AS INT) < 70
    and CAST(left(right(ID,2),1) AS int) %2 = 0;
GO

--- check the table after delete 
SELECT *
from NewUsers;
GO

---- add new user

insert into NewUsers
    (ID ,
    UserName,
    [Password],
    FirstName,
    LastName,
    Email,
    Phone,
    [Name],
    Gender)
values('891014-8561',
        'Nour61',
        '7a0c99ef914f596a9d745df32a9c84nn',
        'Nour',
        'Alahmad',
        'nouralahmad89@gmail.com',
        '0736346267',
        'Nour Alahmad',
        'Female');

----check att user added correct
SELECT *
from NewUsers;

--- VG  average age for male and female 

--- calculate age for every user
Select

    ID ,
    [Name],

    YEAR(GETDATE()) - 
        (1900 + CAST(LEFT(ID, 2) AS INT)) AS Age

from NewUsers;
GO
---- AVG

SELECT
    Gender,

    AVG(
        YEAR(GETDATE()) - 
        (1900 + CAST(LEFT(ID, 2) AS INT))
    ) AS [Average age]

FROM NewUsers

GROUP BY Gender;
GO

---- Company (Joins)

/*check tabels first to see how data stores in every table and
how the connect to each other*/

Select *
from company.products;
GO

SELECT *
from company.suppliers;
GO

Select *
from company.categories;
GO

---- First join query

select
    company.products.Id,
    company.products.ProductName,
    company.suppliers.CompanyName,
    company.categories.CategoryName
from
    company.products
    join company.suppliers
    on company.products.SupplierId = company.suppliers.Id
    join company.categories
    on company.products.CategoryId = company.categories.Id;     
GO

-----Second join query

--- total employees are 9
select *
from company.employees;
GO
--- total region are 4
Select *
from company.regions;
GO
--- 
Select *
from company.employee_territory;
GO

Select *
from company.territories;
GO

---- number of employees in every region

Select

    company.regions.Id,
    company.regions.RegionDescription,
    count( DISTINCT company.employee_territory.EmployeeId) As NumberOfEmployees

from company.regions
    join company.territories
    on company.regions.Id= company.territories.RegionId
    join company.employee_territory
    on company.territories.Id = company.employee_territory.TerritoryId
    join company.employees
    on company.employee_territory.EmployeeId = company.employees.Id
group by
    company.regions.Id,
    company.regions.RegionDescription;
GO

--- VG Self-join

Select *
from company.employees;
GO

/* 
The table contains both Id and ReportsTo columns.
ReportsTo references another employee Id in the same table.

Some employees are managers for other employees.
Since there are 9 employees, I noticed that employees with Id 2 and 5 appear to be managers.
*/

select
    e.Id as Id,
    e.TitleOfCourtesy + ' ' + e.FirstName + ' ' + e.LastName AS Name,
    ISNULL(
        m.TitleOfCourtesy + ' ' + m.FirstName + ' ' + m.LastName,
        'Nobody!'
    ) AS [Reports to]
from company.employees e
    left join company.employees m
    on e.ReportsTo = m.Id;     

   




