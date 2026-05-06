
use everyloop;

-- uppgift a

-- kolla på tabellen Elemnets först
select *
from Elements;

SELECT
    period,
    min(Number) as [FROM],
    max(Number ) as [TO],
    ROUND(AVG(stableisotopes), 2) as [average isotopes],
    STRING_AGG(symbol, ', ') AS symbols
FROM Elements
GROUP BY period;

--- uppgift b

/* 
Kollar på tabellen Customers.

Eftersom jag inte hittade Customers, kollade jag i 
INFORMATION_SCHEMA.TABLES för att se vilka tabeller 
som finns i databasen.

Jag märkte att Customers ligger i ett annat schema 
som heter company.
*/

SELECT *
FROM INFORMATION_SCHEMA.TABLES;

Select *
from company.customers;


SELECT
    Region,
    Country,
    City,
    COUNT(*) AS Customers
FROM company.customers
GROUP BY Region, Country, City
HAVING COUNT(*) >= 2;

----uppgift c

select *
from GameOfThrones;

--- Skapar en tom text-variabel
DECLARE @text VARCHAR(MAX)= ''
;

SELECT @text = @text +
    'Säsong ' + CAST(Season AS VARCHAR) +
    ' sändes från ' + FORMAT(MIN([Original air date]), 'MMMM', 'sv') +
    ' till ' + FORMAT(MAX([Original air date]), 'MMMM yyyy', 'sv') + '. ' +
    'Totalt sändes ' + CAST(COUNT(*) AS VARCHAR) +
    ' avsnitt, som i genomsnitt sågs av ' +
    CAST(ROUND(AVG([U.S. viewers(millions)]), 1) AS VARCHAR) +
    ' miljoner människor i USA.' + 
    CHAR(13)+ CHAR(10)
FROM GameofThrones
GROUP BY Season
ORDER BY season;

print @text;

--- uppgift d

SELECT *
from Users
;

SELECT FirstName +' '+ LastName AS Namn
from Users
ORDER BY Namn
;

--- uppgift e

SELECT *
from Countries
;

/* kontrollera vilken datat type tabell har 
för varje kolumn*/
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Countries';

SELECT
    Region,
    COUNT(*) AS [Antal länder],
    SUM(CAST(Population AS BIGINT)) AS [Totalt invånare],
    SUM([Area (sq# mi#)]) AS [Total area],
    ROUND(
        SUM(CAST(Population AS BIGINT)) * 1.0 
        / NULLIF(SUM([Area (sq# mi#)]), 0), 
    2) AS [Befolkningstäthet],
    ROUND(
        AVG(TRY_CAST(REPLACE([Infant mortality (per 1000 births)], ',', '.') AS FLOAT)), 
    0) AS [Spädbarnsdödlighet]
FROM Countries
GROUP BY Region;

--- uppgift f

SELECT *
from Airports
;

-- hitta landet
SELECT
    PARSENAME(REPLACE([location served], ',', '.'), 1) AS Country

from Airports;


SELECT
    PARSENAME(REPLACE([location served], ',', '.'), 1) AS Country,

    COUNT(IATA) AS [Antal flygplatser],

    SUM(
        CASE 
            WHEN ICAO IS NULL OR ICAO = '' THEN 1
            ELSE 0
        END
    ) AS [Saknar ICAO] ,

    ROUND(
        SUM(
            CASE 
                WHEN ICAO IS NULL OR ICAO = '' THEN 1
                ELSE 0
            END
        ) * 100.0
        / NULLIF(COUNT(IATA), 0),
    2) AS [Procent utan ICAO]


FROM Airports

GROUP BY 
    PARSENAME(REPLACE([location served], ',', '.'), 1);
  


   