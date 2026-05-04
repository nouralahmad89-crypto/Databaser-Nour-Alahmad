-- uppgift a
USE everyloop

GO
SELECT *
FROM GameOfThrones;

GO
SELECT
    Title,
    'S' + FORMAT(Season, '00') + 'E' + FORMAT(Episode, '00') AS Episode
FROM GameOfThrones;

--- uppgift b

--SELECT * INTO Users2 FROM Users; skapa kopia
Select *
from Users2;

SELECT FirstName, LastName , UserName
from Users2
;

SELECT
    FirstName,
    LastName,
    LOWER(LEFT(FirstName, 2) + LEFT(LastName, 2)) AS NewUsername
FROM Users2;

UPDATE Users2
SET Username = LOWER(LEFT(FirstName, 2) + LEFT(LastName, 2));
-- kontrollera
SELECT FirstName, LastName, Username
FROM Users2;

--- uppgift c
Select *
from Airports
;
---skapa kopia
SELECT *
into airports1
from Airports
;

-- kolla null
SELECT Time, DST
FROM airports1;

SELECT *
from airports1
WHERE time is null or DST is null
;

UPDATE airports1
set Time= '_' where Time is NULL;

UPDATE airports1
set DST= '_' where DST is null
;
-- kontrollera
Select *
from airports1
where Time='_'
;

Select *
from airports1
where DST='_' and Time ='_';

/*alternative 2
UPDATE airports1
SET 
    Time = ISNULL(Time, '_'),
    DST = ISNULL(DST, '_');*/

---uppgift d

Select *
from Elements;

--- skapa kopia
SELECT *
INTO Elements2
from Elements;

-- kontrollera att rätt rader visas
SELECT *
FROM Elements2
WHERE 
    Name IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium')
    OR Name LIKE 'd%'
    OR Name LIKE 'k%'
    OR Name LIKE 'm%'
    OR Name LIKE 'o%'
    OR Name LIKE 'u%';

DELETE from Elements2
WHERE Name IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium')
    or Name LIKE '[dkmou]% ';

-- kontrolöera att de raderas
SELECT *
from Elements2
WHERE Name IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium')
    or Name LIKE '[dkmou]% ';

--- Uppgift e
SELECT Name , Symbol
from Elements2
where Symbol= left(Name , 2)
;

SELECT Name , Symbol
into Elements3
from Elements;
-- add new column for Y/N
ALTER TABLE Elements3
ADD MatchFlag CHAR(3);

SELECT *
from Elements3
;

UPDATE Elements3
SET MatchFlag = 'Yes'
WHERE Symbol = LEFT(Name, 2);

UPDATE Elements3
SET MatchFlag = 'No'
WHERE MatchFlag IS NULL;

SELECT *
from Elements3
;
/* ALternative 2
SELECT 
    Name,
    Symbol,
    CASE 
        WHEN Symbol = LEFT(Name, 2) THEN 'Yes'
        ELSE 'No'
    END AS MatchFlag
INTO Elements3
FROM Elements; */

-- uppgift f
SELECT *
from Colors
;

SELECT Name , Red , Green , Blue
into Colors2
from Colors
;

SELECT
    Name,
    '#' + 
    FORMAT(Red, 'X2') + 
    FORMAT(Green, 'X2') + 
    FORMAT(Blue, 'X2') AS Code,
    Red,
    Green,
    Blue
FROM Colors2;

----uppgift g
Select *
from Types
;

Select Integer , String
into Types2
from Types
;

Select *
from Types2
;

SELECT
    Integer,

    Integer * 1.0 AS Float,

    String,

    DATEADD(DAY, Integer - 1,
        DATEADD(MINUTE, Integer - 1, '2019-01-01 09:01:00')
    ) AS DateTime,

    CASE 
        WHEN Integer % 2 = 0 THEN 0
        ELSE 1
    END AS Bool

FROM Types2;
 