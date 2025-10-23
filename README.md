# 👨‍🍳 ChefBot

Aplicación móvil desarrollada en Flutter cuyo objetivo principal es demostrar la capacidad de integración y uso de modelos de lenguaje grandes (LLM, por ejemplo, Gemini, GPT-4o, etc.) en un entorno móvil, además de destacar el manejo de peticiones HTTP a la web, ofreciendo una experiencia de chat en tiempo real para la generación, busqueda y carga de recetas.

### Propósito del chat_bot
- Un chatbot interactivo que ayuda a los usuarios a descubrir, buscar y explorar recetas de cocina, proporcionando ingredientes, instrucciones y sugerencias personalizadas de forma rápida y sencilla.

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
#### 3. Crear o modificar archivo de entorno (IMPORTANTE) ⚠️
Dado que esta aplicación se desarrolló utilizando la libreria **flutter_dotenv**, se omite dentro del repositorio el archivo **tokens.env** con variables actuales. Para poder ejecutar correctamente la aplicación, deberás modifcar o crear este archivo.
- Dentro del repositorio se incluye el archivo **tokens.env**, modifica el contenido de las variables establecidas con tu llave y URL.

Si prefieres crear tu archivo:
- Elimina el archivo .env existente y crea un nuevo archivo llamado **tokens.env** en la raíz del proyecto, copia y pega lo siguiente, sustituyendo donde se te pide:
```tokens.env
apiKey = 'ESCRIBE_AQUI_TU_KEY_O_TOKEN_A_LA_AI'
requestBinUrl = 'ESCRIBE_AQUI_TU_URL_PARA_RECIBIR'
```
⚠️ Este archivo no se incluye funcionando en el repositorio por razones de seguridad.

#### 4. Ejecutar la App
Una vez resuelto el archivo anterior, conecta un emulador o dispositivo físico y ejecuta en tu terminal:
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
El archivo se generará en:
```Documents
build/app/outputs/flutter-apk/app-release.apk
```
## Enlace al APK
De igual manera, se ha creado un link al APK de la app con las variables correctamente declaradas y funcionando para pruebas dentro del siguiente link: 
- [APK ChefBot](https://drive.google.com/file/d/1Z8wAzBMm-o-htt64gH_6Tw-4Te_Zk6Fb/view?usp=sharing)

## 🔗 Explicacion de las API utilizadas

### 🍽️ TheMealDB API

[TheMealDB API](https://www.themealdb.com/api.php) es una API pública gratuita que proporciona información sobre recetas, ingredientes, categorías y regiones culinarias de todo el mundo. Elegí esta API por estar relacionada al próposito de chef_bot.

#### Características

Tiene como caracteristicas:

- Búsqueda de platillos por nombre, primera letra o ID.
- Filtros por ingrediente, categoría o región (“área”).
- Listado de categorías, áreas e ingredientes disponibles.
- Generación de una receta aleatoria.
- Respuestas en formato JSON con imágenes incluidas.
  
#### 📌 Ejemplos de endpoints

- Buscar platillo llamado “Arrabiata".
```TheMealDB API
search.php?s=Arrabiata”.
```
- Listar platillos que empiezan con “a”
```TheMealDB API
search.php?f=a
```
- Buscar platillo con el id = 52772
```TheMealDB API
lookup.php?i=52772
```
- Obtener un platillo cualquiera al azar
```TheMealDB API
random.php
```
#### 🧩 Uso típico

- Realiza GET requests a los endpoints mencionados.
- Procesa la respuesta JSON para presentar el nombre del platillo, ingredientes, categoría, área, instrucciones, imagen, etc.

### 🧪 RequestBin con Pipedream

RequestBin de Pipedream es una herramienta que te permite crear un endpoint HTTP público donde puedes recibir, inspeccionar y depurar peticiones entrantes de cualquier origen, en la app lo utilicé para que recibiera un objeto JSON de recetas para aquellas que quieres que sean tus favoritas.

#### Caracteristicas

Tiene como caracteristicas:

- Generar una URL única que actúa como “bin” (contenedor) para capturar peticiones HTTP. 
- Visualizar los detalles de cada petición: método HTTP, cabeceras, cuerpo, parámetros, etc. 
- Usar flujos de trabajo (workflows) en Pipedream para procesar, transformar o reenviar las peticiones recibidas.

#### 🧩 Uso típico

- Si estás probando WebHooks, puedes enviar las peticiones a un RequestBin para ver exactamente qué datos envía el servicio antes de integrarlos en tu aplicación real.
- Recibir peticiones HTTP o de APIs para entender cómo se envían las peticiones, cómo se estructuran los JSON, qué métodos HTTP se usan, etc., sin necesidad de un servidor propio.
- Para chef_bot, se implementó para recibir métodos POST.

## 💻 Tech Stack
- Desarrollado en Flutter utilizando Dart.
- Se hizo uso de las librerías **Dio**, **flutter_dotenv** y **shared_preferences**.
- Se utilizó **Material Design** y **Custom Widgets** para mensajes de chat, listas de recetas, botones personalizados.
- Se aplicó internacionalización, indicadores visuales de estado y de errores.
- Control de Versiones con Git y Github.

## 📲 In-app
#### Main Screen
- Al ejecutar, observamos la siguiente interfaz:
- Dentro de ella encontraremos dos botones que nos llevarán a las secciones "Chat with ChefBot" o "Perform HTTP Requests".
<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/1.png" alt="Captura de Pantalla sobre la app en el móvil y su interfaz principal" width="175" height="450">

---
#### Chat Screen
- Al dar click sobre el botón de chat, nos llevará a la siguiente interfaz, nos recibirá chef_bot con un saludo y podemos hablarle de cualquier cosa que queramos relacionada a la cocina.
- No importa si cerramos la aplicación, navegamos hacía otra sección, etc. El chat permanecerá intacto.
- Podemos dar click en el botón superior derecho para eliminar el historial.
<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/2.png" alt="Captura de Pantalla sobre la app en el móvil y su interfaz principal" width="175" height="450">

---
#### HTTP Screen
- Al dar click sobre el botón de Request, se nos mostrará una interfaz con un TextField editable donde podremos buscar alguna receta.
- Para evaluar la consulta de información externa (GET), tenemos una petición a la API, la cual nos devolverá todas las coincidencias de nuestra receta.
- Podemos dar click en cualquiera de los elementos.
<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/3.png" alt="Captura de Pantalla sobre la app en el móvil y su interfaz principal" width="175" height="450">

---

#### Recipe Screen
- Una vez seleccionada nuestra receta, podremos ver una descripción más detallada de ella como un thumbnail, su nombre, país de origen y receta.
- La interfaz nos presenta un Floating Action Button para poder agregar a favoritos.
- Al dar click, se realizará una petición (POST) a una URL host definida. Si la respuesta es correctamente un JSON, nos recibirá con un Snackbar de que la petición se ha completado.
<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/4.png" alt="Captura de Pantalla sobre la app en el móvil y su interfaz principal" width="175" height="450">

<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/5.png" alt="Captura de Pantalla sobre la app en el móvil y su interfaz principal" width="175" height="450">

---
### Recuerda que en cualquier momento puedes hacer uso de la consola de depuración para ver en todo momento Logs sobre lo que está pasando en la app
- Por ejemplo al momento de enviar la petición POST y recibir confirmación veremos algo como esto:

<img src="https://github.com/alexisserapio/chef_bot_resources/blob/main/rsc/6.png" alt="Captura de Pantalla sobre la app en el móvil y su interfaz principal" width="400" height="400">
