WITH transacciones_por_ciudad_y_categoria AS (
    SELECT 
        c.tipo_documento,
        c.identificacion,
        c.nombre,
        c.clasificacion,
        c.tipo_tarjeta,
        c.estado_tarjeta,
        cc.ciudad,
        cc.nombre_categoria,
        SUM(t.valor_compra) AS total_compras,
        COUNT(*) AS cantidad_transacciones,
        MAX(t.fecha_transaccion) AS ultima_transaccion
    FROM clientes c
    JOIN transacciones t ON c.identificacion = t.identificacion
    JOIN categorias_consumo cc ON t.codigo_categoria = cc.codigo_categoria
    WHERE t.estado='Aprobada' AND
         t.fecha_transaccion >= '2023-01-01' AND t.fecha_transaccion <= '2023-12-31' -- Filtro de ventana temporal
    GROUP BY c.tipo_documento, c.identificacion, c.nombre, c.clasificacion, c.tipo_tarjeta, c.estado_tarjeta, cc.ciudad, cc.nombre_categoria
), 
categorias_preferidas_por_ciudad AS (
    SELECT 
        tipo_documento,
        identificacion,
        nombre,
        clasificacion,
        tipo_tarjeta,
        estado_tarjeta,
        ciudad,
        nombre_categoria,
        total_compras,
        ROW_NUMBER() OVER (PARTITION BY identificacion, ciudad ORDER BY cantidad_transacciones DESC) AS rn
    FROM transacciones_por_ciudad_y_categoria
)
SELECT
    tipo_documento,
    identificacion,
    nombre,
    clasificacion,
    tipo_tarjeta,
    estado_tarjeta,
    ciudad,
    nombre_categoria,
    total_compras,
    nombre_categoria AS categoria_preferida,
    ultima_transaccion AS fecha_ultima_transaccion
FROM categorias_preferidas_por_ciudad
WHERE rn <= 1 --puedo filtrar n categorias;