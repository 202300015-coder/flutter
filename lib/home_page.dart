import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'login_page.dart';
import 'alazar.dart';
import 'pages/api_crud_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textoController = TextEditingController();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool mostrarResultado = false;
  bool checkboxValue = false;
  double imageScale = 1.0;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  // Inicializa el servicio de notificaciones locales
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // CORRECCIÓN: Se usa el parámetro con nombre 'settings' requerido por las nuevas versiones
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // 1. Notificación instantánea al entrar a la Home
    _lanzarNotificacion(
      id: 1,
      titulo: '¡Bati-Alerta de Seguridad! 🦇',
      cuerpo: 'Has ingresado con éxito a la baticueva (Home Page).',
    );
  }

  // Función genérica para disparar notificaciones
  Future<void> _lanzarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'canal_bromas', // ID del canal
      'Alertas de la Baticueva', // Nombre del canal
      channelDescription: 'Canal para notificaciones divertidas y del sistema',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // CORRECCIÓN: Se asignan explícitamente los parámetros con nombre
    await _notificationsPlugin.show(
      id: id,
      title: titulo,
      body: cuerpo,
      notificationDetails: platformChannelSpecifics,
    );
  }

  @override
  void dispose() {
    textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ApiCrudPage(),
                ),
              );
            },
            child: const Text('API CRUD'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlazarPage(),
                ),
              );
            },
            child: const Text('Nuevo'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F5EF),
              Color(0xFFE7E0D1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: mostrarResultado ? _buildResultado() : _buildFormulario(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'absolute-batman-wraparound-variant-by-clay-seth-mann-v0-694w8mit4yjg1.webp',
                  height: 220 * imageScale,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Batman, en su versión más brutal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textoController,
                decoration: InputDecoration(
                  labelText: 'Escribe tu texto',
                  hintText: 'Ingresa algo aquí...',
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Tamaño de la imagen'),
              Slider(
                value: imageScale,
                min: 0.5,
                max: 1.6,
                divisions: 11,
                label: imageScale.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    imageScale = value;
                  });

                  // 2. Alerta humorística por agrandar demasiado la imagen
                  if (imageScale >= 1.5) {
                    _lanzarNotificacion(
                      id: 2,
                      titulo: '¡Suelte ese Slider, ciudadano! 🔍',
                      cuerpo: 'Un poco más de zoom y vas a desintegrar los píxeles de Batman.',
                    );
                  }
                },
              ),
              const SizedBox(height: 5),
              CheckboxListTile(
                title: const Text('Activar modo destacado'),
                value: checkboxValue,
                onChanged: (value) {
                  setState(() {
                    checkboxValue = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  debugPrint(
                    'Texto: ${textoController.text} - Checkbox: $checkboxValue',
                  );

                  // 3. Notificación si el usuario le da click y el texto está vacío
                  if (textoController.text.trim().isEmpty) {
                    _lanzarNotificacion(
                      id: 3,
                      titulo: '¡Alerta de campo vacío! ⚠️',
                      cuerpo: 'Intentaste ver el resultado sin escribir nada. Alfred no está orgulloso de ti.',
                    );
                  }

                  setState(() {
                    mostrarResultado = true;
                  });
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Mostrar Texto'),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),
              
              // 4. El botón de broma definitivo
              ElevatedButton(
                onPressed: () {
                  _lanzarNotificacion(
                    id: 4,
                    titulo: '🚨 ¡BATISEÑAL ACTIVADA! 🚨',
                    cuerpo: 'El Comisionado Gordon reporta que rompiste el botón de broma. ¡A los bati-móviles!',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded),
                    SizedBox(width: 8),
                    Text(
                      'BOTÓN SECRETO (NO TOCAR)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultado() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'absolute-batman-wraparound-variant-by-clay-seth-mann-v0-694w8mit4yjg1.webp',
                width: MediaQuery.of(context).size.width * 0.6 * imageScale,
                height: MediaQuery.of(context).size.height * 0.4 * imageScale,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                textoController.text.isEmpty
                    ? 'NO ESCRIBISTE NADA'
                    : textoController.text.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: checkboxValue ? 62 : 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    mostrarResultado = false;
                    textoController.clear();
                  });
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}