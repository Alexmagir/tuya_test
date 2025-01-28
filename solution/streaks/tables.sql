CREATE TABLE historia (
    identificacion VARCHAR(255) NOT NULL PRIMARY KEY,
    corte_mes DATE NOT NULL,
    saldo INT64 NOT NULL
);
 
CREATE TABLE retiros (
    identificacion VARCHAR(255) NOT NULL PRIMARY KEY,
    fecha_retiro DATE NOT NULL,
    FOREIGN KEY (identificacion) REFERENCES historia(identificacion)
);