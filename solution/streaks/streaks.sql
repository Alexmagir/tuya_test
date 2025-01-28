WITH deuda AS (
SELECT 
    cd.identificacion,
    cd.corte_mes,
    cd.saldo,
    CASE 
        WHEN cd.corte_mes > cd.fecha_retiro THEN 'N0'
        ELSE cd.clasificacion_deuda
    END AS clasificacion_deuda_final
FROM 
    ClasificacionDeuda cd
WHERE cd.corte_mes <= '2025-01-27' -- Puede ser cualquier fecha
    ),
Rachas AS (
    SELECT 
        d.identificacion,
        d.corte_mes,
        d.saldo,
        d.nivel_deuda_final,
        ROW_NUMBER() OVER (PARTITION BY d.identificacion ORDER BY d.corte_mes) -
        ROW_NUMBER() OVER (PARTITION BY d.identificacion, d.nivel_deuda_final ORDER BY d.corte_mes) AS grupo_racha,
        ROW_NUMBER() OVER (PARTITION BY d.identificacion, d.nivel_deuda_final, grupo_racha ORDER BY d.corte_mes DESC) AS rn
    FROM 
        deuda d
),
RachasConLongitud AS (
  SELECT 
        r.identificacion,
        r.nivel_deuda_final AS nivel,
        COUNT(*) OVER (PARTITION BY r.identificacion, r.grupo_racha) AS racha,
        FIRST_VALUE(r.corte_mes) OVER (PARTITION BY r.identificacion, r.grupo_racha ORDER BY r.corte_mes DESC) AS fecha_fin
    FROM 
        Rachas r
)
SELECT 
    rcl.identificacion,
    rcl.racha,
    rcl.fecha_fin,
    rcl.nivel
FROM 
    RachasConLongitud rcl
WHERE rcl.racha >= 3 -- puede ser n racha
QUALIFY ROW_NUMBER() OVER (PARTITION BY rcl.identificacion ORDER BY rcl.racha DESC, rcl.fecha_fin DESC) = 1;