-- View: public.sankey_data

-- DROP VIEW public.sankey_data;

CREATE OR REPLACE VIEW public.sankey_data
 AS
 SELECT lihan_kaytto.source,
    lihan_kaytto.target,
    lihan_kaytto.value
   FROM lihan_kaytto
UNION
 SELECT kaytto_ryhmille.source,
    kaytto_ryhmille.target,
    kaytto_ryhmille.value
   FROM kaytto_ryhmille;

ALTER TABLE public.sankey_data
    OWNER TO postgres;

GRANT ALL ON TABLE public.sankey_data TO sovellus;
GRANT ALL ON TABLE public.sankey_data TO postgres;