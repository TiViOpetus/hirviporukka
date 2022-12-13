--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-12-13 09:34:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 249 (class 1255 OID 27618)
-- Name: add_jakoryhma(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_jakoryhma(IN seurue integer, IN ryhman_nimi character varying)
    LANGUAGE sql
    AS $$
INSERT INTO public.jakoryhma (seurue_id,ryhman_nimi) VALUES (seurue, ryhman_nimi);
$$;


ALTER PROCEDURE public.add_jakoryhma(IN seurue integer, IN ryhman_nimi character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 27619)
-- Name: jasen; Type: TABLE; Schema: public; Owner: sovellus
--

CREATE TABLE public.jasen (
    jasen_id integer NOT NULL,
    etunimi character varying(50) NOT NULL,
    sukunimi character varying(50) NOT NULL,
    jakeluosoite character varying(30) NOT NULL,
    postinumero character varying(10) NOT NULL,
    postitoimipaikka character varying(30) NOT NULL
);


ALTER TABLE public.jasen OWNER TO sovellus;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE jasen; Type: COMMENT; Schema: public; Owner: sovellus
--

COMMENT ON TABLE public.jasen IS 'Henkilö joka osallistuu metsästykseen tai lihanjakoon';


--
-- TOC entry 248 (class 1255 OID 27622)
-- Name: get_member(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_member(id integer) RETURNS SETOF public.jasen
    LANGUAGE sql
    AS $$
SELECT * FROM public.jasen WHERE jasen_id = id;
$$;


ALTER FUNCTION public.get_member(id integer) OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 27623)
-- Name: aikuinenvasa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aikuinenvasa (
    ikaluokka character varying(10) NOT NULL
);


ALTER TABLE public.aikuinenvasa OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 27626)
-- Name: elain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elain (
    elaimen_nimi character varying(20) NOT NULL
);


ALTER TABLE public.elain OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 27655)
-- Name: kaato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kaato (
    kaato_id integer NOT NULL,
    jasen_id integer NOT NULL,
    kaatopaiva date NOT NULL,
    ruhopaino real NOT NULL,
    paikka_teksti character varying(100) NOT NULL,
    paikka_koordinaatti character varying(100),
    kasittelyid integer NOT NULL,
    elaimen_nimi character varying(20) NOT NULL,
    sukupuoli character varying(10) NOT NULL,
    ikaluokka character varying(10) NOT NULL,
    lisatieto character varying(255)
);


ALTER TABLE public.kaato OWNER TO postgres;

--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE kaato; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.kaato IS 'Ampumatapahtuman tiedot';


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN kaato.ruhopaino; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.kaato.ruhopaino IS 'paino kiloina';


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN kaato.paikka_koordinaatti; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.kaato.paikka_koordinaatti IS 'Tämän kentän tietotyyppi pitää oikeasti olla geometry (Postgis-tietotyyppi)';


--
-- TOC entry 227 (class 1259 OID 27673)
-- Name: kasittely; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kasittely (
    kasittelyid integer NOT NULL,
    kasittely_teksti character varying(50) NOT NULL
);


ALTER TABLE public.kasittely OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 36023)
-- Name: jaettavat_lihat; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.jaettavat_lihat AS
 SELECT kaato.kaato_id AS id,
    (((jasen.sukunimi)::text || ' '::text) || (jasen.etunimi)::text) AS kaataja,
    kaato.kaatopaiva AS "kaatopäivä",
    kaato.paikka_teksti AS paikka,
    kaato.elaimen_nimi AS "eläin",
    kaato.ikaluokka AS "ikäryhmä",
    kaato.sukupuoli,
    kaato.ruhopaino AS paino
   FROM ((public.jasen
     JOIN public.kaato ON ((jasen.jasen_id = kaato.jasen_id)))
     JOIN public.kasittely ON ((kaato.kasittelyid = kasittely.kasittelyid)))
  WHERE (kasittely.kasittelyid = 2)
  ORDER BY kaato.kaatopaiva DESC;


ALTER TABLE public.jaettavat_lihat OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 27629)
-- Name: jakoryhma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jakoryhma (
    ryhma_id integer NOT NULL,
    seurue_id integer NOT NULL,
    ryhman_nimi character varying(50) NOT NULL
);


ALTER TABLE public.jakoryhma OWNER TO postgres;

--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE jakoryhma; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.jakoryhma IS 'Ryhmä, jolle lihaa jaetaan';


--
-- TOC entry 213 (class 1259 OID 27632)
-- Name: jakotapahtuma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jakotapahtuma (
    tapahtuma_id integer NOT NULL,
    paiva date NOT NULL,
    ryhma_id integer NOT NULL,
    osnimitys character varying(20) NOT NULL,
    maara real NOT NULL,
    kaato_id integer
);


ALTER TABLE public.jakotapahtuma OWNER TO postgres;

--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN jakotapahtuma.maara; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.jakotapahtuma.maara IS 'Jaettu lihamäärä kiloina';


--
-- TOC entry 214 (class 1259 OID 27635)
-- Name: jaetut_lihat; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.jaetut_lihat AS
 SELECT jakoryhma.ryhman_nimi,
    sum(jakotapahtuma.maara) AS kg
   FROM (public.jakoryhma
     LEFT JOIN public.jakotapahtuma ON ((jakotapahtuma.ryhma_id = jakoryhma.ryhma_id)))
  GROUP BY jakoryhma.ryhman_nimi
  ORDER BY jakoryhma.ryhman_nimi;


ALTER TABLE public.jaetut_lihat OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 27639)
-- Name: jako_ka; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.jako_ka AS
 SELECT avg(jaetut_lihat.kg) AS liha_ka
   FROM public.jaetut_lihat;


