create procedure Flytta_Böcker

    @Från_ButikID INT,
    @Till_ButikID INT,
    @ISBN CHAR(13),
    @Antal INT = 1,
    @Output NVARCHAR(MAX) OUTPUT

as

begin

    begin try

        -- Kontrollera att antal böcker är större än 0
        if  @Antal <= 0
        begin
        SET @Output =
            'Flytt misslyckades. Antal böcker måste vara större än 0!';

        return;

    end;

        -- Kontrollera att från-butiken finns
        if not exists
        (
            select *
    from Butiker
    where ButikID = @Från_ButikID
        )
        begin

        set @Output =
            'Flytt misslyckades. Från-butiken finns inte!';

        return;

    end;

        -- Kontrollera att till-butiken finns
        if not exists
        (
            select *
    from Butiker
    where ButikID = @Till_ButikID
        )

        begin

        SET @Output =
            'Flytt misslyckades. Till-butiken finns inte!';

        return;

    end;

        -- Kontrollera att boken finns i från-butiken
        if not exists
        (
            select *
    from LagerSaldo
    where ButikID = @Från_ButikID
        and ISBN13 = @ISBN
        )

        begin

        SET @Output =
            'Flytt misslyckades. Boken finns inte i från-butiken!';

        return;

    end;


        -- Kontrollera att tillräckligt antal finns
        if exists
        (
            select *
    from LagerSaldo
    where ButikID = @Från_ButikID
        and ISBN13 = @ISBN
        and Antal < @Antal
        )

        begin

        SET @Output =
            'Flytt misslyckades. Inte tillräckligt många böcker i lager!';

        return;

    end;


        begin transaction;


        -- Minska antal i från-butiken
        update LagerSaldo

        set Antal = Antal - @Antal

        where ButikID = @Från_ButikID
        and ISBN13 = @ISBN;


        -- Kontrollera om boken redan finns i till-butiken
        if exists
        (
            select *
    from LagerSaldo
    where ButikID = @Till_ButikID
        and ISBN13 = @ISBN
        )

        begin

        -- Öka antal i till-butiken
        update LagerSaldo

            set  Antal = Antal + @Antal

            where ButikID = @Till_ButikID
            and ISBN13 = @ISBN;

    end

        else

        begin
        -- Lägg till ny rad i till-butiken
        insert into LagerSaldo
            (ButikID, ISBN13, Antal)

        values
            (@Till_ButikID, @ISBN, @Antal);

    end;


        commit transaction;


        set @Output =
        'Flytt lyckades. ' +
        CAST(@Antal AS NVARCHAR) +
        ' bok/böcker flyttades från butik ' +
        CAST(@Från_ButikID AS NVARCHAR) +
        ' till butik ' +
        CAST(@Till_ButikID AS NVARCHAR) + '.';


    end try

    begin catch

        rollback transaction;

        SET @Output =
        'Flytt misslyckades. Fel: ' +
        ERROR_MESSAGE();

    end catch;

end;


--===================
-- try procedure-----
--===================

select *
from Butiker;
GO
select *
from LagerSaldo ;
GO

declare @Meddelande NVARCHAR(MAX);

exec Flytta_Böcker

    @Från_ButikID = 1,
    @Till_ButikID = 2,
    @ISBN = '9780747532743',
    @Antal = 2,
    @Output = @Meddelande OUTPUT;

print @Meddelande;