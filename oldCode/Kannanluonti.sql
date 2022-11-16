
CREATE TABLE public.ruhonosa (
                osnimitys VARCHAR(20) NOT NULL,
                CONSTRAINT ruhonosa_pk PRIMARY KEY (osnimitys)
);


CREATE TABLE public.AikuinenVasa (
                ikaluokka VARCHAR(10) NOT NULL,
                CONSTRAINT aikuinenvasa_pk PRIMARY KEY (ikaluokka)
);


CREATE TABLE public.sukupuoli (
                sukupuoli VARCHAR(10) NOT NULL,
                CONSTRAINT sukupuoli_pk PRIMARY KEY (sukupuoli)
);


CREATE TABLE public.elain (
                elaimen_nimi VARCHAR(20) NOT NULL,
                CONSTRAINT elain_pk PRIMARY KEY (elaimen_nimi)
);


CREATE SEQUENCE public.kasittely_kasittelyid_seq_1;

CREATE TABLE public.kasittely (
                kasittelyID INTEGER NOT NULL DEFAULT nextval('public.kasittely_kasittelyid_seq_1'),
                kasittely_teksti VARCHAR(50) NOT NULL,
                CONSTRAINT kasittely_pk PRIMARY KEY (kasittelyID)
);


ALTER SEQUENCE public.kasittely_kasittelyid_seq_1 OWNED BY public.kasittely.kasittelyID;

CREATE SEQUENCE public.jasen_jasen_id_seq_1;

CREATE TABLE public.jasen (
                jasen_id INTEGER NOT NULL DEFAULT nextval('public.jasen_jasen_id_seq_1'),
                etunimi VARCHAR(50) NOT NULL,
                sukunimi VARCHAR(50) NOT NULL,
                jakeluosoite VARCHAR(30) NOT NULL,
                postinumero VARCHAR(10) NOT NULL,
                postitoimipaikka VARCHAR(30) NOT NULL,
                CONSTRAINT jasen_pk PRIMARY KEY (jasen_id)
);
COMMENT ON TABLE public.jasen IS 'Henkilö joka osallistuu metsästykseen tai lihanjakoon';


ALTER SEQUENCE public.jasen_jasen_id_seq_1 OWNED BY public.jasen.jasen_id;

CREATE SEQUENCE public.kaato_kaato_id_seq;

CREATE TABLE public.kaato (
                kaato_id INTEGER NOT NULL DEFAULT nextval('public.kaato_kaato_id_seq'),
                jasen_id INTEGER NOT NULL,
                kaatopaiva DATE NOT NULL,
                ruhopaino REAL NOT NULL,
                paikka_teksti VARCHAR(100) NOT NULL,
                paikka_koordinaatti VARCHAR(100) NOT NULL,
                kasittelyID INTEGER NOT NULL,
                elaimen_nimi VARCHAR(20) NOT NULL,
                sukupuoli VARCHAR(10) NOT NULL,
                ikaluokka VARCHAR(10) NOT NULL,
                CONSTRAINT kaato_pk PRIMARY KEY (kaato_id)
);
COMMENT ON TABLE public.kaato IS 'Ampumatapahtuman tiedot';
COMMENT ON COLUMN public.kaato.ruhopaino IS 'paino kiloina';
COMMENT ON COLUMN public.kaato.paikka_koordinaatti IS 'Tämän kentän tietotyyppi pitää oikeasti olla geometry (Postgis-tietotyyppi)';


ALTER SEQUENCE public.kaato_kaato_id_seq OWNED BY public.kaato.kaato_id;

CREATE SEQUENCE public.seura_seura_id_seq;

CREATE TABLE public.seura (
                seura_id INTEGER NOT NULL DEFAULT nextval('public.seura_seura_id_seq'),
                seuran_nimi VARCHAR(50) NOT NULL,
                jakeluosoite VARCHAR(30) NOT NULL,
                postinumero VARCHAR(10) NOT NULL,
                postitoimipaikka VARCHAR(30) NOT NULL,
                CONSTRAINT seura_pk PRIMARY KEY (seura_id)
);
COMMENT ON TABLE public.seura IS 'Metsästysseuran tiedot';


ALTER SEQUENCE public.seura_seura_id_seq OWNED BY public.seura.seura_id;

CREATE SEQUENCE public.lupa_luparivi_id_seq;

CREATE TABLE public.lupa (
                luparivi_id INTEGER NOT NULL DEFAULT nextval('public.lupa_luparivi_id_seq'),
                seura_id INTEGER NOT NULL,
                lupavuosi VARCHAR(4) NOT NULL,
                elaimen_nimi VARCHAR(20) NOT NULL,
                sukupuoli VARCHAR(10) NOT NULL,
                ikaluokka VARCHAR(10) NOT NULL,
                maara INTEGER NOT NULL,
                CONSTRAINT lupa_pk PRIMARY KEY (luparivi_id)
);
COMMENT ON TABLE public.lupa IS 'Vuosittaiset kaatoluvat';


ALTER SEQUENCE public.lupa_luparivi_id_seq OWNED BY public.lupa.luparivi_id;

CREATE SEQUENCE public.seurue_seurue_id_seq;