ALTER TABLE public.jako_ka OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 27643)
-- Name: jakoryhma_ryhma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jakoryhma_ryhma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jakoryhma_ryhma_id_seq OWNER TO postgres;

--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 216
-- Name: jakoryhma_ryhma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jakoryhma_ryhma_id_seq OWNED BY public.jakoryhma.ryhma_id;


--
-- TOC entry 217 (class 1259 OID 27644)
-- Name: jasenyys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jasenyys (
    jasenyys_id integer NOT NULL,
    ryhma_id integer NOT NULL,
    jasen_id integer NOT NULL,
    liittyi date NOT NULL,
    poistui date,
    osuus integer DEFAULT 100 NOT NULL
);


ALTER TABLE public.jasenyys OWNER TO postgres;

--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN jasenyys.osuus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.jasenyys.osuus IS 'Muuta pakolliseksi (NOT NULL)';


--
-- TOC entry 218 (class 1259 OID 27648)
-- Name: jakoryhma_yhteenveto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.jakoryhma_yhteenveto AS
 SELECT jakoryhma.ryhman_nimi AS "ryhmä",
    count(jasenyys.jasen_id) AS "jäseniä",
    ((sum(jasenyys.osuus))::double precision / (100)::real) AS osuuksia
   FROM (public.jakoryhma
     JOIN public.jasenyys ON ((jasenyys.ryhma_id = jakoryhma.ryhma_id)))
  GROUP BY jakoryhma.ryhman_nimi
  ORDER BY jakoryhma.ryhman_nimi;


ALTER TABLE public.jakoryhma_yhteenveto OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 27652)
-- Name: jakotapahtuma_tapahtuma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jakotapahtuma_tapahtuma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jakotapahtuma_tapahtuma_id_seq OWNER TO postgres;

--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 219
-- Name: jakotapahtuma_tapahtuma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jakotapahtuma_tapahtuma_id_seq OWNED BY public.jakotapahtuma.tapahtuma_id;


--
-- TOC entry 220 (class 1259 OID 27653)
-- Name: jasen_jasen_id_seq_1; Type: SEQUENCE; Schema: public; Owner: sovellus
--

CREATE SEQUENCE public.jasen_jasen_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jasen_jasen_id_seq_1 OWNER TO sovellus;

--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 220
-- Name: jasen_jasen_id_seq_1; Type: SEQUENCE OWNED BY; Schema: public; Owner: sovellus
--

ALTER SEQUENCE public.jasen_jasen_id_seq_1 OWNED BY public.jasen.jasen_id;


--
-- TOC entry 221 (class 1259 OID 27654)
-- Name: jasenyys_jasenyys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jasenyys_jasenyys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jasenyys_jasenyys_id_seq OWNER TO postgres;

--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 221
-- Name: jasenyys_jasenyys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jasenyys_jasenyys_id_seq OWNED BY public.jasenyys.jasenyys_id;


--
-- TOC entry 223 (class 1259 OID 27658)
-- Name: kaadot_ampujittain; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kaadot_ampujittain AS
 SELECT (((jasen.etunimi)::text || ' '::text) || (jasen.sukunimi)::text) AS ampuja,
    kaato.elaimen_nimi AS "eläin",
    kaato.sukupuoli,
    kaato.ikaluokka,
    count(kaato.elaimen_nimi) AS kpl,
    sum(kaato.ruhopaino) AS kg
   FROM (public.kaato
     JOIN public.jasen ON ((jasen.jasen_id = kaato.jasen_id)))
  GROUP BY (((jasen.etunimi)::text || ' '::text) || (jasen.sukunimi)::text), kaato.elaimen_nimi, kaato.sukupuoli, kaato.ikaluokka
  ORDER BY (((jasen.etunimi)::text || ' '::text) || (jasen.sukunimi)::text);


ALTER TABLE public.kaadot_ampujittain OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 27663)
-- Name: kaadot_ryhmittain; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kaadot_ryhmittain AS
 SELECT jakoryhma.ryhman_nimi,
    kaato.elaimen_nimi,
    kaato.sukupuoli,
    kaato.ikaluokka,
    count(kaato.elaimen_nimi) AS kpl,
    sum(kaato.ruhopaino) AS kg
   FROM ((public.jakoryhma
     JOIN public.jasenyys ON ((jakoryhma.ryhma_id = jasenyys.ryhma_id)))
     JOIN public.kaato ON ((jasenyys.jasen_id = kaato.jasen_id)))
  GROUP BY jakoryhma.ryhman_nimi, kaato.elaimen_nimi, kaato.sukupuoli, kaato.ikaluokka;


ALTER TABLE public.kaadot_ryhmittain OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 27668)
-- Name: kaato_kaato_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kaato_kaato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kaato_kaato_id_seq OWNER TO postgres;

--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 225
-- Name: kaato_kaato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kaato_kaato_id_seq OWNED BY public.kaato.kaato_id;


--
-- TOC entry 239 (class 1259 OID 27822)
-- Name: kaatoluettelo; Type: VIEW; Schema: public; Owner: sovellus
--

CREATE VIEW public.kaatoluettelo AS
 SELECT (((jasen.sukunimi)::text || ' '::text) || (jasen.etunimi)::text) AS kaataja,
    kaato.kaatopaiva AS "kaatopäivä",
    kaato.paikka_teksti AS paikka,
    kaato.elaimen_nimi AS "eläin",
    kaato.ikaluokka AS "ikäryhmä",
    kaato.sukupuoli,
    kaato.ruhopaino AS paino,
    kasittely.kasittely_teksti AS "käyttö"
   FROM ((public.jasen
     JOIN public.kaato ON ((jasen.jasen_id = kaato.jasen_id)))
     JOIN public.kasittely ON ((kaato.kasittelyid = kasittely.kasittelyid)))
  ORDER BY kaato.kaato_id DESC;


