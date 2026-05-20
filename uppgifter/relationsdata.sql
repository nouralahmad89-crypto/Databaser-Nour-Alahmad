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

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'music';

select *
from music.playlists;
GO
select *
from music.genres ;
GO
select *
from music.albums ;
GO
select *
from music.artists ;
GO
select *
from music.tracks ;
GO
SELECT *
from music.media_types
;
----

declare @playlist varchar(max) = 'Heavy Metal Classic';

select
    --newid() as 'GUID',
    --p.Name as 'Playlist',
    g.Name as 'Genre',
    ar.Name as 'Artist',
    al.Title as 'Album',
    t.Name as 'Track',
    FORMAT(DATEADD(ms, t.Milliseconds, '00:00'), 'mm:ss') AS 'Length',
    --concat(t.Milliseconds / 1000 / 60 % 60, ':', t.Milliseconds / 1000 % 60) as 'Length2'
    CONCAT(format(t.Bytes / power(1024.0, 2), '#.0'), ' MiB') as 'Size',
    isnull(Composer, '-') as 'Composer'
from
    music.tracks t
    join music.genres g on g.GenreId = t.GenreId
    join music.albums al on al.AlbumId = t.AlbumId
    join music.artists ar on ar.ArtistId = al.ArtistId
    join music.playlist_track pt on pt.TrackId = t.TrackId
    join music.playlists p on p.PlaylistId = pt.PlaylistId
where 
	p.Name = @playlist
order by
	newid()
--Artist, Album, Track

--------
/*
1. Av alla audiospår, vilken artist har längst total speltid?
*/

select top 1

    ar.Name    as artistName,
    SUM(t.Milliseconds) / 1000 / 60.0 / 60 as total_Hours

from music.tracks t
    join music.albums al
    on t.AlbumId = al.AlbumId
    join music.artists ar
    on ar.ArtistId = al.ArtistId
GROUP BY
         ar.Name
ORDER BY
          sum(t.Milliseconds) DESC

/*
2. Vad är den genomsnittliga speltiden på den artistens låtar?
*/

select top 1

    ar.Name    as artistName,
    SUM(t.Milliseconds) / 1000 / 60.0  as total_minutes,
    AVG(t.Milliseconds) / 1000 / 60.0  as Average_minutes

from music.tracks t
    join music.albums al
    on t.AlbumId = al.AlbumId
    join music.artists ar
    on ar.ArtistId = al.ArtistId
GROUP BY
         ar.Name
ORDER BY
          sum(t.Milliseconds) DESC

---på annat sätt

select

    ar.Name ,
    AVG(t.Milliseconds) / 1000 / 60.0  as Average_minutes

from music.tracks t
    join music.albums al
    on t.AlbumId = al.AlbumId
    join music.artists ar
    on ar.ArtistId = al.ArtistId

where ar.ArtistId = (
        select top 1
    ar.ArtistId
from music.tracks t
    join music.albums al
    on t.AlbumId = al.AlbumId
    join music.artists ar
    on ar.ArtistId = al.ArtistId
GROUP BY
         ar.ArtistId
ORDER BY
          sum(t.Milliseconds) DESC
    )
GROUP BY ar.Name
;

/*
   3. Vad är den sammanlagda filstorleken för all video?
   */

select

    sum(CAST(m.Bytes as bigint)) as total_video

from music.tracks  m
    join music.media_types md
    on m.MediaTypeId = md.MediaTypeId
where 
         -- md.Name LIKE '%video%'
         md.MediaTypeId = 3

/*
4. Vilket är det högsta antal artister som finns på en enskild spellista?
*/

SELECT TOP 1
    p.Name AS PlaylistName,
    COUNT(DISTINCT ar.ArtistId) AS TotalArtists

FROM music.playlists p

    JOIN music.playlist_track pt
    ON p.PlaylistId = pt.PlaylistId

    JOIN music.tracks t
    ON t.TrackId = pt.TrackId

    JOIN music.albums al
    ON al.AlbumId = t.AlbumId

    JOIN music.artists ar
    ON ar.ArtistId = al.ArtistId

GROUP BY p.Name

ORDER BY TotalArtists DESC;     


/*
5. Vilket är det genomsnittliga antalet artister per spellista?
*/