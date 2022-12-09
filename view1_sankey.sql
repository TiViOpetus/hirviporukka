-- View: public.kaytto_ryhmille

-- DROP VIEW public.kaytto_ryhmille;

CREATE OR REPLACE VIEW public.kaytto_ryhmille
 AS
 SELECT kasittely.kasittely_teksti AS source,
    jakoryhma.ryhman_nimi AS target,
    sum(jakotapahtuma.maara) AS value
   FROM kasittely
     JOIN kaato ON kasittely.kasittelyid = kaato.kasittelyid
     JOIN jakotapahtuma ON kaato.kaato_id = jakotapahtuma.kaato_id
     JOIN jakoryhma ON jakotapahtuma.ryhma_id = jakoryhma.ryhma_id
  WHERE kaato.kasittelyid = 2
  GROUP BY kasittely.kasittely_teksti, jakoryhma.ryhman_nimi;

ALTER TABLE public.kaytto_ryhmille
    OWNER TO postgres;
COMMENT ON VIEW public.kaytto_ryhmille
    IS 'Näkymä, joka kertoo, paljonko lihaa on annettu ryhmille, kun käyttönä on seurueelle';

GRANT ALL ON TABLE public.kaytto_ryhmille TO sovellus;
GRANT ALL ON TABLE public.kaytto_ryhmille TO postgres;