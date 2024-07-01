SELECT 
    rok, 
    odvetvi,
    AVG(prumerna_mzda),
    CASE  -- K získání průměrné mzdy z předchozího roku pro každé odvětví, pokud je průměrná mzda v předchozím roce vyšší než v aktuálním roce, označí se, že "Klesa".
	    -- pokud je průměrná mzda v předchozím roce nižší než v aktuálním roce, označíme ji, že teď "Roste"
        WHEN LAG(AVG(prumerna_mzda)) OVER (PARTITION BY odvetvi ORDER BY rok) > AVG(prumerna_mzda) THEN 'Klesa'
        WHEN LAG(AVG(prumerna_mzda)) OVER (PARTITION BY odvetvi ORDER BY rok) < AVG(prumerna_mzda) THEN 'Roste'
        WHEN rok = 2000 THEN 'Vychozí rok'
        ELSE 'Bez změny'
    END AS trend
FROM 
    t_Michal_Zemcak_project_SQL_primary_final
GROUP BY 
    rok, odvetvi -- Seskupuje podle roku a odvětví
ORDER BY 
    odvetvi, rok ; -- Seřazuje podle roku a odvětví
