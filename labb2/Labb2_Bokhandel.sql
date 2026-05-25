-- ====================================
-- CREATE DATABASE
-- ====================================

CREATE DATABASE Bokhandel;
GO

USE Bokhandel;
GO


-- ====================================
-- TABLES
-- ====================================

--1)
CREATE TABLE Författare
(

    FörfattareID INT IDENTITY(1,1),

    FörNamn NVARCHAR(20) NOT NULL,

    EfterNamn NVARCHAR(20) NOT NULL,

    Födelsedatum DATE,

    CONSTRAINT PK_Författare PRIMARY KEY (FörfattareID)

);

--2)
CREATE TABLE Förlag
(

    FörlagID INT IDENTITY(1,1),

    FörlagsNamn VARCHAR(50) NOT NULL,

    Land VARCHAR(50),

    CONSTRAINT PK_Förlag
        PRIMARY KEY (FörlagID)

);

--3)
CREATE TABLE Böcker
(

    ISBN13 CHAR(13) NOT NULL,

    Titel VARCHAR(50) NOT NULL,

    Språk VARCHAR(20) NOT NULL,

    Pris DECIMAL(10,2) NOT NULL,

    Utgivningsdatum DATE ,

    FörlagID INT NOT NULL,

    CONSTRAINT PK_ISBN PRIMARY KEY (ISBN13) ,

    CONSTRAINT FK_Böcker_Förlag
       FOREIGN KEY (FörlagID)
       REFERENCES Förlag(FörlagID)  ,

    CONSTRAINT CK_Pris
        CHECK (Pris > 0)
)
;

--4)
CREATE TABLE BokFörfattare
(

    FörfattareID INT,

    ISBN13 CHAR(13),

    CONSTRAINT PK_BokFörfattare
        PRIMARY KEY (FörfattareID, ISBN13),

    CONSTRAINT FK_BokFörfattare_Författare
        FOREIGN KEY (FörfattareID)
        REFERENCES Författare(FörfattareID),

    CONSTRAINT FK_BokFörfattare_Böcker
        FOREIGN KEY (ISBN13)
        REFERENCES Böcker(ISBN13)
);

--5)
CREATE TABLE Kategorier
(

    KategoriID INT IDENTITY(1,1),

    KategoriNamn VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Kategorier
        PRIMARY KEY (KategoriID)

);

--6)
CREATE TABLE BokKategori
(

    ISBN13 CHAR(13),

    KategoriID INT,

    CONSTRAINT PK_BokKategori
        PRIMARY KEY (ISBN13, KategoriID),

    CONSTRAINT FK_BokKategori_Böcker
        FOREIGN KEY (ISBN13)
        REFERENCES Böcker(ISBN13),

    CONSTRAINT FK_BokKategori_Kategorier
        FOREIGN KEY (KategoriID)
        REFERENCES Kategorier(KategoriID)

);
--7)
CREATE TABLE Butiker
(

    ButikID INT IDENTITY(1,1),

    ButiksNamn VARCHAR(50) NOT NULL,

    Adress VARCHAR(100) NOT NULL,

    Stad VARCHAR(50) NOT NULL,

    Postnummer VARCHAR(10),

    CONSTRAINT PK_Butiker PRIMARY KEY (ButikID)

);

--8)
CREATE TABLE LagerSaldo
(

    ButikID INT,

    ISBN13 CHAR(13),

    Antal INT NOT NULL,

    CONSTRAINT PK_LagerSaldo
        PRIMARY KEY (ButikID, ISBN13),

    CONSTRAINT FK_LagerSaldo_Butiker
        FOREIGN KEY (ButikID)
        REFERENCES Butiker(ButikID),

    CONSTRAINT FK_LagerSaldo_Böcker
        FOREIGN KEY (ISBN13)
        REFERENCES Böcker(ISBN13),

    CONSTRAINT CK_Antal
        CHECK (Antal >= 0)

);

--9)
CREATE TABLE Kunder
(

    KundID INT IDENTITY(1,1),

    FörNamn VARCHAR(30) NOT NULL,

    EfterNamn VARCHAR(30) NOT NULL,

    Email VARCHAR(100),

    Telefonnummer VARCHAR(20),

    CONSTRAINT PK_Kunder
        PRIMARY KEY (KundID)

);

--10)
CREATE TABLE Ordrar
(

    OrderID INT IDENTITY(1,1),

    KundID INT NOT NULL,

    ButikID INT NOT NULL,

    OrderDatum DATE NOT NULL,

    CONSTRAINT PK_Ordrar
        PRIMARY KEY (OrderID),

    CONSTRAINT FK_Ordrar_Kunder
        FOREIGN KEY (KundID)
        REFERENCES Kunder(KundID),

    CONSTRAINT FK_Ordrar_Butiker
        FOREIGN KEY (ButikID)
        REFERENCES Butiker(ButikID)

);

alter table  Ordrar

ADD CONSTRAINT CK_Ordrar_Datum
CHECK (OrderDatum <= GETDATE());

--11)

