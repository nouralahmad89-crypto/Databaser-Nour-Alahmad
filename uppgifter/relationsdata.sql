/* Företagets totala produktkatalog består av 77 unika produkter. 
Om vi kollar bland våra ordrar, hur stor andel av dessa produkter
har vi någon gång leverarat till London?*/

use everyloop;
GO

Select *
from company.products;
GO

select *
from company.suppliers;
GO

select *
from company.orders;
GO

select *
from company.order_details;
GO


SELECT
    COUNT(DISTINCT od.ProductId) AS Num_probuct,
    COUNT(DISTINCT od.ProductId) * 100.0 / 77 AS PercentageToLondon
FROM company.orders o
    JOIN company.order_details od
    ON o.Id = od.OrderId
WHERE o.ShipCity = 'London';
GO

/* Till vilken stad har vi levererat flest unika produkter? */

select Top 1
    o.ShipCity ,
    count(DISTINCT od.ProductId) As [unique products]

FROM company.orders o
    JOIN company.order_details od
    ON o.Id = od.OrderId
GROUP BY o.ShipCity
ORDER BY [unique products] DESC
GO

/* Av de produkter som inte längre finns I vårat sortiment,
hur mycket har vi sålt för totalt till Tyskland?*/

select
    sum( od.UnitPrice * od.Quantity) As [totalSales]

FROM company.orders o
    JOIN company.order_details od
    ON o.Id = od.OrderId
    join company.products p
    on p.Id = od.ProductId


where 
    p.Discontinued= 1 AND
    o.ShipCountry = 'Germany'
GO

/* För vilken produktkategori har vi högst lagervärde?*/

--- vi har 8 categories
select *
from company.categories ;
GO

select *
from company.products;
GO

select top 1
    c.CategoryName ,
    SUM(p.UnitsInStock * p.UnitPrice) AS StockValue

from company.categories c
    join company.products p
    on c.Id = p.CategoryId
GROUP BY 
c.CategoryName
ORDER BY StockValue DESC
GO

/* Från vilken leverantör har vi sålt flest produkter totalt under sommaren 
2013?*/
select *
from company.suppliers ;
GO
select *
from company.products;
GO
select *
from company.orders;
GO
select *
from company.order_details;
GO

select top 1
    sum(od.Quantity) as total ,
    s.CompanyName

from company.suppliers S
    join company.products P
    on S.Id = P.SupplierId
    join company.order_details od
    on p.Id = od.ProductId
    join company.orders o
    on od.OrderId = o.Id

where YEAR(o.OrderDate) = 2013
    and MONTH(o.OrderDate) in ( 06, 07, 08)
Group by s.CompanyName
ORDER BY total DESC ;
GO



----------- schema “music”
declare @playlist varchar(max) = 'Heavy Metal Classic';

Select *
from music.media_types;

