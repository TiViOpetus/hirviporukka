CREATE VIEW public.jaettavat_lihat AS
SELECT kaato.kaato_id AS "id",
	(jasen.sukunimi::text || ' '::text) || jasen.etunimi::text AS kaataja,
	kaato.kaatopaiva AS "kaatopäivä",
    kaato.paikka_teksti AS paikka,
    kaato.elaimen_nimi AS "eläin",
    kaato.ikaluokka AS "ikäryhmä",
    kaato.sukupuoli,
    kaato.ruhopaino AS paino
   FROM jasen
     JOIN kaato ON jasen.jasen_id = kaato.jasen_id
     JOIN kasittely ON kaato.kasittelyid = kasittely.kasittelyid
   WHERE kasittely.kasittelyid = 2
  ORDER BY kaato.kaatopaiva DESC;