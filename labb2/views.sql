

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

    Select

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

----------- en till vy 
/*
Denna vy hjälper bokhandeln att analysera
kunders köpvanor och identifiera ,återkommande kunder.
Informationen kan användas för:
kundanalyser, marknadsföring, och lojalitetsprogram.
*/

select *
from Kunder;
GO
select *
from Ordrar;
GO
select *
from OrderDetaljer;
GO

CREATE VIEW KundBeställningar
AS

    SELECT

        k.FörNamn + ' ' + k.EfterNamn AS KundNamn,

        COUNT(DISTINCT o.OrderID) AS AntalOrdrar,

        SUM(od.Antal) AS TotaltKöptaBöcker,

        SUM(od.Antal * od.Pris) AS TotaltSpenderat

    FROM Kunder k

        JOIN Ordrar o
        ON k.KundID = o.KundID

        JOIN OrderDetaljer od
        ON o.OrderID = od.OrderID

    GROUP BY

    k.KundID,
    k.FörNamn,
    k.EfterNamn;

GO

SELECT *
from KundBeställningar
ORDER BY TotaltSpenderat DESC;