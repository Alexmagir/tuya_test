import os
import base64
import re

class HTMLImageProcessor:

    def __init__(self, file_paths=None, directories=None, overwrite=False):
        """
        Inicializa el procesador con rutas de archivo y directorios opcionales.

        Args:
            file_paths (list): Lista de rutas de archivo HTML para procesar.
            directories (list): Lista de directorios para buscar archivos HTML.
            overwrite (bool): Si es True, sobrescribe los archivos originales. 
                              Si es False, crea nuevos archivos con sufijo "_updated".
        """
        self.file_paths = file_paths or []
        self.directories = directories or []
        self.overwrite = overwrite
        self.processed_images = []
        self.failed_images = []

    def gather_html_files(self):
        """
        Recopila todos los archivos HTML de las rutas de archivo y directorios proporcionados.

        Returns:
            set: Un conjunto de rutas de archivo HTML únicas.
        """
        html_files = set(self.file_paths)
        for directory in self.directories:
            for root, _, files in os.walk(directory):
                for file in files:
                    if file.lower().endswith(".html"):
                        html_files.add(os.path.join(root, file))
        return html_files

    def convert_image_to_base64(self, image_path):
        """
        Convierte un archivo de imagen a una cadena base64.

        Args:
            image_path (str): Ruta al archivo de imagen.

        Returns:
            str: Representación de cadena Base64 de la imagen.
        """
        try:
            with open(image_path, 'rb') as image_file:
                encoded_image = base64.b64encode(image_file.read()).decode('utf-8')
                extension = image_path.split('.')[-1]
                return f"data:image/{extension};base64,{encoded_image}"
        except Exception as e:
            self.failed_images.append({"file": image_path, "error": str(e)})
            return None

    def process_html_file(self, html_file):
        """
        Procesa un solo archivo HTML, convirtiendo sus imágenes a base64.

        Args:
            html_file (str): Ruta al archivo HTML para procesar.
        """
        try:
            with open(html_file, 'r', encoding='utf-8') as file:
                content = file.read()

            updated_content = self.replace_images_with_base64(content, os.path.dirname(html_file))

            if self.overwrite:
                new_file_path = html_file
            else:
                new_file_path = f"{os.path.splitext(html_file)[0]}_updated.html"
            
            with open(new_file_path, 'w', encoding='utf-8') as new_file:
                new_file.write(updated_content)

        except Exception as e:
            print(f"Error al procesar el archivo HTML {html_file}: {e}")

    def replace_images_with_base64(self, content, base_path):
        """
        Reemplaza las etiquetas de imagen en el contenido HTML con imágenes codificadas en base64.

        Args:
            content (str): El contenido HTML.
            base_path (str): La ruta base para resolver rutas de imagen relativas.

        Returns:
            str: Contenido HTML actualizado.
        """

        # Imagenes asociadas a la etiqueta <img>
        pattern = r'<img\s+[^>]*src="([^"]+)"[^>]*>'
        matches = re.findall(pattern, content)

        for src in matches:
            if not os.path.isabs(src):
                src = os.path.join(base_path, src)

            base64_data = self.convert_image_to_base64(src)
            if base64_data:
                content = content.replace(src, base64_data)
                self.processed_images.append(src)

        return content


    def process(self):
        """
        Procesa todos los archivos HTML, reemplazando las etiquetas de imagen 
        con imágenes codificadas en base64.

        Returns:
            dict: Contiene detalles de las imágenes procesadas y fallidas.
        """
        html_files = self.gather_html_files()

        for html_file in html_files:
            self.process_html_file(html_file)

        return {
            "processed_images": self.processed_images,
            "failed_images": self.failed_images
        }

# Ejemplo de uso
if __name__ == "__main__":
    file_list = ["example1.html", "example2.html"]
    directory_list = ["./html_files"]

    processor = HTMLImageProcessor(
        file_paths=file_list, 
        directories=directory_list, 
        overwrite=False
    )
    result = processor.process()
    print("Imágenes procesadas:", result["processed_images"])
    print("Imágenes fallidas:", result["failed_images"])