CREATE TABLE OrderDetaljer
(

    OrderID INT,

    ISBN13 CHAR(13),

    Antal INT NOT NULL,

    Pris DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_OrderDetaljer
        PRIMARY KEY (OrderID, ISBN13),

    CONSTRAINT FK_OrderDetaljer_Ordrar
        FOREIGN KEY (OrderID)
        REFERENCES Ordrar(OrderID),

    CONSTRAINT FK_OrderDetaljer_Böcker
        FOREIGN KEY (ISBN13)
        REFERENCES Böcker(ISBN13),

    CONSTRAINT CK_OrderDetaljer_Antal
        CHECK (Antal > 0),

    CONSTRAINT CK_OrderDetaljer_Pris
        CHECK (Pris > 0)

);


-- ====================================
-- TESTDATA
-- Information from OpenLibray website.
-- ====================================
insert into  Förlag
    (FörlagsNamn, Land)
values
    ('Addison-Wesley', 'USA'),
    ('O''Reilly Media', 'USA'),
    ('Penguin Books', 'Storbritannien'),
    ('Bloomsbury', 'Storbritannien'),
    ('Norstedts', 'Sverige'),
    ('HarperCollins', 'USA');
GO
-- lägg till mer data
insert into Förlag
    (FörlagsNamn, Land)
values
    ('Houghton Mifflin', 'USA'),
    ('Doubleday', 'USA');

insert into  Författare
    (FörNamn, EfterNamn, Födelsedatum)
values
    ('Martin', 'Kleppmann', '1987-01-01'),
    ('Cay', 'Horstmann', '1959-01-01'),
    ('Gary', 'Cornell', '1956-01-01'),
    ('J.K.', 'Rowling', '1965-07-31'),
    ('George', 'Orwell', '1903-06-25'),
    ('Astrid', 'Lindgren', '1907-11-14'),
    ('Agatha', 'Christie', '1890-09-15');
GO
--- lägg till mer författare
insert into Författare
    (FörNamn, EfterNamn, Födelsedatum)
values

    ('J.R.R.', 'Tolkien', '1892-01-03'),

    ('Harper', 'Lee', '1926-04-28'),

    ('Dan', 'Brown', '1964-06-22'),

    ('Stephen', 'Hawking', '1942-01-08');
GO

insert into Böcker
    (ISBN13, Titel, Språk, Pris, Utgivningsdatum, FörlagID)
values
    ('9781491903063',
        'Designing Data-Intensive Applications',
        'Engelska',
        499.90,
        '2017-03-16',
        2),

    ('9780134694726',
        'Core Java Volume I',
        'Engelska',
        599.90,
        '2018-08-27',
        1),

    ('9780747532743',
        'Harry Potter and the Philosopher''s Stone',
        'Engelska',
        199.90,
        '1997-06-26',
        4),

    ('9780747538486',
        'Harry Potter and the Chamber of Secrets',
        'Engelska',
        219.90,
        '1998-07-02',
        4),

    ('9780451524935',
        '1984',
        'Engelska',
        149.90,
        '1949-06-08',
        3),

    ('9780451526342',
        'Animal  Farm',
        'Engelska',
        129.90,
        '1945-08-17',
        3),

    ('9789129698313',
        'Pippi Långstrump',
        'Svenska',
        139.90,
        '1945-11-26',
        5),

    ('9780007119318',
        'Murder on the Orient Express',
        'Engelska',
        179.90,
        '1934-01-01',
        6);

GO
-- lägg till mer böcker 
insert into Böcker
    (ISBN13, Titel, Språk, Pris, Utgivningsdatum, FörlagID)
values

    ('9780261102385',
        'The Hobbit',
        'Engelska',
        189.90,
        '1937-09-21',
        3),

    ('9780061120084',
        'To Kill a Mockingbird',
        'Engelska',
        159.90,
        '1960-07-11',
        6),

    ('9780307474278',
        'The Da Vinci Code',
        'Engelska',
        169.90,
        '2003-03-18',
        6),

    ('9780553380163',
        'A Brief History of Time',
        'Engelska',
        249.90,
        '1988-04-01',
        2);
GO

update Böcker
set  FörlagID = 7
where ISBN13 = '9780261102385';
GO

insert into  BokFörfattare
    (FörfattareID, ISBN13)
values
    -- Martin Kleppmann
    (1, '9781491903063'),

    -- Core Java (TVÅ författare)
    (2, '9780134694726'),
    (3, '9780134694726'),

    -- J.K Rowling
    (4, '9780747532743'),
    (4, '9780747538486'),

    -- George Orwell
    (5, '9780451524935'),
    (5, '9780451526342'),

    -- Astrid Lindgren
    (6, '9789129698313'),

    -- Agatha Christie
    (7, '9780007119318');
GO

-- Koppla böcker och författare
insert into BokFörfattare
    (FörfattareID, ISBN13)
values
    -- Tolkien
    (8, '9780261102385'),

    -- Harper Lee
    (9, '9780061120084'),

    -- Dan Brown
    (10, '9780307474278'),

    -- Stephen Hawking
    (11, '9780553380163');