CREATE TABLE public.seurue (
                seurue_id INTEGER NOT NULL DEFAULT nextval('public.seurue_seurue_id_seq'),
                seura_id INTEGER NOT NULL,
                seurueen_nimi VARCHAR(50) NOT NULL,
                jasen_id INTEGER NOT NULL,
                CONSTRAINT seurue_pk PRIMARY KEY (seurue_id)
);
COMMENT ON TABLE public.seurue IS 'Metsästystä harjoittavan seurueen tiedot
';
COMMENT ON COLUMN public.seurue.jasen_id IS 'Seurueen johtajan tunniste';


ALTER SEQUENCE public.seurue_seurue_id_seq OWNED BY public.seurue.seurue_id;

CREATE TABLE public.jakoryhma (
                ryhma_id INTEGER NOT NULL,
                seurue_id INTEGER NOT NULL,
                ryhman_nimi VARCHAR(50) NOT NULL,
                CONSTRAINT jakoryhma_pk PRIMARY KEY (ryhma_id)
);
COMMENT ON TABLE public.jakoryhma IS 'Ryhmä, jolle lihaa jaetaan';


CREATE SEQUENCE public.jakotapahtuma_tapahtuma_id_seq;

CREATE TABLE public.Jakotapahtuma (
                tapahtuma_id INTEGER NOT NULL DEFAULT nextval('public.jakotapahtuma_tapahtuma_id_seq'),
                paiva DATE NOT NULL,
                ryhma_id INTEGER NOT NULL,
                osnimitys VARCHAR(20) NOT NULL,
                maara REAL NOT NULL,
                CONSTRAINT jakotapahtuma_pk PRIMARY KEY (tapahtuma_id)
);
COMMENT ON COLUMN public.Jakotapahtuma.maara IS 'Jaettu lihamäärä kiloina';


ALTER SEQUENCE public.jakotapahtuma_tapahtuma_id_seq OWNED BY public.Jakotapahtuma.tapahtuma_id;

CREATE SEQUENCE public.jasenyys_jasenyys_id_seq;

CREATE TABLE public.jasenyys (
                jasenyys_id INTEGER NOT NULL DEFAULT nextval('public.jasenyys_jasenyys_id_seq'),
                ryhma_id INTEGER NOT NULL,
                jasen_id INTEGER NOT NULL,
                liittyi DATE NOT NULL,
                Poistui DATE,
                CONSTRAINT jasenyys_pk PRIMARY KEY (jasenyys_id)
);


ALTER SEQUENCE public.jasenyys_jasenyys_id_seq OWNED BY public.jasenyys.jasenyys_id;

ALTER TABLE public.Jakotapahtuma ADD CONSTRAINT ruhonosa_jakotapahtuma_fk
FOREIGN KEY (osnimitys)
REFERENCES public.ruhonosa (osnimitys)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.lupa ADD CONSTRAINT aikuinen_vasa_lupa_fk
FOREIGN KEY (ikaluokka)
REFERENCES public.AikuinenVasa (ikaluokka)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.kaato ADD CONSTRAINT aikuinen_vasa_kaato_fk
FOREIGN KEY (ikaluokka)
REFERENCES public.AikuinenVasa (ikaluokka)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.lupa ADD CONSTRAINT sukupuoli_lupa_fk
FOREIGN KEY (sukupuoli)
REFERENCES public.sukupuoli (sukupuoli)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.kaato ADD CONSTRAINT sukupuoli_kaato_fk
FOREIGN KEY (sukupuoli)
REFERENCES public.sukupuoli (sukupuoli)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.lupa ADD CONSTRAINT elain_lupa_fk
FOREIGN KEY (elaimen_nimi)
REFERENCES public.elain (elaimen_nimi)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.kaato ADD CONSTRAINT elain_kaato_fk
FOREIGN KEY (elaimen_nimi)
REFERENCES public.elain (elaimen_nimi)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.kaato ADD CONSTRAINT kasittely_kaato_fk
FOREIGN KEY (kasittelyID)
REFERENCES public.kasittely (kasittelyID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.jasenyys ADD CONSTRAINT jasen_jasenyys_fk
FOREIGN KEY (jasen_id)
REFERENCES public.jasen (jasen_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.kaato ADD CONSTRAINT jasen_kaato_fk
FOREIGN KEY (jasen_id)
REFERENCES public.jasen (jasen_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.seurue ADD CONSTRAINT jasen_seurue_fk
FOREIGN KEY (jasen_id)
REFERENCES public.jasen (jasen_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.seurue ADD CONSTRAINT seura_seurue_fk
FOREIGN KEY (seura_id)
REFERENCES public.seura (seura_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.lupa ADD CONSTRAINT seura_lupa_fk
FOREIGN KEY (seura_id)
REFERENCES public.seura (seura_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.jakoryhma ADD CONSTRAINT seurue_ryhma_fk
FOREIGN KEY (seurue_id)
REFERENCES public.seurue (seurue_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.jasenyys ADD CONSTRAINT ryhma_jasenyys_fk
FOREIGN KEY (ryhma_id)
REFERENCES public.jakoryhma (ryhma_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Jakotapahtuma ADD CONSTRAINT ryhma_jakotapahtuma_fk
FOREIGN KEY (ryhma_id)
REFERENCES public.jakoryhma (ryhma_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
