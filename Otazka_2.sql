SELECT 
	rok,
	round(avg(prumerna_mzda)) AS prumerna_mzda,
	zbozi,
	prumerna_cena,
	round((avg(prumerna_mzda)) / prumerna_cena,2) as mnozstvi
FROM t_Michal_Zemcak_project_SQL_primary_final
WHERE (zbozi LIKE '%Mléko%' OR zbozi LIKE '%Chléb%') AND (rok = (
	SELECT min(rok) FROM t_Michal_Zemcak_project_SQL_primary_final) OR rok = (
	SELECT max(rok) FROM t_Michal_Zemcak_project_SQL_primary_final))
GROUP BY rok, zbozi 
ORDER BY mnozstvi DESC;
