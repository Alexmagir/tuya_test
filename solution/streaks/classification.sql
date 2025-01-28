WITH ClasificacionDeuda AS (
    SELECT 
        h.identificacion,
        h.corte_mes,
        h.saldo,
        CASE 
            WHEN h.saldo >= 0 AND h.saldo < 300000 THEN 'N0'
            WHEN h.saldo >= 300000 AND h.saldo < 1000000 THEN 'N1'
            WHEN h.saldo >= 1000000 AND h.saldo < 3000000 THEN 'N2'
            WHEN h.saldo >= 3000000 AND h.saldo < 5000000 THEN 'N3'
            WHEN h.saldo >= 5000000 THEN 'N4'
            ELSE 'N0'
        END AS clasificacion_deuda,
        COALESCE(r.fecha_retiro, '9999-12-31') AS fecha_retiro
    FROM 
        historia h
    LEFT JOIN 
        retiros r ON h.identificacion = r.identificacion
)
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
ORDER BY 
    cd.identificacion, cd.corte_mes;