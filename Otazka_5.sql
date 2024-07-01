   WITH rust_mzdy AS (
    SELECT
        rok,
        AVG(prumerna_mzda) AS prumerna_mzda,
        LAG(AVG(prumerna_mzda)) OVER (ORDER BY rok) AS prumerna_mzda_predchozi_rok,
        CASE
            WHEN LAG(AVG(prumerna_mzda)) OVER (ORDER BY rok) <> 0 THEN
                ROUND(((AVG(prumerna_mzda) - LAG(AVG(prumerna_mzda)) OVER (ORDER BY rok)) / LAG(AVG(prumerna_mzda)) OVER (ORDER BY rok)) * 100, 2)
            ELSE
                NULL
        END AS rust_mzdy_percent_zmena
    FROM
        t_Michal_Zemcak_project_SQL_primary_final
    GROUP BY
        rok
),
rust_cen AS (
    SELECT
        rok,
        AVG(prumerna_cena) AS prumerna_cena,
        LAG(AVG(prumerna_cena)) OVER (ORDER BY rok) AS prumerna_cena_predchozi_rok,
        CASE
            WHEN LAG(AVG(prumerna_cena)) OVER (ORDER BY rok) <> 0 THEN
                ROUND(((AVG(prumerna_cena) - LAG(AVG(prumerna_cena)) OVER (ORDER BY rok)) / LAG(AVG(prumerna_cena)) OVER (ORDER BY rok)) * 100, 2)
            ELSE
                NULL
        END AS rust_cen_percent_zmena
    FROM
        t_Michal_Zemcak_project_SQL_primary_final
    GROUP BY
        rok
),
hdp_rust AS (
    SELECT
        rok,
        hdp,
        LAG(hdp) OVER (ORDER BY rok) AS hdp_predchozi_rok,
        CASE
            WHEN LAG(hdp) OVER (ORDER BY rok) <> 0 THEN
                ROUND(((hdp - LAG(hdp) OVER (ORDER BY rok)) / LAG(hdp) OVER (ORDER BY rok)) * 100, 2)
            ELSE
                NULL
        END AS hdp_percent_zmena
    FROM
        t_Michal_Zemcak_project_SQL_secondary_final
    WHERE 
        country = 'Czech Republic'
)
SELECT
    rm.rok,
    rm.prumerna_mzda,
    rm.rust_mzdy_percent_zmena,
    rc.prumerna_cena,
    rc.rust_cen_percent_zmena,
    re.hdp,
    re.hdp_percent_zmena,
    CASE
        WHEN re.hdp_percent_zmena IS NOT NULL AND rm.rust_mzdy_percent_zmena IS NOT NULL AND ABS(re.hdp_percent_zmena) > ABS(rm.rust_mzdy_percent_zmena) THEN 'Ano' -- pokud je změna HDP větší než změna mezd
        WHEN re.hdp_percent_zmena IS NOT NULL AND rc.rust_cen_percent_zmena IS NOT NULL AND ABS(re.hdp_percent_zmena) > ABS(rc.rust_cen_percent_zmena) THEN 'Ano' -- pokud je změna HDP větší než změna cen potravin
        ELSE 'Ne'
    END AS vliv_hdp_na_zmeny
FROM
    rust_mzdy rm
JOIN
    rust_cen rc ON rm.rok = rc.rok
JOIN
    hdp_rust re ON rm.rok = re.rok
ORDER BY
    rm.rok;