ALTER TABLE public.kaatoluettelo OWNER TO sovellus;

--
-- TOC entry 226 (class 1259 OID 27669)
-- Name: kaatoyhteenveto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kaatoyhteenveto AS
 SELECT kaato.elaimen_nimi,
    kaato.sukupuoli,
    kaato.ikaluokka,
    count(kaato.elaimen_nimi) AS kpl,
    sum(kaato.ruhopaino) AS kg
   FROM public.kaato
  GROUP BY kaato.elaimen_nimi, kaato.sukupuoli, kaato.ikaluokka;


ALTER TABLE public.kaatoyhteenveto OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 27676)
-- Name: kasittely_kasittelyid_seq_1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kasittely_kasittelyid_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kasittely_kasittelyid_seq_1 OWNER TO postgres;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 228
-- Name: kasittely_kasittelyid_seq_1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kasittely_kasittelyid_seq_1 OWNED BY public.kasittely.kasittelyid;


--
-- TOC entry 246 (class 1259 OID 36037)
-- Name: kaytto_ryhmille; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.kaytto_ryhmille AS
 SELECT kasittely.kasittely_teksti AS source,
    jakoryhma.ryhman_nimi AS target,
    sum(jakotapahtuma.maara) AS value
   FROM (((public.kasittely
     JOIN public.kaato ON ((kasittely.kasittelyid = kaato.kasittelyid)))
     JOIN public.jakotapahtuma ON ((kaato.kaato_id = jakotapahtuma.kaato_id)))
     JOIN public.jakoryhma ON ((jakotapahtuma.ryhma_id = jakoryhma.ryhma_id)))
  WHERE (kaato.kasittelyid = 2)
  GROUP BY kasittely.kasittely_teksti, jakoryhma.ryhman_nimi;


ALTER TABLE public.kaytto_ryhmille OWNER TO postgres;

--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 246
-- Name: VIEW kaytto_ryhmille; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.kaytto_ryhmille IS 'Näkymä, joka kertoo, paljonko lihaa on annettu ryhmille, kun käyttönä on seurueelle';


--
-- TOC entry 245 (class 1259 OID 36033)
-- Name: lihan_kaytto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lihan_kaytto AS
 SELECT kaato.elaimen_nimi AS source,
    kasittely.kasittely_teksti AS target,
    sum(kaato.ruhopaino) AS value
   FROM (public.kaato
     JOIN public.kasittely ON ((kaato.kasittelyid = kasittely.kasittelyid)))
  GROUP BY kaato.elaimen_nimi, kasittely.kasittely_teksti;


ALTER TABLE public.lihan_kaytto OWNER TO postgres;

--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 245
-- Name: VIEW lihan_kaytto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.lihan_kaytto IS 'Kertoo, miten liha on haluttu käyttää: seurueelle, seuralle, myyntiin tai hävitykseen';


--
-- TOC entry 229 (class 1259 OID 27677)
-- Name: lupa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lupa (
    luparivi_id integer NOT NULL,
    seura_id integer NOT NULL,
    lupavuosi character varying(4) NOT NULL,
    elaimen_nimi character varying(20) NOT NULL,
    sukupuoli character varying(10) NOT NULL,
    ikaluokka character varying(10) NOT NULL,
    maara integer NOT NULL
);


ALTER TABLE public.lupa OWNER TO postgres;

--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE lupa; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lupa IS 'Vuosittaiset kaatoluvat';


--
-- TOC entry 230 (class 1259 OID 27680)
-- Name: lupa_luparivi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lupa_luparivi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lupa_luparivi_id_seq OWNER TO postgres;

--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 230
-- Name: lupa_luparivi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lupa_luparivi_id_seq OWNED BY public.lupa.luparivi_id;


--
-- TOC entry 240 (class 1259 OID 27827)
-- Name: nimivalinta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.nimivalinta AS
 SELECT jasen.jasen_id,
    (((jasen.sukunimi)::text || ' '::text) || (jasen.etunimi)::text) AS kokonimi
   FROM public.jasen
  ORDER BY (((jasen.sukunimi)::text || ' '::text) || (jasen.etunimi)::text);


ALTER TABLE public.nimivalinta OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 27832)
-- Name: pgmodule_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pgmodule_test (
    id integer NOT NULL,
    etunimi character varying(30),
    sukunimi character varying(30),
    ika real
);


ALTER TABLE public.pgmodule_test OWNER TO postgres;

--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE pgmodule_test; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.pgmodule_test IS 'Testausta varten, poista ennen tuotantokäyttöä';


--
-- TOC entry 241 (class 1259 OID 27831)
-- Name: pgmodule_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pgmodule_test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pgmodule_test_id_seq OWNER TO postgres;

--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 241
-- Name: pgmodule_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pgmodule_test_id_seq OWNED BY public.pgmodule_test.id;


--
-- TOC entry 231 (class 1259 OID 27681)
-- Name: ruhonosa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruhonosa (
    osnimitys character varying(20) NOT NULL
);


ALTER TABLE public.ruhonosa OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 27684)
-- Name: ryhmien_osuudet; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ryhmien_osuudet AS
 SELECT jasenyys.ryhma_id AS "ryhmä",
    ((sum(jasenyys.osuus))::double precision / (100)::double precision) AS osuuksia
   FROM public.jasenyys
  GROUP BY jasenyys.ryhma_id
  ORDER BY jasenyys.ryhma_id;


ALTER TABLE public.ryhmien_osuudet OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 36042)
-- Name: sankey_data; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sankey_data AS
 SELECT lihan_kaytto.source,
    lihan_kaytto.target,
    lihan_kaytto.value
   FROM public.lihan_kaytto
