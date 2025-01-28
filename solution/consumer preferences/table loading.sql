COPY clientes FROM 'excel data\~$bd.xlsx - CLIENTES.csv' DELIMITER ',' CSV HEADER;

COPY transacciones FROM 'excel data\~$bd.xlsx - TRANSACCIONES.csv' DELIMITER ',' CSV HEADER;

COPY categorias_consumo FROM 'excel data\~$bd.xlsx - CATEGORIAS_CONSUMO.csv' DELIMITER ',' CSV HEADER;

UPDATE transacciones SET fecha_transaccion = NULL WHERE fecha_transaccion = '0';

ALTER TABLE transacciones ALTER COLUMN fecha_transaccion TYPE DATE USING fecha_transaccion::date;