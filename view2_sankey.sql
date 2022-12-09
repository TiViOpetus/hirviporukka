-- View: public.lihan_kaytto

-- DROP VIEW public.lihan_kaytto;

CREATE OR REPLACE VIEW public.lihan_kaytto
 AS
 SELECT kaato.elaimen_nimi AS source,
    kasittely.kasittely_teksti AS target,
    sum(kaato.ruhopaino) AS value
   FROM kaato
     JOIN kasittely ON kaato.kasittelyid = kasittely.kasittelyid
  GROUP BY kaato.elaimen_nimi, kasittely.kasittely_teksti;

ALTER TABLE public.lihan_kaytto
    OWNER TO postgres;
COMMENT ON VIEW public.lihan_kaytto
    IS 'Kertoo, miten liha on haluttu käyttää: seurueelle, seuralle, myyntiin tai hävitykseen';

GRANT ALL ON TABLE public.lihan_kaytto TO sovellus;
GRANT ALL ON TABLE public.lihan_kaytto TO postgres;