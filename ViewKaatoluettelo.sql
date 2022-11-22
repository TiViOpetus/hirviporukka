-- View: public.kaatoluettelo

-- DROP VIEW public.kaatoluettelo;

CREATE OR REPLACE VIEW public.kaatoluettelo
 AS
 SELECT (jasen.sukunimi::text || ' '::text) || jasen.etunimi::text AS kaataja,
    kaato.kaatopaiva AS "kaatopäivä",
    kaato.paikka_teksti AS paikka,
    kaato.elaimen_nimi AS "eläin",
    kaato.ikaluokka AS "ikäryhmä",
    kaato.sukupuoli,
    kaato.ruhopaino AS paino,
    kasittely.kasittely_teksti AS "käyttö"
   FROM jasen
     JOIN kaato ON jasen.jasen_id = kaato.jasen_id
     JOIN kasittely ON kaato.kasittelyid = kasittely.kasittelyid
  ORDER BY kaato.kaato_id DESC;

ALTER TABLE public.kaatoluettelo
    OWNER TO sovellus;

GRANT ALL ON TABLE public.kaatoluettelo TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.kaatoluettelo TO sovellus;

