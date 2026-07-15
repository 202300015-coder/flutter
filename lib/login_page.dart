import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importante para las notificaciones
import 'auth_database.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  String _formError = '';
  String _usernameError = '';
  String _passwordError = '';
  String _termsError = '';
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _initNotifications(); // Inicializamos el motor al cargar el login
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Inicializa las notificaciones locales y PIDE PERMISOS en Android 13+
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // SOLUCIÓN: Esto obliga a Android a mostrarte la ventana flotante de "Permitir Notificaciones"
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // Función interna para lanzar las bati-alertas
  Future<void> _lanzarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'canal_login', 
      'Alertas de Inicio de Sesión',
      channelDescription: 'Notificaciones graciosas de acceso a la baticueva',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id: id,
      title: titulo,
      body: cuerpo,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<void> _validateAndLogin() async {
    String usernameError = '';
    String passwordError = '';
    String termsError = '';
    bool isValid = true;

    if (_usernameController.text.isEmpty) {
      usernameError = 'El usuario es obligatorio';
      isValid = false;
      
      // 1. Notificación: No completó el correo
      _lanzarNotificacion(
        id: 10,
        titulo: '✉️ ¿Y el correo, recluta?',
        cuerpo: 'Batman no puede identificarte en los servidores si dejas el correo vacío.',
      );
    } else {
      // 2. Notificación: Correo ingresado exitosamente
      _lanzarNotificacion(
        id: 11,
        titulo: '✅ Identidad detectada',
        cuerpo: 'Hemos registrado el correo: ${_usernameController.text.trim()}. Buscando antecedentes...',
      );
    }

    if (_passwordController.text.isEmpty) {
      passwordError = 'La contraseña es obligatoria';
      isValid = false;

      // 3. Notificación: No completó la contraseña
      _lanzarNotificacion(
        id: 12,
        titulo: '🔑 ¡Acceso Denegado!',
        cuerpo: 'La baticueva requiere de un código de acceso. ¡Escribe la contraseña!',
      );
    }

    if (!_acceptedTerms) {
      termsError = 'Debes aceptar los términos y condiciones';
      isValid = false;
    }

    setState(() {
      _formError = '';
      _usernameError = usernameError;
      _passwordError = passwordError;
      _termsError = termsError;
    });

    if (!isValid) {
      return;
    }

    bool loggedIn = false;
    try {
      loggedIn = await AuthDatabase.instance
          .loginUser(
            email: _usernameController.text.trim(),
            password: _passwordController.text,
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _formError = 'No se pudo iniciar sesión. Intenta de nuevo.';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    if (!loggedIn) {
      setState(() {
        _formError = 'Correo o contraseña incorrectos';
      });
      return;
    }

    debugPrint('Login correcto');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  Future<void> _openRegisterPage() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _usernameController.text = result;
      _passwordController.clear();
      _acceptedTerms = false;
      _usernameError = '';
      _passwordError = '';
      _termsError = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Se registró correctamente. Ahora inicia sesión.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              if (_formError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _formError,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "Correo",
                ),
              ),
              if (_usernameError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _usernameError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Contraseña",
                ),
              ),
              if (_passwordError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _passwordError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _acceptedTerms,
                title: const Text(
                  "Acepto términos y condiciones",
                ),
                onChanged: (value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                    if (_acceptedTerms) {
                      _termsError = '';
                      // 4. Notificación de Reclutamiento Militar al aceptar los términos
                      _lanzarNotificacion(
                        id: 13,
                        titulo: '🪖 ¡OFICIALMENTE RECLUTADO! 🪖',
                        cuerpo: 'Al aceptar los términos, acabas de alistarte en la guerra contra el crimen de Gotham. ¡No hay vuelta atrás!',
                      );
                    }
                  });
                },
              ),
              if (_termsError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _termsError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              
              // BOTÓN PARA ENTRAR
              ElevatedButton(
                onPressed: _validateAndLogin,
                child: const Text("Entrar"),
              ),
              
              const SizedBox(height: 10),

              // 5. NUEVO BOTÓN EXCLUSIVO PARA DISPARAR NOTIFICACIÓN MANUAL
              OutlinedButton.icon(
                onPressed: () {
                  _lanzarNotificacion(
                    id: 14,
                    titulo: '📢 ¡Probando megáfono de la baticueva!',
                    cuerpo: 'La bati-señal está en perfecto estado. Las notificaciones funcionan de maravilla.',
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text("Probar Notificación"),
              ),

              TextButton(
                onPressed: _openRegisterPage,
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}