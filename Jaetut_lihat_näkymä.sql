-- Näkymä, joka listaa kaikki ryhmät ja laskee yhteen niiden saamat lihat
CREATE VIEW jaetut_lihat AS
SELECT ryhman_nimi, SUM(maara) AS yhteensä
FROM public.jakoryhma LEFT OUTER JOIN public.jakotapahtuma ON jakotapahtuma.ryhma_id = jakoryhma.ryhma_id
GROUP BY ryhman_nimi
ORDER BY ryhman_nimi;
