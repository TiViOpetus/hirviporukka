-- Kysely, jolla selvitetään paljonko kaadetusta eläimestä on jäänyt jakamatta
SELECT kaato.kaato_id, 
	ruhopaino - sum (maara) As jakamatta
FROM public.kaato INNER JOIN public.jakotapahtuma ON jakotapahtuma.kaato_id = kaato.kaato_id
GROUP BY kaato.kaato_id