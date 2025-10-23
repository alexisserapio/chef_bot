# 👨‍🍳 ChefBot

Aplicación móvil desarrollada en Flutter cuyo objetivo principal es demostrar la capacidad de integración y uso de modelos de lenguaje grandes (LLM, por ejemplo, Gemini, GPT-4o, etc.) en un entorno móvil, además de destacar el manejo de peticiones HTTP a la web, ofreciendo una experiencia de chat en tiempo real para la generación, busqueda y carga de recetas.

## Getting Started

### 🚀 Instrucciones para correr la app localmente

#### 1. Clona el repositorio y accede a la carpeta del proyecto
```bash
git clone https://github.com/alexisserapio/chef_bot.git
cd chef_bot
```

#### 2. Instalar dependencias
- Asegúrate de tener instalado Flutter y que esté en tu PATH.
- Posteriormente , instala las dependencias del proyecto:

Ejecuta en tu terminal:
```bash
flutter pub get
```
#### 3. Crear archivo de entorno (IMPORTANTE)
Dado que esta aplicación se desarrolló utilizando la libreria **flutter_dotenv**, se omite dentro del repositorio el archivo **tokens.env**. Para poder ejecutar correctamente la aplicación, deberás crear este archivo.
- Crea un archivo llamado **tokens.env** en la raíz del proyecto con las siguientes variables necesarias, sustituyendo donde se te pide:
```tokens.env
apiKey = 'ESCRIBE_AQUI_TU_KEY_O_TOKEN_A_LA_AI'
requestBinUrl = 'ESCRIBE_AQUI_TU_URL_PARA_RECIBIR'
```
⚠️ Este archivo no se incluye en el repositorio por razones de seguridad.

#### 4. Ejecutar la App
Una vez creado el archivo anterior y sustituido correctamente el contenido de las variables, conecta un emulador o dispositivo físico y ejecuta en tu terminal:
```bash
flutter run
```
Listo! Deberias poder observar algo como esto:

<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/1.png" width="175" height="450">

#### 5. Generar APK para pruebas (Opcional)
Si lo deseas, teniendo ya el .env en tu proyecto, puedes generar el APK ejecutando en terminal el siguiente comando:
```bash
flutter build apk --release
```
El archivo se generara en:
```Documents
build/app/outputs/flutter-apk/app-release.apk
```
De igual manera, he creado un link al APK de la app con las variables correctamente declaradas y funcionando para pruebas dentro del siguiente link: [APK ChefBot](https://drive.google.com/file/d/1Z8wAzBMm-o-htt64gH_6Tw-4Te_Zk6Fb/view?usp=sharing)

### Explicacion de las API utilizadas

#### 🍽️ TheMealDB API

TheMealDB es una API pública gratuita que proporciona información sobre recetas, ingredientes, categorías y regiones culinarias de todo el mundo. Ideal para proyectos de aprendizaje o apps de cocina.

##### Características

- Búsqueda de platillos por nombre, primera letra o ID.
- Filtros por ingrediente, categoría o región (“área”).
- Listado de categorías, áreas e ingredientes disponibles.
- Generación de una receta aleatoria.
- Respuestas en formato JSON con imágenes incluidas.

#### 🧪 RequestBin con Pipedream

RequestBin de Pipedream es una herramienta que te permite crear un endpoint HTTP público donde puedes recibir, inspeccionar y depurar peticiones entrantes de cualquier origen. 


##### Caracteristicas

- Generas una URL única que actúa como “bin” (contenedor) para capturar peticiones HTTP. 
- Visualizas los detalles de cada petición: método HTTP, cabeceras, cuerpo, parámetros, etc. 
- Puedes incluso usar flujos de trabajo (workflows) en Pipedream para procesar, transformar o reenviar las peticiones recibidas. 
LittleCodingKata
