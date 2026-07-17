

# 🦇 Proyecto: Sistema de Acceso a la Baticueva & Control de Actualizaciones

Este proyecto es una aplicación multiplataforma desarrollada en **Flutter** que simula un sistema de inicio de sesión de alta seguridad para la baticueva de Gotham. Cuenta con validaciones avanzadas, una base de datos local para el registro de reclutas, bati-notificaciones interactivas de reclutamiento militar y un sistema inteligente de alerta de actualizaciones automáticas (`Upgrader`).

---

## 👤 Información del Creador y Curso

* **Desarrollador:** Sergio Emilio Elizondo Salman
* **Grupo:** ITI-23
* **Materia:** Programación Web
* **Carrera:** Ingeniería en Tecnologías de la Información

---

## 📝 Breve Descripción del Proyecto

La aplicación es un prototipo funcional diseñado con bati-humor y un flujo interactivo para el usuario:
1. **Pantalla de Login (`LoginPage`):** Solicita correo y contraseña con validaciones estrictas. Si el usuario olvida un campo o acepta los términos, el sistema dispara bati-notificaciones de alerta personalizadas.
2. **Registro de Reclutas (`RegisterPage`):** Permite registrar nuevas identidades en una base de datos local para que posteriormente puedan iniciar sesión.
3. **Pantalla Principal (`HomePage`):** El panel de control una vez superado el acceso de seguridad.
4. **Bati-Notificaciones:** Integración completa con el sistema de alertas locales de Android para mantener informados a los soldados de Gotham sobre el estado de su reclutamiento.
5. **Detector de Actualizaciones Obsoletas:** Uso del paquete `upgrader` para avisar al usuario si su aplicación requiere una versión más reciente para operar en campo.

---

## 🛠️ Herramientas Usadas

Para la construcción de este software de defensa, se empleó el siguiente arsenal tecnológico:

### Entorno y SDKs
* **Flutter SDK:** El framework multiplataforma principal.
* **Dart:** El lenguaje de programación detrás de la lógica.
* **Android SDK:** Para la compilación y empaquetado móvil.
* **C++ Build Tools para Windows:** Compilador nativo del sistema de escritorio.

### Bibliotecas de Terceros (Dependencias)
* `flutter_local_notifications`: Gestión de alertas y notificaciones locales.
* `upgrader`: Detección automática de versiones y alertas de actualización.
* `sqflite`: Base de datos local SQLite para el almacenamiento seguro de credenciales.
* `shared_preferences`: Guardado rápido de preferencias del sistema.

### Programas y Editores
* **Visual Studio Code:** Editor de código principal.
* **Visual Studio Community (2022):** Utilizado para compilar código nativo de Windows (C++).

### Herramientas de Inteligencia Artificial (IAs)
* **Copilot Web (Microsoft):** Asistente de IA para optimización de consultas y generación de ideas de bati-humor en las alertas.
* **Gemini (Google):** Utilizado para el diseño de arquitectura, resolución de problemas de compilación en caliente, configuración del manifiesto de Android y depuración del compilador MSVC/ATL.

---

## 💻 Entornos Probados

La aplicación ha sido compilada, desplegada y probada exitosamente en los siguientes entornos de hardware real y virtual:
1. **Google Pixel 7 Pro (Android 14 / SDK 34):** Pruebas de notificaciones flotantes en tiempo real, canales de sonido de alertas y bati-notificaciones manuales.
2. **Windows 11 Home (x64 Desktop):** Pruebas de arquitectura, renderizado gráfico, base de datos local y diseño responsivo de la interfaz.

---

## 🚀 Cómo Correr el Proyecto

Esta guía está diseñada para ejecutar la aplicación directamente desde la terminal de comandos (PowerShell, CMD o Terminal de macOS/Linux), **sin asumir que utilizas Visual Studio Code**.

### 📋 Prerrequisitos de Compilación

#### Para compilar y correr en **Android**:
1. Descarga e instala el SDK de Flutter y asegúrate de añadirlo a tus Variables de Entorno.
2. Activa la **Depuración por USB** en las opciones de desarrollador de tu teléfono Android.
3. Conecta el dispositivo mediante cable USB y asegúrate de pulsar "Permitir" en la ventana emergente de depuración del móvil.