UNION
 SELECT kaytto_ryhmille.source,
    kaytto_ryhmille.target,
    kaytto_ryhmille.value
   FROM public.kaytto_ryhmille;


ALTER TABLE public.sankey_data OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 27688)
-- Name: seura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seura (
    seura_id integer NOT NULL,
    seuran_nimi character varying(50) NOT NULL,
    jakeluosoite character varying(30) NOT NULL,
    postinumero character varying(10) NOT NULL,
    postitoimipaikka character varying(30) NOT NULL
);


ALTER TABLE public.seura OWNER TO postgres;

--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE seura; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.seura IS 'Metsästysseuran tiedot';


--
-- TOC entry 234 (class 1259 OID 27691)
-- Name: seura_seura_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seura_seura_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seura_seura_id_seq OWNER TO postgres;

--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 234
-- Name: seura_seura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seura_seura_id_seq OWNED BY public.seura.seura_id;


--
-- TOC entry 235 (class 1259 OID 27692)
-- Name: seurue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seurue (
    seurue_id integer NOT NULL,
    seura_id integer NOT NULL,
    seurueen_nimi character varying(50) NOT NULL,
    jasen_id integer NOT NULL
);


ALTER TABLE public.seurue OWNER TO postgres;

--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE seurue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.seurue IS 'Metsästystä harjoittavan seurueen tiedot
';


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN seurue.jasen_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.seurue.jasen_id IS 'Seurueen johtajan tunniste';


--
-- TOC entry 236 (class 1259 OID 27695)
-- Name: seurue_seurue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seurue_seurue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seurue_seurue_id_seq OWNER TO postgres;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 236
-- Name: seurue_seurue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seurue_seurue_id_seq OWNED BY public.seurue.seurue_id;


--
-- TOC entry 244 (class 1259 OID 36028)
-- Name: simple_sankey; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.simple_sankey AS
 SELECT kaato.elaimen_nimi AS source,
    jakoryhma.ryhman_nimi AS target,
    sum(jakotapahtuma.maara) AS value
   FROM ((public.kaato
     JOIN public.jakotapahtuma ON ((kaato.kaato_id = jakotapahtuma.kaato_id)))
     JOIN public.jakoryhma ON ((jakotapahtuma.ryhma_id = jakoryhma.ryhma_id)))
  GROUP BY kaato.elaimen_nimi, jakoryhma.ryhman_nimi;


ALTER TABLE public.simple_sankey OWNER TO postgres;

--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 244
-- Name: VIEW simple_sankey; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.simple_sankey IS 'A view for producing Sankey chart data: source, target and value';


--
-- TOC entry 237 (class 1259 OID 27696)
-- Name: sukupuoli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sukupuoli (
    sukupuoli character varying(10) NOT NULL
);


ALTER TABLE public.sukupuoli OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 27699)
-- Name: testi_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.testi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.testi_seq OWNER TO postgres;

--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 238
-- Name: testi_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.testi_seq OWNED BY public.jakoryhma.ryhma_id;


--
-- TOC entry 3285 (class 2604 OID 27700)
-- Name: jakoryhma ryhma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakoryhma ALTER COLUMN ryhma_id SET DEFAULT nextval('public.jakoryhma_ryhma_id_seq'::regclass);


