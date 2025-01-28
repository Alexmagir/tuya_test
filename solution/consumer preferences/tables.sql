CREATE TABLE clientes (
    nombre VARCHAR(255) NOT NULL,
    identificacion VARCHAR(255) NOT NULL PRIMARY KEY,
    tipo_documento VARCHAR(255) NOT NULL,
    clasificacion VARCHAR(255) NOT NULL,
    tipo_tarjeta VARCHAR(255) NOT NULL,
    fecha_apertura_tarjeta DATE NOT NULL,
    estado_tarjeta VARCHAR(255) NOT NULL
);
 
CREATE TABLE transacciones (
    identificacion VARCHAR(255) NOT NULL,
    id_transaccion INT NOT NULL PRIMARY KEY,
    fecha_transaccion VARCHAR(255) NOT NULL,
    codigo_categoria INT NOT NULL,
    estado VARCHAR(255) NOT NULL,
    valor_compra DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (identificacion) REFERENCES clientes(identificacion)
);

CREATE TABLE categorias_consumo (
    codigo_categoria INT NOT NULL PRIMARY KEY,
    nombre_categoria VARCHAR(255) NOT NULL,
    ciudad VARCHAR(255) NOT NULL,
    departamento VARCHAR(255) NOT NULL
);