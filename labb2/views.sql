

select *
from Författare ;
GO
select *
from BokFörfattare ;
GO
select *
from LagerSaldo ;
GO

create view TitlarPerFörfattare
as

    select

        f.FörNamn + ' ' + f.EfterNamn AS Namn,

        YEAR(GETDATE()) - YEAR(f.Födelsedatum) AS Ålder,

        COUNT(DISTINCT b.ISBN13) AS Titlar,

        SUM(ls.Antal * b.Pris) AS Lagervärde

    FROM Författare f

        JOIN BokFörfattare bf
        ON f.FörfattareID = bf.FörfattareID

        JOIN Böcker b
        ON bf.ISBN13 = b.ISBN13

        JOIN LagerSaldo ls
        ON b.ISBN13 = ls.ISBN13

    GROUP BY

    f.FörfattareID,
    f.FörNamn,
    f.EfterNamn,
    f.Födelsedatum;

GO

--- test

SELECT *
FROM TitlarPerFörfattare;

-- ========================================
/* Denna vy hjälper bokhandeln att analysera
  hur många böcker och hur stort lagervärde
  som finns inom varje kategori.*/
/*
   Informationen kan användas för:
   lagerplanering,
   inköpsbeslut,
  och analys av populära kategorier.*/
select *
from Kategorier ;
GO
select *
from BokKategori ;
GO

CREATE VIEW LagerPerKategori
AS

    SELECT

        k.KategoriNamn AS Kategori,

        COUNT(DISTINCT b.ISBN13) AS AntalTitlar,

        SUM(ls.Antal) AS TotaltAntalBöcker,

        SUM(ls.Antal * b.Pris) AS TotaltLagervärde

    FROM Kategorier k

        JOIN BokKategori bk
        ON k.KategoriID = bk.KategoriID

        JOIN Böcker b
        ON bk.ISBN13 = b.ISBN13

        JOIN LagerSaldo ls
        ON b.ISBN13 = ls.ISBN13

    GROUP BY
    k.KategoriNamn;
GO
select *
from LagerPerKategori;
 
GO

