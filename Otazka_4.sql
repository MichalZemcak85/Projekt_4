WITH rust_mzdy AS (
    SELECT
        rok,
        AVG(prumerna_mzda) AS prumerna_mzda
    FROM
        t_Michal_Zemcak_project_SQL_primary_final
    GROUP BY
        rok
),
rust_cen AS (
    SELECT
        rok,
        AVG(prumerna_cena) AS prumerna_cena
    FROM
        t_Michal_Zemcak_project_SQL_primary_final
    GROUP BY
        rok
)
SELECT
    rm.rok,
    rm.prumerna_mzda,
    LAG(rm.prumerna_mzda) OVER (ORDER BY rm.rok) AS prumerna_mzda_predchozi_rok,
    rc.prumerna_cena,
    LAG(rc.prumerna_cena) OVER (ORDER BY rc.rok) AS prumerna_cena_predchozi_rok,
    ROUND((rc.prumerna_cena - LAG(rc.prumerna_cena) OVER (ORDER BY rc.rok)) / LAG(rc.prumerna_cena) OVER (ORDER BY rc.rok) * 100, 2) AS zmena_cen_procent,
    ROUND((rm.prumerna_mzda - LAG(rm.prumerna_mzda) OVER (ORDER BY rm.rok)) / LAG(rm.prumerna_mzda) OVER (ORDER BY rm.rok) * 100, 2) AS zmena_mezd_procent,
    CASE
        WHEN ABS((rc.prumerna_cena - LAG(rc.prumerna_cena) OVER (ORDER BY rc.rok)) / LAG(rc.prumerna_cena) OVER (ORDER BY rc.rok) * 100) > ABS((rm.prumerna_mzda - LAG(rm.prumerna_mzda) OVER (ORDER BY rm.rok)) / LAG(rm.prumerna_mzda) OVER (ORDER BY rm.rok) * 100) + 10 THEN 'Ano'
        ELSE 'Ne'
    END AS vyssi_narust_cen_potravin
FROM
    rust_mzdy rm
JOIN
    rust_cen rc ON rm.rok = rc.rok
ORDER BY
    rm.rok;
