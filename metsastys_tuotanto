--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-11-16 09:25:27

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
-- TOC entry 239 (class 1255 OID 28372)
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
-- TOC entry 209 (class 1259 OID 28373)
-- Name: jasen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jasen (
    jasen_id integer NOT NULL,
    etunimi character varying(50) NOT NULL,
    sukunimi character varying(50) NOT NULL,
    jakeluosoite character varying(30) NOT NULL,
    postinumero character varying(10) NOT NULL,
    postitoimipaikka character varying(30) NOT NULL
);


ALTER TABLE public.jasen OWNER TO postgres;

--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE jasen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.jasen IS 'Henkilö joka osallistuu metsästykseen tai lihanjakoon';


--
-- TOC entry 240 (class 1255 OID 28376)
-- Name: get_member(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_member(id integer) RETURNS SETOF public.jasen
    LANGUAGE sql
    AS $$
SELECT * FROM public.jasen WHERE jasen_id = id;
$$;


ALTER FUNCTION public.get_member(id integer) OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 28377)
-- Name: aikuinenvasa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aikuinenvasa (
    ikaluokka character varying(10) NOT NULL
);


ALTER TABLE public.aikuinenvasa OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 28380)
-- Name: elain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elain (
    elaimen_nimi character varying(20) NOT NULL
);


ALTER TABLE public.elain OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 28383)
-- Name: jakoryhma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jakoryhma (
    ryhma_id integer NOT NULL,
    seurue_id integer NOT NULL,
    ryhman_nimi character varying(50) NOT NULL
);


ALTER TABLE public.jakoryhma OWNER TO postgres;

--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE jakoryhma; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.jakoryhma IS 'Ryhmä, jolle lihaa jaetaan';


--
-- TOC entry 213 (class 1259 OID 28386)
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
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN jakotapahtuma.maara; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.jakotapahtuma.maara IS 'Jaettu lihamäärä kiloina';


--
-- TOC entry 214 (class 1259 OID 28389)
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
-- TOC entry 235 (class 1259 OID 28556)
-- Name: jako_ka; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.jako_ka AS
 SELECT avg(jaetut_lihat.kg) AS liha_ka
   FROM public.jaetut_lihat;


ALTER TABLE public.jako_ka OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 28393)
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
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 215
-- Name: jakoryhma_ryhma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jakoryhma_ryhma_id_seq OWNED BY public.jakoryhma.ryhma_id;


--
-- TOC entry 216 (class 1259 OID 28394)
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
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN jasenyys.osuus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.jasenyys.osuus IS 'Muuta pakolliseksi (NOT NULL)';


--
-- TOC entry 217 (class 1259 OID 28398)
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
-- TOC entry 218 (class 1259 OID 28402)
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
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 218
-- Name: jakotapahtuma_tapahtuma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jakotapahtuma_tapahtuma_id_seq OWNED BY public.jakotapahtuma.tapahtuma_id;


--
-- TOC entry 219 (class 1259 OID 28403)
-- Name: jasen_jasen_id_seq_1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jasen_jasen_id_seq_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jasen_jasen_id_seq_1 OWNER TO postgres;

--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 219
-- Name: jasen_jasen_id_seq_1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jasen_jasen_id_seq_1 OWNED BY public.jasen.jasen_id;


--
-- TOC entry 220 (class 1259 OID 28404)
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
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 220
-- Name: jasenyys_jasenyys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jasenyys_jasenyys_id_seq OWNED BY public.jasenyys.jasenyys_id;


--
-- TOC entry 221 (class 1259 OID 28405)
-- Name: kaato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kaato (
    kaato_id integer NOT NULL,
    jasen_id integer NOT NULL,
    kaatopaiva date NOT NULL,
    ruhopaino real NOT NULL,
    paikka_teksti character varying(100) NOT NULL,
    paikka_koordinaatti character varying(100) NOT NULL,
    kasittelyid integer NOT NULL,
    elaimen_nimi character varying(20) NOT NULL,
    sukupuoli character varying(10) NOT NULL,
    ikaluokka character varying(10) NOT NULL
);


ALTER TABLE public.kaato OWNER TO postgres;

--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE kaato; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.kaato IS 'Ampumatapahtuman tiedot';


--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN kaato.ruhopaino; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.kaato.ruhopaino IS 'paino kiloina';