--
-- TOC entry 3286 (class 2604 OID 27701)
-- Name: jakotapahtuma tapahtuma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma ALTER COLUMN tapahtuma_id SET DEFAULT nextval('public.jakotapahtuma_tapahtuma_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 27702)
-- Name: jasen jasen_id; Type: DEFAULT; Schema: public; Owner: sovellus
--

ALTER TABLE ONLY public.jasen ALTER COLUMN jasen_id SET DEFAULT nextval('public.jasen_jasen_id_seq_1'::regclass);


--
-- TOC entry 3288 (class 2604 OID 27703)
-- Name: jasenyys jasenyys_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys ALTER COLUMN jasenyys_id SET DEFAULT nextval('public.jasenyys_jasenyys_id_seq'::regclass);


--
-- TOC entry 3289 (class 2604 OID 27704)
-- Name: kaato kaato_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato ALTER COLUMN kaato_id SET DEFAULT nextval('public.kaato_kaato_id_seq'::regclass);


--
-- TOC entry 3290 (class 2604 OID 27705)
-- Name: kasittely kasittelyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kasittely ALTER COLUMN kasittelyid SET DEFAULT nextval('public.kasittely_kasittelyid_seq_1'::regclass);


--
-- TOC entry 3291 (class 2604 OID 27706)
-- Name: lupa luparivi_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa ALTER COLUMN luparivi_id SET DEFAULT nextval('public.lupa_luparivi_id_seq'::regclass);


--
-- TOC entry 3294 (class 2604 OID 27835)
-- Name: pgmodule_test id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgmodule_test ALTER COLUMN id SET DEFAULT nextval('public.pgmodule_test_id_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 27707)
-- Name: seura seura_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seura ALTER COLUMN seura_id SET DEFAULT nextval('public.seura_seura_id_seq'::regclass);


--
-- TOC entry 3293 (class 2604 OID 27708)
-- Name: seurue seurue_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue ALTER COLUMN seurue_id SET DEFAULT nextval('public.seurue_seurue_id_seq'::regclass);


--
-- TOC entry 3494 (class 0 OID 27623)
-- Dependencies: 210
-- Data for Name: aikuinenvasa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.aikuinenvasa VALUES ('Aikuinen');
INSERT INTO public.aikuinenvasa VALUES ('Vasa');


--
-- TOC entry 3495 (class 0 OID 27626)
-- Dependencies: 211
-- Data for Name: elain; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.elain VALUES ('Hirvi');
INSERT INTO public.elain VALUES ('Valkohäntäpeura');


--
-- TOC entry 3496 (class 0 OID 27629)
-- Dependencies: 212
-- Data for Name: jakoryhma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jakoryhma VALUES (1, 1, 'Ryhmä 1');
INSERT INTO public.jakoryhma VALUES (2, 1, 'Ryhmä 2');
INSERT INTO public.jakoryhma VALUES (3, 2, 'Ryhmä 3');
INSERT INTO public.jakoryhma VALUES (4, 1, 'Ryhmä 4');
INSERT INTO public.jakoryhma VALUES (6, 1, 'Testiryhmä');


--
-- TOC entry 3497 (class 0 OID 27632)
-- Dependencies: 213
-- Data for Name: jakotapahtuma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jakotapahtuma VALUES (1, '2022-10-05', 1, 'Koko', 210, 1);
INSERT INTO public.jakotapahtuma VALUES (2, '2022-10-02', 1, 'Puolikas', 75, 2);
INSERT INTO public.jakotapahtuma VALUES (3, '2022-10-02', 2, 'Puolikas', 75, 2);


--
-- TOC entry 3493 (class 0 OID 27619)
-- Dependencies: 209
-- Data for Name: jasen; Type: TABLE DATA; Schema: public; Owner: sovellus
--

INSERT INTO public.jasen VALUES (1, 'Janne', 'Jousi', 'Kotikatu 2', '21200', 'Raisio');
INSERT INTO public.jasen VALUES (2, 'Tauno', 'Tappara', 'Viertotie 5', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (3, 'Kalle', 'Kaaripyssy', 'Isotie 144', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (4, 'Heikki', 'Haulikko', 'Pikkutie 22', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (5, 'Tauno', 'Tussari', 'Isotie 210', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (6, 'Piia', 'Pyssy', 'Jokikatu 2', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (7, 'Tiina', 'Talikko', 'Kirkkotie 7', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (8, 'Bertil', 'Bössa', 'Hemväg 4', '20100', 'Åbo');
INSERT INTO public.jasen VALUES (9, 'Ville', 'Vesuri', 'Jokikatu 2', '23100', 'Mynämäki');
INSERT INTO public.jasen VALUES (10, 'Kurt', 'Kirves', 'Pohjanperkontie 122', '23100', 'Mynämäki');


--
-- TOC entry 3499 (class 0 OID 27644)
-- Dependencies: 217
-- Data for Name: jasenyys; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jasenyys VALUES (1, 1, 1, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (2, 1, 2, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (3, 1, 3, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (4, 2, 4, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (6, 2, 6, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (7, 3, 7, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (8, 3, 8, '2022-01-01', NULL, 100);
INSERT INTO public.jasenyys VALUES (9, 3, 9, '2022-01-01', NULL, 50);


--
-- TOC entry 3503 (class 0 OID 27655)
-- Dependencies: 222
-- Data for Name: kaato; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kaato VALUES (1, 5, '2022-09-28', 250, 'Takapellon eteläpää, Jyrkkälä', '61.58,21.54', 1, 'Hirvi', 'Uros', 'Aikuinen', NULL);
INSERT INTO public.kaato VALUES (2, 6, '2022-09-28', 200, 'Takapellon eteläpää, Jyrkkälä', '61.58,21.54', 2, 'Hirvi', 'Naaras', 'Aikuinen', NULL);
INSERT INTO public.kaato VALUES (4, 8, '2022-11-15', 100, 'Raimela', NULL, 2, 'Valkohäntäpeura', 'Naaras', 'Aikuinen', 'Hiihoo');
INSERT INTO public.kaato VALUES (5, 9, '2022-11-23', 80, 'Mustila', NULL, 1, 'Valkohäntäpeura', 'Naaras', 'Aikuinen', 'Bambi');
INSERT INTO public.kaato VALUES (6, 3, '2022-11-15', 210, 'Hämölä', NULL, 2, 'Hirvi', 'Naaras', 'Aikuinen', 'Sen vasa oli liian nopea');
INSERT INTO public.kaato VALUES (7, 1, '2022-11-15', 350, 'Pohjanperkko', NULL, 2, 'Hirvi', 'Uros', 'Aikuinen', '9-piikkiset sarvet');
INSERT INTO public.kaato VALUES (8, 10, '2022-11-23', 75, 'Mustila', NULL, 1, 'Valkohäntäpeura', 'Uros', 'Vasa', 'Suurikokoinen ikäisekseen');
INSERT INTO public.kaato VALUES (9, 2, '2022-11-29', 500, 'Raisio', NULL, 2, 'Hirvi', 'Uros', 'Aikuinen', 'Pirun iso');
INSERT INTO public.kaato VALUES (10, 8, '2022-11-29', 50, 'Taimo', NULL, 2, 'Valkohäntäpeura', 'Naaras', 'Vasa', 'Pikku');
INSERT INTO public.kaato VALUES (11, 8, '2022-11-29', 60, 'Joku paikka', NULL, 1, 'Valkohäntäpeura', 'Uros', 'Vasa', '');


--
-- TOC entry 3505 (class 0 OID 27673)
-- Dependencies: 227
-- Data for Name: kasittely; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kasittely VALUES (1, 'Seuralle');
INSERT INTO public.kasittely VALUES (2, 'Seurueelle');
INSERT INTO public.kasittely VALUES (3, 'Myyntiin');
INSERT INTO public.kasittely VALUES (4, 'Hävitetään');


--
-- TOC entry 3507 (class 0 OID 27677)
-- Dependencies: 229
-- Data for Name: lupa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lupa VALUES (1, 1, '2022', 'Hirvi', 'Uros', 'Aikuinen', 10);
INSERT INTO public.lupa VALUES (2, 1, '2022', 'Hirvi', 'Naaras', 'Aikuinen', 15);
INSERT INTO public.lupa VALUES (3, 1, '2022', 'Valkohäntäpeura', 'Uros', 'Aikuinen', 100);
INSERT INTO public.lupa VALUES (4, 1, '2022', 'Valkohäntäpeura', 'Naaras', 'Aikuinen', 200);
INSERT INTO public.lupa VALUES (5, 1, '2022', 'Hirvi', 'Uros', 'Vasa', 20);


--
-- TOC entry 3517 (class 0 OID 27832)
-- Dependencies: 242
-- Data for Name: pgmodule_test; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pgmodule_test VALUES (1, 'Jonne', 'Janttari', 17);
INSERT INTO public.pgmodule_test VALUES (4, 'Jaana', 'Janttari', 17);
INSERT INTO public.pgmodule_test VALUES (5, 'Jaana', 'Janttari', 17);
INSERT INTO public.pgmodule_test VALUES (6, 'Jaana', 'Janttari', 17);


--
-- TOC entry 3509 (class 0 OID 27681)
-- Dependencies: 231
-- Data for Name: ruhonosa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ruhonosa VALUES ('Koko');
INSERT INTO public.ruhonosa VALUES ('Puolikas');
INSERT INTO public.ruhonosa VALUES ('Neljännes');


--
-- TOC entry 3510 (class 0 OID 27688)
-- Dependencies: 233
-- Data for Name: seura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.seura VALUES (1, 'Punaiset hatut ja nenät', 'Keskuskatu 1', '23100', 'Mynämäki');


--
-- TOC entry 3512 (class 0 OID 27692)
-- Dependencies: 235
-- Data for Name: seurue; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.seurue VALUES (1, 1, 'Seurue1', 6);
INSERT INTO public.seurue VALUES (2, 1, 'Seurue2', 1);


--
-- TOC entry 3514 (class 0 OID 27696)
-- Dependencies: 237
-- Data for Name: sukupuoli; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sukupuoli VALUES ('Uros');
INSERT INTO public.sukupuoli VALUES ('Naaras');


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 216
-- Name: jakoryhma_ryhma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jakoryhma_ryhma_id_seq', 6, true);


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 219
-- Name: jakotapahtuma_tapahtuma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jakotapahtuma_tapahtuma_id_seq', 3, true);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 220
-- Name: jasen_jasen_id_seq_1; Type: SEQUENCE SET; Schema: public; Owner: sovellus
--

SELECT pg_catalog.setval('public.jasen_jasen_id_seq_1', 10, true);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 221
-- Name: jasenyys_jasenyys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jasenyys_jasenyys_id_seq', 9, true);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 225
-- Name: kaato_kaato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kaato_kaato_id_seq', 11, true);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 228
-- Name: kasittely_kasittelyid_seq_1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kasittely_kasittelyid_seq_1', 4, true);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 230
-- Name: lupa_luparivi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lupa_luparivi_id_seq', 5, true);


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 241
-- Name: pgmodule_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pgmodule_test_id_seq', 6, true);


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 234
-- Name: seura_seura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seura_seura_id_seq', 1, true);


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 236
-- Name: seurue_seurue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seurue_seurue_id_seq', 2, true);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 238
-- Name: testi_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.testi_seq', 1, false);


--
-- TOC entry 3298 (class 2606 OID 27710)
-- Name: aikuinenvasa aikuinenvasa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aikuinenvasa
    ADD CONSTRAINT aikuinenvasa_pk PRIMARY KEY (ikaluokka);


--
-- TOC entry 3300 (class 2606 OID 27712)
-- Name: elain elain_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elain
    ADD CONSTRAINT elain_pk PRIMARY KEY (elaimen_nimi);


--
-- TOC entry 3302 (class 2606 OID 27714)
-- Name: jakoryhma jakoryhma_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakoryhma
    ADD CONSTRAINT jakoryhma_pk PRIMARY KEY (ryhma_id);


--
-- TOC entry 3304 (class 2606 OID 27716)
-- Name: jakotapahtuma jakotapahtuma_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT jakotapahtuma_pk PRIMARY KEY (tapahtuma_id);


--
-- TOC entry 3296 (class 2606 OID 27718)
-- Name: jasen jasen_pk; Type: CONSTRAINT; Schema: public; Owner: sovellus
--

ALTER TABLE ONLY public.jasen
    ADD CONSTRAINT jasen_pk PRIMARY KEY (jasen_id);


--
-- TOC entry 3306 (class 2606 OID 27720)
-- Name: jasenyys jasenyys_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys
    ADD CONSTRAINT jasenyys_pk PRIMARY KEY (jasenyys_id);


--
-- TOC entry 3308 (class 2606 OID 27722)
-- Name: kaato kaato_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT kaato_pk PRIMARY KEY (kaato_id);


--
-- TOC entry 3310 (class 2606 OID 27724)
-- Name: kasittely kasittely_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kasittely
    ADD CONSTRAINT kasittely_pk PRIMARY KEY (kasittelyid);


--
-- TOC entry 3312 (class 2606 OID 27726)
-- Name: lupa lupa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT lupa_pk PRIMARY KEY (luparivi_id);


--
-- TOC entry 3322 (class 2606 OID 27837)
-- Name: pgmodule_test pgmodule_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgmodule_test
    ADD CONSTRAINT pgmodule_test_pkey PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 27728)
-- Name: ruhonosa ruhonosa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruhonosa
    ADD CONSTRAINT ruhonosa_pk PRIMARY KEY (osnimitys);


--
-- TOC entry 3316 (class 2606 OID 27730)
-- Name: seura seura_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seura
    ADD CONSTRAINT seura_pk PRIMARY KEY (seura_id);


--
-- TOC entry 3318 (class 2606 OID 27732)
-- Name: seurue seurue_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue
    ADD CONSTRAINT seurue_pk PRIMARY KEY (seurue_id);


--
-- TOC entry 3320 (class 2606 OID 27734)
-- Name: sukupuoli sukupuoli_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sukupuoli
    ADD CONSTRAINT sukupuoli_pk PRIMARY KEY (sukupuoli);


--
-- TOC entry 3329 (class 2606 OID 27735)
-- Name: kaato aikuinen_vasa_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT aikuinen_vasa_kaato_fk FOREIGN KEY (ikaluokka) REFERENCES public.aikuinenvasa(ikaluokka);


--
-- TOC entry 3334 (class 2606 OID 27740)
-- Name: lupa aikuinen_vasa_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT aikuinen_vasa_lupa_fk FOREIGN KEY (ikaluokka) REFERENCES public.aikuinenvasa(ikaluokka);


--
-- TOC entry 3330 (class 2606 OID 27745)
-- Name: kaato elain_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT elain_kaato_fk FOREIGN KEY (elaimen_nimi) REFERENCES public.elain(elaimen_nimi);


--
-- TOC entry 3335 (class 2606 OID 27750)
-- Name: lupa elain_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT elain_lupa_fk FOREIGN KEY (elaimen_nimi) REFERENCES public.elain(elaimen_nimi);


--
-- TOC entry 3327 (class 2606 OID 27755)
-- Name: jasenyys jasen_jasenyys_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys
    ADD CONSTRAINT jasen_jasenyys_fk FOREIGN KEY (jasen_id) REFERENCES public.jasen(jasen_id);


--
-- TOC entry 3331 (class 2606 OID 27760)
-- Name: kaato jasen_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT jasen_kaato_fk FOREIGN KEY (jasen_id) REFERENCES public.jasen(jasen_id);


--
-- TOC entry 3338 (class 2606 OID 27765)
-- Name: seurue jasen_seurue_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue
    ADD CONSTRAINT jasen_seurue_fk FOREIGN KEY (jasen_id) REFERENCES public.jasen(jasen_id);


--
-- TOC entry 3324 (class 2606 OID 27770)
-- Name: jakotapahtuma kaato_jakotapahtuma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT kaato_jakotapahtuma_fk FOREIGN KEY (kaato_id) REFERENCES public.kaato(kaato_id) NOT VALID;


--
-- TOC entry 3332 (class 2606 OID 27775)
-- Name: kaato kasittely_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT kasittely_kaato_fk FOREIGN KEY (kasittelyid) REFERENCES public.kasittely(kasittelyid);


--
-- TOC entry 3325 (class 2606 OID 27780)
-- Name: jakotapahtuma ruhonosa_jakotapahtuma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT ruhonosa_jakotapahtuma_fk FOREIGN KEY (osnimitys) REFERENCES public.ruhonosa(osnimitys);


--
-- TOC entry 3326 (class 2606 OID 27785)
-- Name: jakotapahtuma ryhma_jakotapahtuma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT ryhma_jakotapahtuma_fk FOREIGN KEY (ryhma_id) REFERENCES public.jakoryhma(ryhma_id);


--
-- TOC entry 3328 (class 2606 OID 27790)
-- Name: jasenyys ryhma_jasenyys_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys
    ADD CONSTRAINT ryhma_jasenyys_fk FOREIGN KEY (ryhma_id) REFERENCES public.jakoryhma(ryhma_id);


--
-- TOC entry 3336 (class 2606 OID 27795)
-- Name: lupa seura_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT seura_lupa_fk FOREIGN KEY (seura_id) REFERENCES public.seura(seura_id);


--
-- TOC entry 3339 (class 2606 OID 27800)
-- Name: seurue seura_seurue_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue
    ADD CONSTRAINT seura_seurue_fk FOREIGN KEY (seura_id) REFERENCES public.seura(seura_id);


--
-- TOC entry 3323 (class 2606 OID 27805)
-- Name: jakoryhma seurue_ryhma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakoryhma
    ADD CONSTRAINT seurue_ryhma_fk FOREIGN KEY (seurue_id) REFERENCES public.seurue(seurue_id);


--
-- TOC entry 3333 (class 2606 OID 27810)
-- Name: kaato sukupuoli_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT sukupuoli_kaato_fk FOREIGN KEY (sukupuoli) REFERENCES public.sukupuoli(sukupuoli);


--
-- TOC entry 3337 (class 2606 OID 27815)
-- Name: lupa sukupuoli_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT sukupuoli_lupa_fk FOREIGN KEY (sukupuoli) REFERENCES public.sukupuoli(sukupuoli);


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 249
-- Name: PROCEDURE add_jakoryhma(IN seurue integer, IN ryhman_nimi character varying); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON PROCEDURE public.add_jakoryhma(IN seurue integer, IN ryhman_nimi character varying) FROM postgres;
GRANT ALL ON PROCEDURE public.add_jakoryhma(IN seurue integer, IN ryhman_nimi character varying) TO postgres WITH GRANT OPTION;
GRANT ALL ON PROCEDURE public.add_jakoryhma(IN seurue integer, IN ryhman_nimi character varying) TO sovellus;


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE jasen; Type: ACL; Schema: public; Owner: sovellus
--

REVOKE ALL ON TABLE public.jasen FROM sovellus;
GRANT ALL ON TABLE public.jasen TO sovellus WITH GRANT OPTION;


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 248
-- Name: FUNCTION get_member(id integer); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.get_member(id integer) FROM postgres;
GRANT ALL ON FUNCTION public.get_member(id integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION public.get_member(id integer) TO sovellus;


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE aikuinenvasa; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.aikuinenvasa FROM postgres;
GRANT ALL ON TABLE public.aikuinenvasa TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.aikuinenvasa TO sovellus;


--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE elain; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.elain FROM postgres;
GRANT ALL ON TABLE public.elain TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.elain TO sovellus;


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE kaato; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.kaato FROM postgres;
GRANT ALL ON TABLE public.kaato TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.kaato TO sovellus;


--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE kasittely; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.kasittely FROM postgres;
GRANT ALL ON TABLE public.kasittely TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.kasittely TO sovellus;


--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE jaettavat_lihat; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.jaettavat_lihat TO sovellus;


--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE jakoryhma; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.jakoryhma FROM postgres;
GRANT ALL ON TABLE public.jakoryhma TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.jakoryhma TO sovellus;


--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE jakotapahtuma; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.jakotapahtuma FROM postgres;
GRANT ALL ON TABLE public.jakotapahtuma TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.jakotapahtuma TO sovellus;


--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE jaetut_lihat; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.jaetut_lihat FROM postgres;
GRANT ALL ON TABLE public.jaetut_lihat TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.jaetut_lihat TO sovellus;


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE jako_ka; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.jako_ka FROM postgres;
GRANT ALL ON TABLE public.jako_ka TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.jako_ka TO sovellus;


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE jakoryhma_ryhma_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.jakoryhma_ryhma_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.jakoryhma_ryhma_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.jakoryhma_ryhma_id_seq TO sovellus;


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE jasenyys; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.jasenyys FROM postgres;
GRANT ALL ON TABLE public.jasenyys TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.jasenyys TO sovellus;


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE jakoryhma_yhteenveto; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.jakoryhma_yhteenveto FROM postgres;
GRANT ALL ON TABLE public.jakoryhma_yhteenveto TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.jakoryhma_yhteenveto TO sovellus;


--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE jakotapahtuma_tapahtuma_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.jakotapahtuma_tapahtuma_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.jakotapahtuma_tapahtuma_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.jakotapahtuma_tapahtuma_id_seq TO sovellus;


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE jasen_jasen_id_seq_1; Type: ACL; Schema: public; Owner: sovellus
--

REVOKE ALL ON SEQUENCE public.jasen_jasen_id_seq_1 FROM sovellus;
GRANT ALL ON SEQUENCE public.jasen_jasen_id_seq_1 TO sovellus WITH GRANT OPTION;


--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE jasenyys_jasenyys_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.jasenyys_jasenyys_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.jasenyys_jasenyys_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.jasenyys_jasenyys_id_seq TO sovellus;


--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE kaadot_ampujittain; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.kaadot_ampujittain FROM postgres;
GRANT ALL ON TABLE public.kaadot_ampujittain TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.kaadot_ampujittain TO sovellus;


--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE kaadot_ryhmittain; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.kaadot_ryhmittain FROM postgres;
GRANT ALL ON TABLE public.kaadot_ryhmittain TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.kaadot_ryhmittain TO sovellus;


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE kaato_kaato_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.kaato_kaato_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.kaato_kaato_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.kaato_kaato_id_seq TO sovellus;


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE kaatoluettelo; Type: ACL; Schema: public; Owner: sovellus
--

GRANT ALL ON TABLE public.kaatoluettelo TO postgres WITH GRANT OPTION;


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE kaatoyhteenveto; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.kaatoyhteenveto FROM postgres;
GRANT ALL ON TABLE public.kaatoyhteenveto TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.kaatoyhteenveto TO sovellus;


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE kasittely_kasittelyid_seq_1; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.kasittely_kasittelyid_seq_1 FROM postgres;
GRANT ALL ON SEQUENCE public.kasittely_kasittelyid_seq_1 TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.kasittely_kasittelyid_seq_1 TO sovellus;


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE kaytto_ryhmille; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.kaytto_ryhmille TO sovellus;


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE lihan_kaytto; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.lihan_kaytto TO sovellus;


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE lupa; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.lupa FROM postgres;
GRANT ALL ON TABLE public.lupa TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.lupa TO sovellus;


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE lupa_luparivi_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.lupa_luparivi_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.lupa_luparivi_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.lupa_luparivi_id_seq TO sovellus;


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE nimivalinta; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nimivalinta TO sovellus;


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE pgmodule_test; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pgmodule_test TO sovellus;


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 241
-- Name: SEQUENCE pgmodule_test_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pgmodule_test_id_seq TO sovellus;


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE ruhonosa; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.ruhonosa FROM postgres;
GRANT ALL ON TABLE public.ruhonosa TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.ruhonosa TO sovellus;


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE ryhmien_osuudet; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.ryhmien_osuudet FROM postgres;
GRANT ALL ON TABLE public.ryhmien_osuudet TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.ryhmien_osuudet TO sovellus;


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE sankey_data; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sankey_data TO sovellus;


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE seura; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.seura FROM postgres;
GRANT ALL ON TABLE public.seura TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.seura TO sovellus;


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE seura_seura_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.seura_seura_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.seura_seura_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.seura_seura_id_seq TO sovellus;


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE seurue; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.seurue FROM postgres;
GRANT ALL ON TABLE public.seurue TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.seurue TO sovellus;


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 236
-- Name: SEQUENCE seurue_seurue_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.seurue_seurue_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.seurue_seurue_id_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.seurue_seurue_id_seq TO sovellus;


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE simple_sankey; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.simple_sankey TO sovellus;


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE sukupuoli; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.sukupuoli FROM postgres;
GRANT ALL ON TABLE public.sukupuoli TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE public.sukupuoli TO sovellus;


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 238
-- Name: SEQUENCE testi_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE public.testi_seq FROM postgres;
GRANT ALL ON SEQUENCE public.testi_seq TO postgres WITH GRANT OPTION;
GRANT ALL ON SEQUENCE public.testi_seq TO sovellus;


-- Completed on 2022-12-13 09:34:06

--
-- PostgreSQL database dump complete
--