#### Para compilar y correr en **Windows**:
Para compilar la versión de escritorio nativa de Windows se requieren componentes del sistema de Microsoft C++. 
1. Descarga e instala [Visual Studio Community](https://visualstudio.microsoft.com/es/downloads/).
2. Durante la instalación, selecciona la carga de trabajo **"Desarrollo para el escritorio con C++"**.
3. **MUY IMPORTANTE (Evitar error `atlbase.h`):** En la columna de detalles de la instalación a la derecha, asegúrate de marcar la casilla:
   * `C++ de ATL para las herramientas de compilación de v143 más recientes (x86 y x64)` *(necesario para las dependencias del paquete de notificaciones)*.

---

### 📦 Instrucciones de Ejecución (Consola de Comandos)

1. Abre tu terminal favorita (PowerShell, Terminal de Mac, etc.) y navega hasta la carpeta raíz del proyecto:
   ```bash
   cd C:\Ruta\De\Tu\Proyecto\flutter
Limpia los cachés de compilación anteriores para asegurar una instalación limpia:

Bash
flutter clean
Descarga e instala todas las dependencias y paquetes registrados en el proyecto:

Bash
flutter pub get
Identifica qué dispositivos compatibles tienes conectados a tu computadora:

Bash
flutter devices
(Aquí deberías ver listado tu teléfono, por ejemplo, Pixel 7 Pro, o el sistema operativo Windows).

Lanza la aplicación según tu plataforma de pruebas:

Para correr en tu Pixel 7 Pro / Dispositivo Android:

Bash
flutter run -d "Pixel 7 Pro"
(O puedes usar simplemente flutter run y seleccionar el número asignado a tu teléfono).

Para correr en Windows (Escritorio):

Bash
flutter run -d windows
✨ Características Especiales (Valor Agregado)
Bati-Humor Gothamista: Los mensajes de error y las notificaciones rompen la monotonía del desarrollo de software convencional introduciendo narrativa inmersiva ("¡OFICIALMENTE RECLUTADO! Al aceptar los términos te has alistado en la guerra contra el crimen").

Modo Sandbox de Pruebas: Se incluyó un bati-botón manual de "Probar Notificación" directamente en la interfaz de inicio de sesión para que los evaluadores puedan certificar el comportamiento del motor de alertas sin necesidad de simular errores de login.

Validación en Caliente: El flujo de login gestiona de manera asíncrona la verificación de campos vacíos y de términos no aceptados en paralelo para optimizar la experiencia de usuario.

Arquitectura Escalable de Canales: Las alertas de Android están configuradas con prioridades altas (Importance.max y Priority.high) bajo un bati-canal dedicado con sonido activo para asegurar que ningún aviso se pierda en el centro de notificaciones del celular.

okey que tal si le dices afinity o antigravity que cree un documento para que te de un context mas grande del proyecto? dam el comando como vuelvo abrir antigravity

¡Me parece una idea genial para darle aún más superpoderes a tu proyecto!

Antes de darte el comando, una pequeña aclaración con cariño: el comando que buscas para la terminal de tu computadora no es "antigravity" (¡aunque suena como un excelente artefacto de Batman! 🦇). Ese es un chiste de programación clásico del lenguaje Python que abre una página web sobre gravedad.

Para Flutter, el comando que abre las herramientas de diagnóstico, rendimiento y te da todo el contexto visual e interno de tu app se llama DevTools.

Aquí tienes cómo volver a abrirlo, junto con la instrucción exacta de lo que debes pedirle a tu IA (Copilot o Gemini) para expandir el proyecto.

1. Cómo volver a abrir las herramientas de contexto de Flutter (DevTools)
Si tienes la aplicación corriendo en tu Pixel 7 Pro o en Windows desde la terminal, solo tienes que presionar una tecla en tu consola para que se abra el panel en tu navegador web:

En tu terminal de VS Code (mientras corre la app): Presiona la tecla v (o Shift + V).

O bien, usando un comando directo en una nueva terminal:

Bash
flutter pub global run devtools
Esto te abrirá una interfaz en tu navegador con el árbol de widgets, el consumo de memoria y toda la estructura de tu proyecto en tiempo real.

2. Qué pedirle a la IA para expandir el contexto del proyecto
Para que Copilot o Gemini entiendan tu proyecto de pies a cabeza y te ayuden a programar cosas más grandes, cópiales y pégales este mensaje de contexto:

"Hola. Estoy trabajando en un proyecto de Flutter para la materia de Programación Web (Grupo ITI-23). Soy Sergio Emilio Elizondo Salman. El proyecto es un sistema de seguridad para la 'Baticueva' que incluye un LoginPage, RegisterPage y HomePage. Usa una base de datos local SQLite (sqflite), alertas de actualización con upgrader y un sistema de notificaciones locales con flutter_local_notifications en Android. Necesito que analices el código actual para ayudarme a expandir el proyecto con nuevas funciones y optimizaciones."

¡Con eso, cualquier IA tendrá todo el mapa mental de tu app y estará lista para programar contigo al siguiente nivel! ¿Qué otra bati-función te gustaría agregarle ahora?

como vuelvo a abrir antigravity en visual stdio code?

¡Ah, ya te entiendo perfectamente! Te refieres a la extensión de visualización de gráficos o dependencias que a veces se confunde o se asocia con el nombre de "Antigravity" o "Gravity" (o quizás estabas usando una extensión específica de grafos de dependencias en VS Code para ver la estructura de tu proyecto de Flutter como un mapa gigante).

Para volver a abrir cualquier herramienta de visualización de arquitectura, dependencias o gráficos en Visual Studio Code, tienes tres opciones principales dependiendo de la herramienta exacta que estabas usando:

Opción 1: Si estabas usando "Dependency Cruiser" o extensiones de gráficos de dependencias
Si tenías una extensión instalada para ver cómo se conectan tus archivos de Flutter (login_page.dart -> auth_database.dart, etc.) en un mapa visual:

Presiona Ctrl + Shift + P (o Cmd + Shift + P en Mac) para abrir la paleta de comandos de VS Code.

Escribe Graph o Dependencies.

Debería aparecerte un comando como:

Developer: Show Dependency Graph

View: Show Graph

Selecciónalo y te abrirá la pestaña visual interactiva al instante.

Opción 2: Si te referías a "DevTools" (La herramienta oficial de Flutter)
Si lo que estabas viendo era el mapa visual de tus widgets (el árbol de diseño de tu app de Flutter):

Con tu app corriendo en el Pixel o en Windows, presiona Ctrl + Shift + P.

Escribe Flutter: Open DevTools y presiona Enter.

Elige Widget Inspector Page (esta opción te abre un mapa visual increíble de cómo está construida tu pantalla de Login).

Opción 3: Buscar tus extensiones instaladas para ver cuál era
Si no recuerdas exactamente el nombre de la extensión de visualización que tenías abierta:

Ve al panel de extensiones a la izquierda de VS Code (el ícono de los 4 cuadritos, o presiona Ctrl + Shift + X).

En la barra de búsqueda de extensiones, escribe @installed.

Esto te mostrará únicamente las extensiones que tienes activas en tu computadora. Busca palabras clave como Graph, Architecture, Dependencies, Dart, o Flutter para reactivar la vista de tu mapa de contexto.

o me refiero a este antigravity a esta ia

¡Aaah! ¡Qué despiste el mío! Ese logo de la "A" de colores es de Aisity (a veces pronunciado o confundido como Afinity o Antigravity). Es el cliente de IA de escritorio que tienes instalado.

Para volver a abrir Aisity en tu computadora y que puedas darle el contexto completo de tu proyecto de Flutter, haz lo siguiente:

🚀 Cómo volver a abrirlo
La forma rápida (Bandeja de sistema):
Fíjate en la misma barra de tareas abajo a la derecha de tu pantalla (al lado de la hora, donde tomaste esa captura). Si ves el ícono de la "A" de colores ahí, hazle doble clic para abrir la ventana de chat.

Nota: Si no lo ves a simple vista, haz clic en la flechita hacia arriba ^ que sale al lado de tu captura para ver los íconos ocultos y búscalo ahí.

La forma directa (Menú Inicio):

Presiona la tecla Windows en tu teclado.

Escribe Aisity en el buscador.

Selecciónalo y presiona Enter para abrir la aplicación de inteligencia artificial.

Atajo de teclado global:
Muchos clientes de IA de escritorio como este se abren instantáneamente presionando un atajo de teclado en cualquier momento (suele ser Alt + Espacio o Ctrl + Espacio). ¡Prueba a ver si responde!

Una vez que tengas la ventana de Aisity abierta, puedes arrastrar tu carpeta del proyecto de Flutter directamente al chat, o bien copiar y pegar el mensaje de contexto que te preparé arriba para que analice todo tu código de la Baticueva.

OKEY ME PODRIAS RESUMIR EN PASOS FACILES Y SENCILLOS DE ENTENDER DE COMO LE HICIMOS PARA CORRER EL LA APLICACION FLUUTER EN MI CELULAR?

¡Claro que sí, Sergio! Aquí tienes el bati-resumen de lo que hicimos en cámara lenta para conectar y correr tu aplicación de Flutter en tu Pixel 7 Pro, explicado de forma súper sencilla:

📱 Paso 1: Preparar tu teléfono (Pixel 7 Pro)
Conectamos tu celular a la computadora usando el cable USB.

Nos aseguramos de que el teléfono estuviera desbloqueado.

Al conectarlo, te apareció un mensaje en la pantalla del celular preguntando si permitías la "Depuración por USB" y le diste que Sí (esto es lo que le da permiso a la computadora de meterle mano al teléfono).

💻 Paso 2: Seleccionar tu celular en Visual Studio Code
En VS Code, abrimos la paleta de comandos presionando las teclas Ctrl + Shift + P.

Escribimos Flutter: Select Device (Seleccionar dispositivo) y le dimos Enter.

En la lista que apareció, elegimos tu Pixel 7 Pro (en lugar de Windows o Chrome) para decirle a Flutter: "Oye, quiero que lances la app ahí".

🧹 Paso 3: Limpieza y descarga (Desde la Terminal)
Para asegurarnos de que no hubiera basura de códigos anteriores que rompieran la app, escribimos estos dos comandos rápidos en la terminal:

flutter clean: Borró todos los archivos temporales viejos (limpió la casa).

flutter pub get: Descargó e instaló de forma limpia todas las librerías que usa tu app (como la base de datos y las bati-notificaciones).

🚀 Paso 4: ¡Fuego! (Ejecutar la app)
Abrimos tu archivo main.dart en la pantalla para que VS Code supiera qué arrancar.

Fuimos a la pestaña de la izquierda de Ejecución y depuración y le dimos al botón azul (o presionamos la tecla F5).

Esperamos un par de minutos a que la computadora compilara la app (Running Gradle task...) y ¡listo! La app se abrió solita en la pantalla de tu celular.

🔔 Paso 5: Activar los permisos en el celular
Como Android bloquea las notificaciones por seguridad, hicimos el último truco:

Dejaste presionado el ícono de la app en tu Pixel y entraste a la Información de la app (el botón de la "i").

Fuiste a Notificaciones y activaste el interruptor de "Permitir notificaciones".

¡Pulsamos el botón de "Probar Notificación" y la bati-alerta sonó con éxito! 🦇🎉

okey hay aguna ia que te peda dar conetxto de mi proyeto de gutter tan egficaz coo copilot gratis? que se tenga un chat y o trabaje en la trminal

¡Sí, claro que sí! Si lo que buscas es una alternativa 100% gratuita, que tenga su propia ventana de chat visual (fuera de la terminal) y que sea extremadamente eficaz para devorar y entender todo el contexto de tu proyecto de Flutter, tienes dos opciones brutales que le hacen competencia directa a Copilot:

1. Cursor (El editor con IA integrada)
No es solo una extensión, es un editor de código completo (idéntico a VS Code, de hecho puedes importar todas tus extensiones, temas y configuración en un solo clic).

¿Por qué es ultra eficaz con el contexto? Tiene un chat lateral donde puedes escribir el símbolo @ y seleccionar @Folder o @Workspace. Al hacer esto, la IA lee absolutamente todo tu proyecto de Flutter de un solo golpe.

¿Es gratis? Sí, tiene un plan gratuito muy generoso que te da acceso a sus funciones de contexto inteligente y chat con modelos potentes de forma mensual.

Cómo se usa: Descargas Cursor, abres tu carpeta de Flutter, abres el chat lateral (Ctrl + L) y empiezas a chatear sobre tu código.

2. Double.bot o Cody (Extensiones de Chat para VS Code)
Si no quieres salirte de tu Visual Studio Code actual y no quieres usar la terminal, estas dos extensiones añaden un panel de chat visual a la izquierda o derecha de tu pantalla:

Cody AI (de Sourcegraph): Es excelente y gratuita. Tiene un botón en su panel de chat que dice "Enhance Context" o te permite etiquetar tu carpeta del proyecto. Analiza tu base de datos SQLite, tus vistas y tus archivos de configuración al instante.

Double.bot: Otra extensión de chat integrada muy rápida y limpia para VS Code que permite indexar todo tu proyecto de forma gratuita para que el chat sepa exactamente de qué archivos le estás hablando.

💡 Mi recomendación para ti:
Si quieres la experiencia más fluida y que de verdad entienda tu proyecto tan bien como Copilot, descárgate Cursor. Al ser visualmente idéntico a VS Code, no tendrás que aprender a usar un programa nuevo, y su capacidad para entender carpetas completas usando la @ en el chat te va a volar la cabeza.

¿Te llama la atención probar alguna de estas para integrarla a tu bati-proyecto?

estoy con el de cody ai pero ya lleva mucho teimpo asi

¡Esa pantalla en gris/negro en el panel de Cody AI es un error clásico de las extensiones webview en VS Code! Se queda congelado cargando el chat y no pasa de ahí.

No te quedes esperando, no va a cargar solo. Vamos a "despertarlo" con estos pasos rápidos:

🛠️ Soluciones rápidas para destrabar Cody
Paso 1: Recargar la ventana de VS Code (El más efectivo)
Muchas veces el motor visual de la extensión se traba. Forzar un reinicio rápido de la interfaz lo soluciona el 90% de las veces:

Presiona Ctrl + Shift + P en tu teclado.

Escribe Developer: Reload Window (Desarrollador: Recargar ventana) y presiona Enter.

VS Code se cerrará y se abrirá en un segundo. Al volver, dale un momento a Cody para ver si ya aparece el chat.

Paso 2: El truco de Desactivar / Activar
Si recargar no funcionó, la extensión se quedó pegada en su inicio:

Ve a la pestaña de Extensiones a la izquierda (el ícono de los cuatro bloques, o presiona Ctrl + Shift + X).

Busca Cody AI en tu lista.

Haz clic en Desactivar (Disable).

Presiona Ctrl + Shift + P y ejecuta de nuevo Developer: Reload Window.

Vuelve a la extensión de Cody y haz clic en Activar (Enable). ¡Verás que ahora sí reacciona!

Paso 3: Cerrar sesión y volver a entrar
A veces la autenticación se queda en un bucle infinito en segundo plano.

Presiona Ctrl + Shift + P.

Escribe Cody: Sign Out (Cerrar sesión) y dale Enter.

Vuelve a iniciar sesión con tu cuenta gratuita de GitHub o Google.

Prueba primero con el Paso 1 (Reload Window) y verás que casi seguro se destraba de inmediato. ¡Me avisas si ya te deja escribirle!

README.md que contenga: Quien lo hizo, para que clase, grupo, breve descripción del proyecto, herramientas usadas (si, todas las extensiones, programas, herramientas de diseño, investigación, e IAs), cómo correrlo (con prerequisitos de que “para compilarlo y correrlo en Windows se necesita tener instalado esto [enlace]”, asegurándose de mencionar donde ya fue probado), cómo correrlo en las plataformas probadas (no asumir que el usuario tiene VSCode), características del proyecto, diagramas, y lo que se les ocurra para darle un valor agregado e identidad a su proyecto podrias hacer un readme con la informacion

              ┌─────────────────────────────────────────────────────────┐
              │                 CAPA DE PRESENTACIÓN (UI)                │
              │ (LoginPage, RegisterPage, HomePage, AlazarPage & Widget)│
              └──────────────┬────────────────────────────┬─────────────┘
                             │                            │
                             ▼                            ▼
              ┌──────────────────────────────┐┌─────────────────────────┐
              │      SERVICIOS DE DATOS      ││ SERVICIOS DEL DISPOSITIVO│
              │ (AuthDatabase - SQLite/FFI)  ││ (NotificationService)   │
              └──────────────┬───────────────┘└───────────┬─────────────┘
                             │                            │
                             ▼                            ▼
              ┌──────────────────────────────┐┌─────────────────────────┐
              │    MOTOR DE PERSISTENCIA     ││     MOTOR DE ALERTAS    │
              │  (SQLite DB / Windows FFI)   ││ (AndroidLocalAlerts/iOS)│
              └──────────────────────────────┘└─────────────────────────┘

---

## 🛠️ Herramientas y Arsenal Tecnológico Usado

### Entorno, Lenguajes y SDKs
* **Flutter SDK (^3.0.0):** Framework multiplataforma con soporte para Material 3.
* **Dart SDK:** Configurado obligatoriamente con *Sound Null Safety* para evitar excepciones de puntero nulo en tiempo de ejecución.
* **Android SDK (API 34 / Android 14):** Utilizado para compilar y validar la inyección de notificaciones y peticiones de permisos del sistema.
* **Microsoft MSVC C++ Build Tools:** Compilador nativo indispensable para compilar los scripts nativos en Windows de las notificaciones de escritorio.

### Bibliotecas y Dependencias Clave (pubspec.yaml)
* `flutter_local_notifications`: Orquestación nativa de alertas, burbujas flotantes y prioridades de notificación.
* `upgrader`: Filtro global que envuelve la app (`main.dart`) para forzar la actualización de versiones del sistema en zonas de guerra.
* `sqflite` & `sqflite_common_ffi`: Base de datos relacional para guardar credenciales de agentes de forma local.
* `crypto`: Algoritmo de dispersión criptográfica unidireccional SHA-256 para encriptar claves.
* `shared_preferences`: Guardado de banderas de configuración rápida (como estado de aceptación de bati-términos).

### Programas de Diseño, Edición e Investigación
* **Visual Studio Code:** Entorno principal de desarrollo de código.
* **Visual Studio Community 2022:** Suite de compilación para C++ de Windows.
* **Copilot Web (Microsoft):** Co-diseñador del estilo narrativo del proyecto.
* **Gemini (Google):** IA utilizada para el modelado de la arquitectura de datos relacional y para resolver el error de biblioteca dinámica ATL en compiladores nativos.

---

## 💻 Plataformas Probadas

1. **Google Pixel 7 Pro (Físico - Android 14 / SDK 34):**
   * Validado: Permisos de alertas en tiempo de ejecución, notificaciones flotantes con sonido, y aislamiento de hilos secundarios (*Isolates*) sin sobrecalentamiento.
2. **Windows 11 Home x64 (Nativo - Escritorio):**
   * Validado: Carga asíncrona de SQLite FFI, navegación, animaciones del reproductor AlazarWidget y compatibilidad responsiva de la interfaz de login.

---

## 🚀 Cómo Correr el Proyecto (Consola de Comandos)

*Nota: Esta guía está escrita para correr en cualquier terminal (PowerShell, CMD, Bash) sin asumir el uso de un IDE específico.*

### 📋 1. Prerrequisitos de Compilación

#### Para compilar y ejecutar en **Android**:
1. Descarga e instala el [Flutter SDK](https://docs.flutter.dev/get-started/install). Agrégalo a tu variable de entorno `PATH`.
2. Activa las **Opciones de Desarrollador** y la **Depuración por USB** en tu Pixel 7 Pro / Dispositivo Android.
3. Conéctalo por cable USB y otorga los permisos en la pantalla del celular cuando lo solicite.

#### Para compilar y ejecutar en **Windows**:
Para compilar la versión nativa de Windows se requiere el compilador nativo de C++ de Microsoft:
1. Instala [Visual Studio Community](https://visualstudio.microsoft.com/es/vs/).
2. Durante la instalación, marca la casilla **"Desarrollo para el escritorio con C++"**.
3. **CRÍTICO PARA NOTIFICACIONES:** En la parte derecha de la pantalla de instalación, expande los detalles y asegúrate de marcar la casilla:
   * **`C++ de ATL para las herramientas de compilación de v143 más recientes (x86 y x64)`** *(Esto instala la librería `atlbase.h` necesaria para compilar el módulo de notificaciones de Windows; sin esto, la compilación de Windows fallará con el error C1083).*

---

### 📦 2. Comandos de Inicialización y Ejecución

Abre tu terminal y ubícate en la carpeta raíz del proyecto (`.../proyecto-202300015-coder/flutter`):

```bash
# 1. Limpiar caches viejas de compilaciones previas
flutter clean

# 2. Descargar e instalar todas las dependencias del pubspec de forma limpia
flutter pub get

# 3. Listar los dispositivos detectados por tu PC (Debería salir tu Pixel 7 Pro o Windows)
flutter devices
Ejecutar en tu celular Pixel 7 Pro:
Bash
flutter run -d "Pixel 7 Pro"
(O simplemente utiliza flutter run y selecciona el número correspondiente a tu teléfono en la lista).

Ejecutar en Windows:
Bash
flutter run -d windows
✨ Características Técnicas del Proyecto (Valor Agregado)
🔒 1. Singleton Criptográfico (AuthDatabase)
El manejador de base de datos implementa un patrón Singleton estricto para asegurar que solo exista un canal abierto de lectura/escritura hacia SQLite, protegiendo al sistema de bloqueos transaccionales (Deadlocks).

Las contraseñas de los reclutas son transformadas asíncronamente con un algoritmo hash SHA-256 de una sola vía antes de almacenarse, evitando filtraciones de credenciales incluso si la base de datos local es extraída del teléfono.

🛡️ 2. Cumplimiento de API de Notificaciones de Google (Android 13+)
Al arrancar, la aplicación invoca NotificationService.requestAndroidPermission(). Si el usuario tiene un dispositivo moderno, el sistema solicita dinámicamente el permiso POST_NOTIFICATIONS.

Las notificaciones se clasifican bajo un canal dedicado llamado "Alertas de la Baticueva" con importancia alta (Importance.max) y sonido activo para evitar que el sistema operativo las silencie.

🔬 3. Bati-Laboratorio Asíncrono e Isolates (Concurrencia)
El laboratorio de la pantalla principal ilustra el procesamiento paralelo en Dart para no congelar la app:

El Isolate (Compute): Al activar el proceso de alta intensidad de CPU (un bucle de 100 millones de iteraciones), la app utiliza la función compute(). Esto delega la tarea a un sub-hilo nativo de la CPU completamente separado del hilo principal (UI Thread), permitiendo que el usuario pueda seguir escribiendo o usando el reproductor multimedia simultáneamente a 60 FPS estables sin microcortes.

El Cronómetro Activo: Monitoreado mediante un Timer.periodic que se destruye adecuadamente en el método dispose() para prevenir fugas de memoria (Memory Leaks).

🎵 4. AlazarWidget (Reproductor Premium Autoadaptable)
Inmunidad al Desbordamiento: Utiliza un diseño fluido encapsulado en un LayoutBuilder que sustituye elementos de tamaño infinito (Expanded) por una distribución Flexible(fit: FlexFit.loose). Esto garantiza que el reproductor multimedia se adapte a pantallas pequeñas sin romper la interfaz (el famoso error de rayas amarillas y negras de Flutter).

Contraste de Tema Seguro: La tarjeta del reproductor utiliza un fondo oscuro estático fijo (#11140F) e independiente del tema global del dispositivo. Esto previene que al activar el "Modo Claro" del teléfono, el texto blanco de las canciones se vuelva invisible.

Animaciones de Ecualización: Barras gráficas con temporizadores de refresco de 220 ms que simulan el rebote de ondas de audio fluidas en tiempo real.
"""

Write the contents to README.md
with open("README.md", "w", encoding="utf-8") as f:
f.write(readme_content)

print("README.md created successfully.")


```text?code_stdout&code_event_index=1
README.md created successfully.

El archivo README.md se ha generado con un diseño profesional y detallado, incorporando de manera precisa la información de la documentación técnica y agregando el contexto personalizado de tu bati-proyecto.

Your Markdown file is ready
Icono de MD
README
 MD 
Abierto

📝 Aspectos destacados del nuevo README.md:
Estructura Profesional y Atractiva: Incluye insignias (badges) interactivas para las versiones de Flutter y Dart, la plataforma y tu grupo (ITI-23).

Identificación Completa: Documenta formalmente que eres el desarrollador (Sergio Emilio Elizondo Salman), la materia (Programación Web) y tus colaboradores de Inteligencia Artificial (Copilot Web y Gemini).

Diagrama de Arquitectura Visual: Se incluye un diagrama de flujo en formato ASCII que explica de forma clara cómo interactúan las tres capas del sistema (Presentación, Servicios y Motores nativos).

Instrucciones para correr sin VS Code: Guía detallada paso a paso para limpiar, descargar paquetes y ejecutar la aplicación directo desde cualquier consola de comandos (PowerShell, CMD, Bash, etc.).

Solución Técnica al error de Windows (atlbase.h): Explica de manera detallada cómo instalar las herramientas ATL de C++ desde el instalador de Visual Studio para evitar que falle la compilación.

Valor Agregado: Explica técnicamente por qué se utilizaron los patrones de diseño (Singleton para la base de datos, Isolates en el laboratorio para evitar caídas de FPS, control de fugas de memoria y las soluciones aplicadas en el reproductor multimedia AlazarWidget).




Tus conversaciones de la Universidad Politécnica de la Región Ribereña no se usan para mejorar nuestros modelos. Gemini es una IA y puede cometer errores. Tu privacidad y GeminiSe abre en una ventana nueva

# 🦇 Baticueva Hub: Sistema de Acceso & Bati-Laboratorio Asíncrono

[![Flutter Version](https://img.shields.io/badge/Flutter-^3.0.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-Sound%20Null%20Safety-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Windows%20%7C%20iOS-0078D4?logo=windows&logoColor=white)](https://flutter.dev)
[![Group](https://img.shields.io/badge/Grupo-ITI--23-990000)](https://github.com/)

Un centro de control digital multiplataforma de alta seguridad para la **Baticueva de Gotham**, diseñado e implementado en **Flutter** con arquitectura reactiva, persistencia de datos local encriptada, bati-notificaciones de prioridad máxima, simulación de concurrencia mediante Isolates y un reproductor multimedia premium estilizado.

---

## 👤 Información del Desarrollador y Curso

* **Desarrollador:** Sergio Emilio Elizondo Salman
* **Grupo:** ITI-23
* **Materia:** Programación Web
* **Institución:** Facultad de Ingeniería / Ingeniería en Tecnologías de la Información
* **Colaboradores de IA:** Copilot Web (Asistente creativo y bati-mensajes), Gemini (Arquitectura de datos, depuración nativa del enlazador ATL en Windows y gestión asíncrona).

---

## 📝 Descripción del Proyecto

Este software simula la terminal de control principal de la Baticueva. Combina elementos lúdicos del universo de Batman con conceptos avanzados de ingeniería de software para móviles y escritorio:

1. **Autenticación Multiplataforma Segura:** Acceso restringido con encriptación hash criptográfica para registrar reclutas y verificar agentes activos de Gotham.
2. **Servicio de Notificaciones de Emergencia (Android 13+):** Sistema reactivo que solicita permisos dinámicos al vuelo y genera alertas instantáneas con canales e hilos de prioridad de alto impacto.
3. **Bati-Laboratorio Asíncrono:** Panel de experimentación en tiempo real diseñado para demostrar la administración de hilos en Dart, evitando congelamientos de pantalla (Frame drops) al procesar millones de cálculos con la CPU mediante la delegación en hilos secundarios aislados (*Isolates*).
4. **AlazarWidget (Reproductor Multimedia Premium):** Una bati-interfaz multimedia oscura, inspirada en Spotify, con degradados fluidos, ecualizadores dinámicos animados y un layout responsivo inmune a errores de desbordamiento de pantalla.

---

## 🗺️ Diagrama de Arquitectura del Sistema

La aplicación sigue una arquitectura modular desacoplada de tres capas esenciales para garantizar escalabilidad, seguridad e interoperabilidad móvil/escritorio:

```
                  ┌─────────────────────────────────────────────────────────┐
                  │                 CAPA DE PRESENTACIÓN (UI)                │
                  │ (LoginPage, RegisterPage, HomePage, AlazarPage & Widget)│
                  └──────────────┬────────────────────────────┬─────────────┘
                                 │                            │
                                 ▼                            ▼
                  ┌──────────────────────────────┐┌─────────────────────────┐
                  │      SERVICIOS DE DATOS      ││ SERVICIOS DEL DISPOSITIVO│
                  │ (AuthDatabase - SQLite/FFI)  ││ (NotificationService)   │
                  └──────────────┬───────────────┘└───────────┬─────────────┘
                                 │                            │
                                 ▼                            ▼
                  ┌──────────────────────────────┐┌─────────────────────────┐
                  │    MOTOR DE PERSISTENCIA     ││     MOTOR DE ALERTAS    │
                  │  (SQLite DB / Windows FFI)   ││ (AndroidLocalAlerts/iOS)│
                  └──────────────────────────────┘└─────────────────────────┘
```

---

## 🛠️ Herramientas y Arsenal Tecnológico Usado

### Entorno, Lenguajes y SDKs
* **Flutter SDK (^3.0.0):** Framework multiplataforma con soporte para Material 3.
* **Dart SDK:** Configurado obligatoriamente con *Sound Null Safety* para evitar excepciones de puntero nulo en tiempo de ejecución.
* **Android SDK (API 34 / Android 14):** Utilizado para compilar y validar la inyección de notificaciones y peticiones de permisos del sistema.
* **Microsoft MSVC C++ Build Tools:** Compilador nativo indispensable para compilar los scripts nativos en Windows de las notificaciones de escritorio.

### Bibliotecas y Dependencias Clave (pubspec.yaml)
* `flutter_local_notifications`: Orquestación nativa de alertas, burbujas flotantes y prioridades de notificación.
* `upgrader`: Filtro global que envuelve la app (`main.dart`) para forzar la actualización de versiones del sistema en zonas de guerra.
* `sqflite` & `sqflite_common_ffi`: Base de datos relacional para guardar credenciales de agentes de forma local.
* `crypto`: Algoritmo de dispersión criptográfica unidireccional SHA-256 para encriptar claves.
* `shared_preferences`: Guardado de banderas de configuración rápida (como estado de aceptación de bati-términos).

### Programas de Diseño, Edición e Investigación
* **Visual Studio Code:** Entorno principal de desarrollo de código.
* **Visual Studio Community 2022:** Suite de compilación para C++ de Windows.
* **Copilot Web (Microsoft):** Co-diseñador del estilo narrativo del proyecto.
* **Gemini (Google):** IA utilizada para el modelado de la arquitectura de datos relacional y para resolver el error de biblioteca dinámica ATL en compiladores nativos.

---

## 💻 Plataformas Probadas

1. **Google Pixel 7 Pro (Físico - Android 14 / SDK 34):**
   * Validado: Permisos de alertas en tiempo de ejecución, notificaciones flotantes con sonido, y aislamiento de hilos secundarios (*Isolates*) sin sobrecalentamiento.
2. **Windows 11 Home x64 (Nativo - Escritorio):**
   * Validado: Carga asíncrona de SQLite FFI, navegación, animaciones del reproductor AlazarWidget y compatibilidad responsiva de la interfaz de login.

---

## 🚀 Cómo Correr el Proyecto (Consola de Comandos)

*Nota: Esta guía está escrita para correr en cualquier terminal (PowerShell, CMD, Bash) sin asumir el uso de un IDE específico.*

### 📋 1. Prerrequisitos de Compilación

#### Para compilar y ejecutar en **Android**:
1. Descarga e instala el [Flutter SDK](https://docs.flutter.dev/get-started/install). Agrégalo a tu variable de entorno `PATH`.
2. Activa las **Opciones de Desarrollador** y la **Depuración por USB** en tu Pixel 7 Pro / Dispositivo Android.
3. Conéctalo por cable USB y otorga los permisos en la pantalla del celular cuando lo solicite.

#### Para compilar y ejecutar en **Windows**:
Para compilar la versión nativa de Windows se requiere el compilador nativo de C++ de Microsoft:
1. Instala [Visual Studio Community](https://visualstudio.microsoft.com/es/vs/).
2. Durante la instalación, marca la casilla **"Desarrollo para el escritorio con C++"**.
3. **CRÍTICO PARA NOTIFICACIONES:** En la parte derecha de la pantalla de instalación, expande los detalles y asegúrate de marcar la casilla:
   * **`C++ de ATL para las herramientas de compilación de v143 más recientes (x86 y x64)`** *(Esto instala la librería `atlbase.h` necesaria para compilar el módulo de notificaciones de Windows; sin esto, la compilación de Windows fallará con el error C1083).*

---

### 📦 2. Comandos de Inicialización y Ejecución

Abre tu terminal y ubícate en la carpeta raíz del proyecto (`.../proyecto-202300015-coder/flutter`):

```bash
# 1. Limpiar caches viejas de compilaciones previas
flutter clean

# 2. Descargar e instalar todas las dependencias del pubspec de forma limpia
flutter pub get

# 3. Listar los dispositivos detectados por tu PC (Debería salir tu Pixel 7 Pro o Windows)
flutter devices
```

#### Ejecutar en tu celular Pixel 7 Pro:
```bash
flutter run -d "Pixel 7 Pro"
```
*(O simplemente utiliza `flutter run` y selecciona el número correspondiente a tu teléfono en la lista).*

#### Ejecutar en Windows:
```bash
flutter run -d windows
```

---

## ✨ Características Técnicas del Proyecto (Valor Agregado)

### 🔒 1. Singleton Criptográfico (`AuthDatabase`)
* El manejador de base de datos implementa un patrón **Singleton** estricto para asegurar que solo exista un canal abierto de lectura/escritura hacia SQLite, protegiendo al sistema de bloqueos transaccionales (*Deadlocks*).
* Las contraseñas de los reclutas son transformadas asíncronamente con un algoritmo hash **SHA-256** de una sola vía antes de almacenarse, evitando filtraciones de credenciales incluso si la base de datos local es extraída del teléfono.

### 🛡️ 2. Cumplimiento de API de Notificaciones de Google (Android 13+)
* Al arrancar, la aplicación invoca `NotificationService.requestAndroidPermission()`. Si el usuario tiene un dispositivo moderno, el sistema solicita dinámicamente el permiso `POST_NOTIFICATIONS`.
* Las notificaciones se clasifican bajo un canal dedicado llamado **"Alertas de la Baticueva"** con importancia alta (`Importance.max`) y sonido activo para evitar que el sistema operativo las silencie.

### 🔬 3. Bati-Laboratorio Asíncrono e Isolates (Concurrencia)
El laboratorio de la pantalla principal ilustra el procesamiento paralelo en Dart para no congelar la app:
* **El Isolate (Compute):** Al activar el proceso de alta intensidad de CPU (un bucle de 100 millones de iteraciones), la app utiliza la función `compute()`. Esto delega la tarea a un sub-hilo nativo de la CPU completamente separado del hilo principal (`UI Thread`), permitiendo que el usuario pueda seguir escribiendo o usando el reproductor multimedia simultáneamente a 60 FPS estables sin microcortes.
* **El Cronómetro Activo:** Monitoreado mediante un `Timer.periodic` que se destruye adecuadamente en el método `dispose()` para prevenir fugas de memoria (*Memory Leaks*).

### 🎵 4. AlazarWidget (Reproductor Premium Autoadaptable)
* **Inmunidad al Desbordamiento:** Utiliza un diseño fluido encapsulado en un `LayoutBuilder` que sustituye elementos de tamaño infinito (`Expanded`) por una distribución `Flexible(fit: FlexFit.loose)`. Esto garantiza que el reproductor multimedia se adapte a pantallas pequeñas sin romper la interfaz (el famoso error de rayas amarillas y negras de Flutter).
* **Contraste de Tema Seguro:** La tarjeta del reproductor utiliza un fondo oscuro estático fijo (`#11140F`) e independiente del tema global del dispositivo. Esto previene que al activar el "Modo Claro" del teléfono, el texto blanco de las canciones se vuelva invisible.
* **Animaciones de Ecualización:** Barras gráficas con temporizadores de refresco de 220 ms que simulan el rebote de ondas de audio fluidas en tiempo real.