--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN kaato.paikka_koordinaatti; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.kaato.paikka_koordinaatti IS 'Tämän kentän tietotyyppi pitää oikeasti olla geometry (Postgis-tietotyyppi)';


--
-- TOC entry 236 (class 1259 OID 28560)
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
-- TOC entry 237 (class 1259 OID 28565)
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
-- TOC entry 222 (class 1259 OID 28408)
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
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 222
-- Name: kaato_kaato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kaato_kaato_id_seq OWNED BY public.kaato.kaato_id;


--
-- TOC entry 238 (class 1259 OID 28570)
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
-- TOC entry 223 (class 1259 OID 28409)
-- Name: kasittely; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kasittely (
    kasittelyid integer NOT NULL,
    kasittely_teksti character varying(50) NOT NULL
);


ALTER TABLE public.kasittely OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 28412)
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
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 224
-- Name: kasittely_kasittelyid_seq_1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kasittely_kasittelyid_seq_1 OWNED BY public.kasittely.kasittelyid;


--
-- TOC entry 225 (class 1259 OID 28413)
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
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE lupa; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lupa IS 'Vuosittaiset kaatoluvat';


--
-- TOC entry 226 (class 1259 OID 28416)
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
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 226
-- Name: lupa_luparivi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lupa_luparivi_id_seq OWNED BY public.lupa.luparivi_id;


--
-- TOC entry 227 (class 1259 OID 28417)
-- Name: ruhonosa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruhonosa (
    osnimitys character varying(20) NOT NULL
);


ALTER TABLE public.ruhonosa OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 28420)
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
-- TOC entry 229 (class 1259 OID 28424)
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
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE seura; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.seura IS 'Metsästysseuran tiedot';


--
-- TOC entry 230 (class 1259 OID 28427)
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
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 230
-- Name: seura_seura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seura_seura_id_seq OWNED BY public.seura.seura_id;


--
-- TOC entry 231 (class 1259 OID 28428)
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
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE seurue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.seurue IS 'Metsästystä harjoittavan seurueen tiedot
';


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN seurue.jasen_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.seurue.jasen_id IS 'Seurueen johtajan tunniste';


--
-- TOC entry 232 (class 1259 OID 28431)
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
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 232
-- Name: seurue_seurue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seurue_seurue_id_seq OWNED BY public.seurue.seurue_id;


--
-- TOC entry 233 (class 1259 OID 28432)
-- Name: sukupuoli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sukupuoli (
    sukupuoli character varying(10) NOT NULL
);


ALTER TABLE public.sukupuoli OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 28435)
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
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 234
-- Name: testi_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.testi_seq OWNED BY public.jakoryhma.ryhma_id;


--
-- TOC entry 3252 (class 2604 OID 28436)
-- Name: jakoryhma ryhma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakoryhma ALTER COLUMN ryhma_id SET DEFAULT nextval('public.jakoryhma_ryhma_id_seq'::regclass);


