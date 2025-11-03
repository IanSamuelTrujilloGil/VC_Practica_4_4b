# Práctica 4
## Requisitos de ejecución
Para ejecutar el cuaderno correctamente, necesitas tener lo siguiente:
- Python  
- GPU con soporte CUDA (opcional, pero recomendable para acelerar los modelos).  
- Librerías de Python:
  - `ultralytics` (YOLO)  
  - `torch`  
  - `opencv-python`  
  - `pytesseract`  
  - `transformers`  
  - `Pillow`  
  - `numpy`  
  - `glob`, `os`, `json`, `csv`, `re` (estándar de Python)  
- Tesseract OCR instalado en el sistema y configurado en el código si es necesario.
- Acceso a los modelos:
  - YOLOv11n (detector y tracker de personas y vehículos)  
  - Modelo entrenado para detectar matrículas  
  - OCR Pytesseract y SmolVLM  
Con esto, ya tienes todo lo que hace falta para ejecutar el cuaderno.

## Lista y descripción de tareas realizadas 

### Objetivo
El objetivo es preparar un prototipo que procese vídeos y detecte personas, coches y matrículas con su correspondiente texto, volcando el resultado en un vídeo y anotaciones en un fichero csv.

### Elaboración de un dataset de matrículas
Para empezar, se ha creado un dataset de matrículas de coches. Para ello, entre distintos estudiantes de la asignatura se creó una carpeta compartida en la cual fuimos subiendo las imágenes.

Posteriormente, descargamos todas las imágenes y las renombramos usando un script de PowerShell que usa un hash para nombrar la imagen, para que cada una tuviese un nombre único. Tras esto, procedimos mediante un script de PowerShell a separar nuestro dataset en tres conjuntos: train con un 80% de las imágenes y validation y test con un 10% cada una.

Tras esto, se procedió a realizar el etiquetado de todas las imágenes con el programa Labelme, que generaba un archivo JSON con el mismo nombre que la imagen con las anotaciones.

Finalmente, para pasar las anotaciones del formato Labelme a YOLO, usamos otro script de Python.

### Entrenamiendo de un modelo capaz de detectar matrículas en imagenes
Posteriormente, se hicieron diversos entrenamientos hasta que conseguimos el detector de matrículas que se usa en la práctica. El código de entrenamiento que se muestra en el cuaderno muestra la configuración con la que conseguimos el modelo que estamos utilizando.

### Implementación del prototipo
El prototipo a implementar debe cumplir las siguientes especificaciones:

- Detecte y siga a las personas y vehículos presentes.
- Detecte las matrículas de los vehículos presentes.
- Cuente el total de cada clase.
- Vuelque a disco un vídeo que visualice los resultados.
- Genere un archivo CSV con el resultado de la detección y seguimiento. Se sugiere un formato con al menos los siguientes campos:
```csv
fotograma, tipo_objeto, confianza, identificador_tracking, x1, y1, x2, y2, matrícula_en_su_caso, confianza, mx1, my1, mx2, my2, texto_matricula
```
Para ello, y utilizando el modelo YOLO11n, que incluye detector y tracker de personas y coches, iteramos en todos los frames del vídeo y se lo pasamos al modelo de YOLO usando el método _track() con el tracker ByteTrack, que se encargará de seguir a los objetos detectados y asignarles un identificador. Posteriormente, si se encuentran regiones que se correspondan con coches en las predicciones del modelo, se itera entre ellas y se le aplica el modelo que ha sido entrenado por nosotros para detectar la matrícula. A las matrículas, además, se las pasa por dos OCR: Pytesseract y SmolVLM. Debido a los recursos que consume SmolVLM, se ha optado por separar la ejecución, y por tanto tenemos dos celdas en el cuaderno que tratan el vídeo y generan un fichero CSV. Con los datos que se obtienen del modelo YOLO, el entrenado por nosotros y los OCR, se generan los diferentes campos del fichero de salida y se escriben para cada objeto en cada frame.

Finalmente, para realizar la cuenta, lo que se hace es leer los ficheros CSV generados y se discrimina primero entre si son personas o vehículos, y se añaden sus identificadores al conjunto correspondiente. Como estos no admiten duplicados, el tamaño del conjunto será equivalente a la cuenta. 

# Conclusiones
Hay que tener en cuenta que el tracker no es perfecto, y que puede asignarle un identificador nuevo a un objeto que ya había aparecido en el vídeo, por ejemplo, cuando otro lo cubre, como pasa en el vídeo de ejemplo cuando pasa un coche en circulación por delante de los coches estacionados.
Nuestro modelo, detecta mejor las matrículas cuanto más cerca están de la cámara. Probablemente debido a que es más fácil obtener imagenes de coches estacionados > 
en circulación. 

[En la siguiente carpeta compartida se puede ver el prototipo en funcionamiento sobre el vídeo de prueba proporcionado. Están todas las
versiones, tanto el que se genera con pytesseract como con SmolVLM] (https://alumnosulpgc-my.sharepoint.com/personal/ian_trujillo102_alu_ulpgc_es/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Fian%5Ftrujillo102%5Falu%5Fulpgc%5Fes%2FDocuments%2FVC%5FP4%5FP4B&ga=1)

Los siguientes ficheros _.csv_ contienen las anotaciones pertinentes para la entrega de la práctica
- Usando como OCR Pytesseract:
- Usando como OCR SmolVLM: