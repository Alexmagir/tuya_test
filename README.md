# Prueba Ingeniero de Datos - Tuya
## Alexander Marín

Este repositorio contiene las soluciones para la prueba técnica de Ingeniero de Datos en Tuya. A continuación, se describen las soluciones implementadas para cada uno de los retos planteados.

## 1. Procesamiento de archivos HTML en Python

Este script procesa archivos HTML para reemplazar las imágenes referenciadas en las etiquetas `<img>` por cadenas codificadas en Base64, generando nuevos archivos HTML con las imágenes embebidas.

**Características principales:**

1.  **Entrada flexible**:
    *   Acepta una lista de archivos HTML o un conjunto de directorios para procesar.
    *   Identifica automáticamente los archivos HTML en los directorios, incluidos los subdirectorios.

2.  **Procesamiento**:
    *   Busca etiquetas `<img>` en los archivos HTML y extrae las rutas de las imágenes.
    *   Convierte las imágenes a cadenas Base64.
    *   Reemplaza las rutas originales con las cadenas Base64 en el contenido HTML.

3.  **Salida**:
    *   Crea nuevos archivos HTML (sin sobrescribir los originales) con el sufijo `_updated`.
    *   Genera un reporte con:
        *   `processed_images`: Imágenes procesadas exitosamente.
        *   `failed_images`: Imágenes que no se pudieron procesar, con el error asociado.

**Instrucciones de uso:**

1.  **Preparar el entorno**:
    *   Tener los archivos HTML y las imágenes referenciadas en un directorio o especificar las rutas manualmente en el script `solution/html_python.py`.

2.  **Ejecutar el script**:
    ```bash
    python solution/html_python.py
    ```

**Revisar los resultados:**

*   **Archivos generados**: Los nuevos archivos HTML se crean con las imágenes embebidas en formato Base64, utilizando un sufijo `_updated`.
*   **Reporte en consola**: Durante la ejecución, el script muestra un resumen del procesamiento:

    ```
    Imágenes procesadas: ["path/to/image1.jpg", "path/to/image2.png"]
    Imágenes fallidas: [{"file": "path/to/missing_image.jpg", "error": "No such file or directory"}]
    ```

El código de esta solución se encuentra en la carpeta `solution` en el archivo `html_python.py`.

## 2. Preferencias de consumo

Esta solución calcula las preferencias de consumo de los clientes basándose en sus transacciones.

**Instrucciones de uso:**

Para ejecutar esta solución, se debe tener una base de datos disponible en **SQLite** o **MySQL**. Sigue estos pasos en orden desde la carpeta `consumer_preferences`:

1.  **Crear tablas**: ejecutar las queries `tables.slq` para crear las tablas necesarias en la base de datos.

2.  **Cargar datos**: ejecutar las queries `table_loading.sql` para cargar los datos desde los archivos Excel ubicados en la carpeta `excel data`.

3.  **Calcular preferencias**: ejecutar las queries `final data.sql` para calcular las preferencias de consumo 

De esta manera se garantiza que las tablas necesarias sean creadas, los datos cargados desde los archivos locales disponibles en la carpeta `excel_data` y las preferencias calculadas correctamente.

Además el calculo de preferencias se basa en una sola consulta con subqueries que permiten mantener y encontrar los niveles de preferencia dinámicos, como las fechas de consulta ***revisar WHERE***.

## 3. Rachas

Esta solución identifica y clasifica las rachas de consumo de los clientes.

**Instrucciones de uso:**

Para ejecutar esta solución, se debe tener una base de datos disponible en **SQLite** o **MySQL**. Sigue estos pasos en orden desde la carpeta `streaks`:

1.  **Crear tablas**: ejecutar las queries `tables.sql` para crear las tablas necesarias en la base de datos.

2.  **Cargar datos**: ejecutar las queries `table_loading.sql` para cargar los datos desde los archivos Excel ubicados en la carpeta `excel data`.

3.  **Clasificar**: ejecutar las queries `classification.sql` para clasificar a los clientes segun los niveles de deuda.

4.  **Identificar rachas**: ejecutar las queries `streaks.sql` para identificar las rachas de un cliente dentro de un nivel de deuda. Permite modificar fecha base y número de rachas.

Al ejecutar las queries de clasificación y de rachas en diferentes espacios se garantiza un flujo en la transformación, si no se hace con vistas, deberían ejecutarse en el mismo espacio y no habrá ningún conflicto entre las subqueries.
