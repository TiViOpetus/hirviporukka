CREATE VIEW public.nimivalinta AS

    SELECT jasen.jasen_id, jasen.sukunimi || ' ' || jasen.etunimi AS kokonimi
    FROM public.jasen
    ORDER BY kokonimi;