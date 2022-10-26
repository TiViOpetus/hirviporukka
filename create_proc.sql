-- AN EXAMPLE FOR PROCEDURE WHICH ADDS A NEW GROUP

-- Create a procedure with 2 arguments, in is default
CREATE PROCEDURE public.add_jakoryhma(
    seurue integer,
    ryhman_nimi character varying)

-- Language standard SQL
LANGUAGE SQL
AS $$ -- Code block begins
    INSERT INTO public.jakoryhma (seurue_id, ryhman_nimi)
    VALUES (seurue, ryhman_nimi);
$$; -- Code block ends