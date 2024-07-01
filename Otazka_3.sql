WITH zmena_ceny AS(
	SELECT
		rok,
		zbozi,
		prumerna_cena,
		LAG(prumerna_cena) OVER(PARTITION BY zbozi ORDER BY rok) AS prev_avg_price_of_food_in_czk,
		(prumerna_cena - LAG(prumerna_cena) OVER(PARTITION BY zbozi ORDER BY rok)) / LAG(prumerna_cena) OVER(PARTITION BY zbozi ORDER BY rok) * 100 AS zmena_ceny_v_procentech		
	FROM t_Michal_Zemcak_project_SQL_primary_final
	WHERE 
		rok BETWEEN '2006' AND '2018'
)
SELECT 
	zbozi,
	ROUND(AVG(zmena_ceny_v_procentech), 2) AS prumerna_zmena_v_procentech
FROM zmena_ceny
GROUP BY 
	zbozi
ORDER BY
	prumerna_zmena_v_procentech;