--
-- TOC entry 3253 (class 2604 OID 28437)
-- Name: jakotapahtuma tapahtuma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma ALTER COLUMN tapahtuma_id SET DEFAULT nextval('public.jakotapahtuma_tapahtuma_id_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 28438)
-- Name: jasen jasen_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasen ALTER COLUMN jasen_id SET DEFAULT nextval('public.jasen_jasen_id_seq_1'::regclass);


--
-- TOC entry 3255 (class 2604 OID 28439)
-- Name: jasenyys jasenyys_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys ALTER COLUMN jasenyys_id SET DEFAULT nextval('public.jasenyys_jasenyys_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 28440)
-- Name: kaato kaato_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato ALTER COLUMN kaato_id SET DEFAULT nextval('public.kaato_kaato_id_seq'::regclass);


--
-- TOC entry 3257 (class 2604 OID 28441)
-- Name: kasittely kasittelyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kasittely ALTER COLUMN kasittelyid SET DEFAULT nextval('public.kasittely_kasittelyid_seq_1'::regclass);


--
-- TOC entry 3258 (class 2604 OID 28442)
-- Name: lupa luparivi_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa ALTER COLUMN luparivi_id SET DEFAULT nextval('public.lupa_luparivi_id_seq'::regclass);


--
-- TOC entry 3259 (class 2604 OID 28443)
-- Name: seura seura_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seura ALTER COLUMN seura_id SET DEFAULT nextval('public.seura_seura_id_seq'::regclass);


--
-- TOC entry 3260 (class 2604 OID 28444)
-- Name: seurue seurue_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue ALTER COLUMN seurue_id SET DEFAULT nextval('public.seurue_seurue_id_seq'::regclass);


--
-- TOC entry 3451 (class 0 OID 28377)
-- Dependencies: 210
-- Data for Name: aikuinenvasa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.aikuinenvasa VALUES ('Aikuinen');
INSERT INTO public.aikuinenvasa VALUES ('Vasa');


--
-- TOC entry 3452 (class 0 OID 28380)
-- Dependencies: 211
-- Data for Name: elain; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.elain VALUES ('Hirvi');
INSERT INTO public.elain VALUES ('Valkohäntäpeura');


--
-- TOC entry 3453 (class 0 OID 28383)
-- Dependencies: 212
-- Data for Name: jakoryhma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jakoryhma VALUES (1, 1, 'Ryhmä 1');
INSERT INTO public.jakoryhma VALUES (2, 1, 'Ryhmä 2');
INSERT INTO public.jakoryhma VALUES (3, 2, 'Ryhmä 3');
INSERT INTO public.jakoryhma VALUES (4, 1, 'Ryhmä 4');
INSERT INTO public.jakoryhma VALUES (6, 1, 'Testiryhmä');


--
-- TOC entry 3454 (class 0 OID 28386)
-- Dependencies: 213
-- Data for Name: jakotapahtuma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jakotapahtuma VALUES (1, '2022-10-05', 1, 'Koko', 210, NULL);
INSERT INTO public.jakotapahtuma VALUES (2, '2022-10-02', 1, 'Puolikas', 75, NULL);
INSERT INTO public.jakotapahtuma VALUES (3, '2022-10-02', 2, 'Puolikas', 75, NULL);


--
-- TOC entry 3450 (class 0 OID 28373)
-- Dependencies: 209
-- Data for Name: jasen; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- TOC entry 3456 (class 0 OID 28394)
-- Dependencies: 216
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
-- TOC entry 3460 (class 0 OID 28405)
-- Dependencies: 221
-- Data for Name: kaato; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kaato VALUES (1, 5, '2022-09-28', 250, 'Takapellon eteläpää, Jyrkkälä', '61.58,21.54', 1, 'Hirvi', 'Uros', 'Aikuinen');
INSERT INTO public.kaato VALUES (2, 6, '2022-09-28', 200, 'Takapellon eteläpää, Jyrkkälä', '61.58,21.54', 2, 'Hirvi', 'Naaras', 'Aikuinen');


--
-- TOC entry 3462 (class 0 OID 28409)
-- Dependencies: 223
-- Data for Name: kasittely; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kasittely VALUES (1, 'Seuralle');
INSERT INTO public.kasittely VALUES (2, 'Seurueelle');
INSERT INTO public.kasittely VALUES (3, 'Myyntiin');
INSERT INTO public.kasittely VALUES (4, 'Hävitetään');


--
-- TOC entry 3464 (class 0 OID 28413)
-- Dependencies: 225
-- Data for Name: lupa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lupa VALUES (1, 1, '2022', 'Hirvi', 'Uros', 'Aikuinen', 10);
INSERT INTO public.lupa VALUES (2, 1, '2022', 'Hirvi', 'Naaras', 'Aikuinen', 15);
INSERT INTO public.lupa VALUES (3, 1, '2022', 'Valkohäntäpeura', 'Uros', 'Aikuinen', 100);
INSERT INTO public.lupa VALUES (4, 1, '2022', 'Valkohäntäpeura', 'Naaras', 'Aikuinen', 200);
INSERT INTO public.lupa VALUES (5, 1, '2022', 'Hirvi', 'Uros', 'Vasa', 20);


--
-- TOC entry 3466 (class 0 OID 28417)
-- Dependencies: 227
-- Data for Name: ruhonosa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ruhonosa VALUES ('Koko');
INSERT INTO public.ruhonosa VALUES ('Puolikas');
INSERT INTO public.ruhonosa VALUES ('Neljännes');


--
-- TOC entry 3467 (class 0 OID 28424)
-- Dependencies: 229
-- Data for Name: seura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.seura VALUES (1, 'Punaiset hatut ja nenät', 'Keskuskatu 1', '23100', 'Mynämäki');


--
-- TOC entry 3469 (class 0 OID 28428)
-- Dependencies: 231
-- Data for Name: seurue; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.seurue VALUES (1, 1, 'Seurue1', 6);
INSERT INTO public.seurue VALUES (2, 1, 'Seurue2', 1);


--
-- TOC entry 3471 (class 0 OID 28432)
-- Dependencies: 233
-- Data for Name: sukupuoli; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sukupuoli VALUES ('Uros');
INSERT INTO public.sukupuoli VALUES ('Naaras');


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 215
-- Name: jakoryhma_ryhma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jakoryhma_ryhma_id_seq', 6, true);


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 218
-- Name: jakotapahtuma_tapahtuma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jakotapahtuma_tapahtuma_id_seq', 3, true);


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 219
-- Name: jasen_jasen_id_seq_1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jasen_jasen_id_seq_1', 10, true);


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 220
-- Name: jasenyys_jasenyys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jasenyys_jasenyys_id_seq', 9, true);


--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 222
-- Name: kaato_kaato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kaato_kaato_id_seq', 2, true);


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 224
-- Name: kasittely_kasittelyid_seq_1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kasittely_kasittelyid_seq_1', 4, true);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 226
-- Name: lupa_luparivi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lupa_luparivi_id_seq', 5, true);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 230
-- Name: seura_seura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seura_seura_id_seq', 1, true);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 232
-- Name: seurue_seurue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seurue_seurue_id_seq', 2, true);


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 234
-- Name: testi_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.testi_seq', 1, false);


--
-- TOC entry 3264 (class 2606 OID 28446)
-- Name: aikuinenvasa aikuinenvasa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aikuinenvasa
    ADD CONSTRAINT aikuinenvasa_pk PRIMARY KEY (ikaluokka);


--
-- TOC entry 3266 (class 2606 OID 28448)
-- Name: elain elain_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elain
    ADD CONSTRAINT elain_pk PRIMARY KEY (elaimen_nimi);


--
-- TOC entry 3268 (class 2606 OID 28450)
-- Name: jakoryhma jakoryhma_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakoryhma
    ADD CONSTRAINT jakoryhma_pk PRIMARY KEY (ryhma_id);


--
-- TOC entry 3270 (class 2606 OID 28452)
-- Name: jakotapahtuma jakotapahtuma_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT jakotapahtuma_pk PRIMARY KEY (tapahtuma_id);


--
-- TOC entry 3262 (class 2606 OID 28454)
-- Name: jasen jasen_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasen
    ADD CONSTRAINT jasen_pk PRIMARY KEY (jasen_id);


--
-- TOC entry 3272 (class 2606 OID 28456)
-- Name: jasenyys jasenyys_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys
    ADD CONSTRAINT jasenyys_pk PRIMARY KEY (jasenyys_id);


--
-- TOC entry 3274 (class 2606 OID 28458)
-- Name: kaato kaato_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT kaato_pk PRIMARY KEY (kaato_id);


--
-- TOC entry 3276 (class 2606 OID 28460)
-- Name: kasittely kasittely_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kasittely
    ADD CONSTRAINT kasittely_pk PRIMARY KEY (kasittelyid);


--
-- TOC entry 3278 (class 2606 OID 28462)
-- Name: lupa lupa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT lupa_pk PRIMARY KEY (luparivi_id);


--
-- TOC entry 3280 (class 2606 OID 28464)
-- Name: ruhonosa ruhonosa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruhonosa
    ADD CONSTRAINT ruhonosa_pk PRIMARY KEY (osnimitys);


--
-- TOC entry 3282 (class 2606 OID 28466)
-- Name: seura seura_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seura
    ADD CONSTRAINT seura_pk PRIMARY KEY (seura_id);


--
-- TOC entry 3284 (class 2606 OID 28468)
-- Name: seurue seurue_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue
    ADD CONSTRAINT seurue_pk PRIMARY KEY (seurue_id);


--
-- TOC entry 3286 (class 2606 OID 28470)
-- Name: sukupuoli sukupuoli_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sukupuoli
    ADD CONSTRAINT sukupuoli_pk PRIMARY KEY (sukupuoli);


--
-- TOC entry 3293 (class 2606 OID 28471)
-- Name: kaato aikuinen_vasa_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT aikuinen_vasa_kaato_fk FOREIGN KEY (ikaluokka) REFERENCES public.aikuinenvasa(ikaluokka);


--
-- TOC entry 3298 (class 2606 OID 28476)
-- Name: lupa aikuinen_vasa_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT aikuinen_vasa_lupa_fk FOREIGN KEY (ikaluokka) REFERENCES public.aikuinenvasa(ikaluokka);


--
-- TOC entry 3294 (class 2606 OID 28481)
-- Name: kaato elain_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT elain_kaato_fk FOREIGN KEY (elaimen_nimi) REFERENCES public.elain(elaimen_nimi);


--
-- TOC entry 3299 (class 2606 OID 28486)
-- Name: lupa elain_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT elain_lupa_fk FOREIGN KEY (elaimen_nimi) REFERENCES public.elain(elaimen_nimi);


--
-- TOC entry 3291 (class 2606 OID 28491)
-- Name: jasenyys jasen_jasenyys_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys
    ADD CONSTRAINT jasen_jasenyys_fk FOREIGN KEY (jasen_id) REFERENCES public.jasen(jasen_id);


--
-- TOC entry 3295 (class 2606 OID 28496)
-- Name: kaato jasen_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT jasen_kaato_fk FOREIGN KEY (jasen_id) REFERENCES public.jasen(jasen_id);


--
-- TOC entry 3302 (class 2606 OID 28501)
-- Name: seurue jasen_seurue_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue
    ADD CONSTRAINT jasen_seurue_fk FOREIGN KEY (jasen_id) REFERENCES public.jasen(jasen_id);


--
-- TOC entry 3288 (class 2606 OID 28506)
-- Name: jakotapahtuma kaato_jakotapahtuma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT kaato_jakotapahtuma_fk FOREIGN KEY (kaato_id) REFERENCES public.kaato(kaato_id) NOT VALID;


--
-- TOC entry 3296 (class 2606 OID 28511)
-- Name: kaato kasittely_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT kasittely_kaato_fk FOREIGN KEY (kasittelyid) REFERENCES public.kasittely(kasittelyid);


--
-- TOC entry 3289 (class 2606 OID 28516)
-- Name: jakotapahtuma ruhonosa_jakotapahtuma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT ruhonosa_jakotapahtuma_fk FOREIGN KEY (osnimitys) REFERENCES public.ruhonosa(osnimitys);


--
-- TOC entry 3290 (class 2606 OID 28521)
-- Name: jakotapahtuma ryhma_jakotapahtuma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakotapahtuma
    ADD CONSTRAINT ryhma_jakotapahtuma_fk FOREIGN KEY (ryhma_id) REFERENCES public.jakoryhma(ryhma_id);


--
-- TOC entry 3292 (class 2606 OID 28526)
-- Name: jasenyys ryhma_jasenyys_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jasenyys
    ADD CONSTRAINT ryhma_jasenyys_fk FOREIGN KEY (ryhma_id) REFERENCES public.jakoryhma(ryhma_id);


--
-- TOC entry 3300 (class 2606 OID 28531)
-- Name: lupa seura_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT seura_lupa_fk FOREIGN KEY (seura_id) REFERENCES public.seura(seura_id);


--
-- TOC entry 3303 (class 2606 OID 28536)
-- Name: seurue seura_seurue_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seurue
    ADD CONSTRAINT seura_seurue_fk FOREIGN KEY (seura_id) REFERENCES public.seura(seura_id);


--
-- TOC entry 3287 (class 2606 OID 28541)
-- Name: jakoryhma seurue_ryhma_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jakoryhma
    ADD CONSTRAINT seurue_ryhma_fk FOREIGN KEY (seurue_id) REFERENCES public.seurue(seurue_id);


--
-- TOC entry 3297 (class 2606 OID 28546)
-- Name: kaato sukupuoli_kaato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kaato
    ADD CONSTRAINT sukupuoli_kaato_fk FOREIGN KEY (sukupuoli) REFERENCES public.sukupuoli(sukupuoli);


--
-- TOC entry 3301 (class 2606 OID 28551)
-- Name: lupa sukupuoli_lupa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lupa
    ADD CONSTRAINT sukupuoli_lupa_fk FOREIGN KEY (sukupuoli) REFERENCES public.sukupuoli(sukupuoli);


--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE jako_ka; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.jako_ka TO sovellus;


--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE kaadot_ampujittain; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.kaadot_ampujittain TO sovellus;


--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE kaadot_ryhmittain; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.kaadot_ryhmittain TO sovellus;


--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE kaatoyhteenveto; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.kaatoyhteenveto TO sovellus;


-- Completed on 2022-11-16 09:25:28

--
-- PostgreSQL database dump complete
--

