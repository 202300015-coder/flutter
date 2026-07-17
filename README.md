# 🦇 Baticueva Hub

## 👤 Información del proyecto

- **Desarrollador:** Sergio Emilio Elizondo Salman
- **Carrera:** Ingeniería en Tecnologías de la Información
- **Materia:** Programación Web
- **Grupo:** ITI-23

---

# 📝 Descripción

Baticueva Hub es una aplicación desarrollada en Flutter que simula un sistema de acceso seguro para la Baticueva. La aplicación permite registrar usuarios, iniciar sesión mediante una base de datos local, enviar notificaciones al dispositivo y verificar si existe una nueva versión disponible mediante el paquete Upgrader.

---

# 🏗️ Arquitectura

```text
              ┌──────────────────────────────┐
              │      CAPA DE PRESENTACIÓN    │
              │ Login │ Registro │ Inicio    │
              └──────────────┬───────────────┘
                             │
           ┌─────────────────┴─────────────────┐
           ▼                                   ▼
 ┌──────────────────────┐           ┌──────────────────────┐
 │   Base de Datos      │           │ Servicio de          │
 │ SQLite (AuthDatabase)│           │ Notificaciones       │
 └──────────────────────┘           └──────────────────────┘
```

---

# 🛠️ Herramientas utilizadas

## Lenguajes y Frameworks

- Flutter
- Dart

## Dependencias

- flutter_local_notifications
- upgrader
- sqflite
- sqflite_common_ffi
- shared_preferences
- crypto

## Programas

- Visual Studio Code
- Visual Studio Community 2022
- Android Studio (SDK Android)

## Inteligencia Artificial

- GitHub Copilot
- Gemini
- ChatGPT

---

# 💻 Plataformas probadas

- Windows 11
- Google Pixel 7 Pro (Android)

---

# 🚀 Cómo ejecutar el proyecto

## Requisitos

### Android

- Flutter SDK
- Android SDK
- Activar la Depuración USB

### Windows

Instalar Visual Studio Community con la carga de trabajo:

- Desarrollo para escritorio con C++

Descarga:

https://visualstudio.microsoft.com/es/vs/

---

## Comandos

```bash
flutter clean
flutter pub get
flutter devices
```

### Ejecutar en Android

```bash
flutter run
```

### Ejecutar en Windows

```bash
flutter run -d windows
```

---

# ✨ Características

- Inicio de sesión.
- Registro de usuarios.
- Base de datos local SQLite.
- Notificaciones locales.
- Verificación automática de actualizaciones.
- Compatible con Android y Windows.

---

# 📂 Estructura principal

```
lib/
│
├── main.dart
├── login_page.dart
├── register_page.dart
├── home_page.dart
├── alazar.dart
├── auth_database.dart
└── notification_service.dart
```

---

# 📚 Tecnologías principales

- Flutter
- Dart
- SQLite
- Android SDK
- Windows Desktop

---

# 👨‍💻 Autor

**Sergio Emilio Elizondo Salman**

Universidad Politécnica de la Región Ribereña

Ingeniería en Tecnologías de la Información