GO

insert into Kategorier
    (KategoriNamn)
values
    ('Fantasy'),
    ('Teknologi'),
    ('Roman'),
    ('Barnbok'),
    ('Deckare');
GO


insert into  BokKategori
    (ISBN13, KategoriID)
values

    -- Harry Potter
    ('9780747532743', 1),

    -- Core Java
    ('9780134694726', 2),

    -- 1984
    ('9780451524935', 3),

    -- Pippi
    ('9789129698313', 4),

    -- Murder on the Orient Express
    ('9780007119318', 5);
GO

-- lägg till katrggrier

insert into BokKategori
    (ISBN13, KategoriID)
values

    -- The Hobbit = Fantasy
    ('9780261102385', 1),

    -- To Kill a Mockingbird = Roman
    ('9780061120084', 3),

    -- The Da Vinci Code = Deckare + Roman
    ('9780307474278', 5),
    ('9780307474278', 3),

    -- A Brief History of Time = Teknologi 
    ('9780553380163', 2);

insert into BokKategori
    (ISBN13, KategoriID)
values
    -- Harry Potter = Fantasy + Roman
    ('9780747532743', 1),
    ('9780747532743', 3),

    -- Core Java = Teknologi
    ('9780134694726', 2),

    -- 1984 = Roman
    ('9780451524935', 3),

    -- Pippi = Barnbok + Roman
    ('9789129698313', 4),
    ('9789129698313', 3),

    -- Murder on the Orient Express = Deckare + Roman
    ('9780007119318', 5),
    ('9780007119318', 3);
GO

insert into Butiker
    (ButiksNamn, Adress, Stad, Postnummer)
values
    ('Adlibris',
        'Östra Hamngatan 37',
        'Göteborg',
        '41110'),

    ('Akademibokhandeln',
        'Kungsgatan 45',
        'Stockholm',
        '11156'),

    ('Bokus',
        'Dragarbrunnsgatan 48',
        'Uppsala',
        '75320'),

    ('Pocket Shop',
        'Södra Förstadsgatan 41',
        'Malmö',
        '21143'),

    ('The English Bookshop',
        'Svartbäcksgatan 19',
        'Uppsala',
        '75332');
GO

insert into LagerSaldo
    (ButikID, ISBN13, Antal)
values
    -- Adlibris
    (1, '9780747532743', 12),
    (1, '9780747538486', 8),
    (1, '9780134694726', 4),

    -- Akademibokhandeln 
    (2, '9780451524935', 9),
    (2, '9780451526342', 7),
    (2, '9780747532743', 10),

    -- Bokus 
    (3, '9781491903063', 5),
    (3, '9789129698313', 6),

    -- Pocket Shop
    (4, '9780007119318', 4),
    (4, '9780451524935', 3),

    -- The English Bookshop 
    (5, '9780134694726', 3),
    (5, '9781491903063', 2),
    (5, '9780747532743', 5);

  GO

insert into Kunder
    (FörNamn, EfterNamn , Email ,Telefonnummer)
values
    ('Nour',
        'Al-Ahmad',
        'nour.alahmad@email.com',
        '0701234567'),

    ('Sara',
        'Johansson',
        'sara.johansson@gmail.com',
        '0723456789'),

    ('Erik',
        'Larsson',
        'erik.larsson@gmail.com',
        '0739876543'),

    ('Maja',
        'Nilsson',
        'maja.nilsson@gmail.com',
        '0761122334'),

    ('Ali',
        'Hassan',
        'ali.hassan@gmail.com',
        '0709988776'),

    ('Emma',
        'Svensson',
        'emma.svensson@gmail.com',
        '0795566778');
GO

insert into Ordrar
    (KundID, ButikID, OrderDatum)
values
    (1, 1, '2026-04-10'),

    (2, 2, '2026-05-11'),

    (3, 3, '2026-02-22'),

    (4, 4, '2026-03-13'),

    (5, 5, '2026-05-14'),

    (6, 2, '2026-04-01');
GO

insert into  OrderDetaljer
    (OrderID, ISBN13, Antal, Pris)
values
    -- Order 1(Nour)
    (1, '9780747532743', 1, 199.90),
    (1, '9780134694726', 1, 599.90),

    -- Order 2 (Sara)
    (2, '9780451524935', 2, 149.90),

    -- Order 3 (Erik)
    (3, '9781491903063', 1, 499.90),
    (3, '9780134694726', 1, 599.90),

    -- Order 4 (Maja)
    (4, '9780007119318', 1, 179.90),

    -- Order 5 (Ali)
    (5, '9780747538486', 1, 219.90),
    (5, '9780451526342', 1, 129.90),

    -- Order 6 (Emma)
    (6, '9789129698313', 2, 139.90);








-- ====================================
-- VIEWS
-- ====================================

CREATE VIEW ...


-- ====================================
-- STORED PROCEDURES
-- ====================================

CREATE PROCEDURE ...