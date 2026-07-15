import 'dart:async';
import 'package:flutter/foundation.dart'; // Requerido para usar compute
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

  // --- VARIABLES PARA EL BATI-LABORATORIO ---
  Timer? _batiTimer;
  int _contadorTimer = 0;
  String _resultadoAsyncAwait = "Esperando que inicies la prueba...";
  bool _cargandoAsyncAwait = false;
  String _resultadoIsolate = "Esperando procesamiento pesado...";
  bool _cargandoIsolate = false;

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

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

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
      'canal_bromas',
      'Alertas de la Baticueva',
      channelDescription: 'Canal para notificaciones divertidas y del sistema',
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

  // --- MÉTODOS ASÍNCRONOS REQUERIDOS ---

  // 1. Simulación de carga para el Future.builder
  Future<String> _obtenerDatosDeLaBaticomputadora() async {
    await Future.delayed(const Duration(seconds: 3));
    return "¡Bati-Datos cargados con éxito! El Guasón está en el asilo Arkham.";
  }

  // 2. Implementación explícita de async / await
  Future<void> _ejecutarAccionAsyncAwait() async {
    setState(() {
      _cargandoAsyncAwait = true;
      _resultadoAsyncAwait = "Conectando con el satélite de Industrias Wayne...";
    });

    // Simulando una petición de red con await
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _resultadoAsyncAwait = "¡Señal encriptada recibida! Alfred dice que la cena está lista.";
      _cargandoAsyncAwait = false;
    });
  }

  // 3. Implementación de un Isolate usando compute (tarea pesada en hilo secundario)
  // NOTA: La función que recibe 'compute' DEBE ser una función global o estática.
  static int _tareaPesadaIsolate(int iteraciones) {
    // Simulamos un cálculo matemático intensivo en CPU que congelaría la UI principal
    int resultado = 0;
    for (int i = 0; i < iteraciones; i++) {
      resultado += i;
    }
    return resultado;
  }

  Future<void> _ejecutarTareaPesadaEnIsolate() async {
    setState(() {
      _cargandoIsolate = true;
      _resultadoIsolate = "Calculando trayectorias en un hilo separado (Isolate)...";
    });

    // compute() envía la ejecución de '_tareaPesadaIsolate' a un Isolate secundario de fondo
    final resultadoCalculado = await compute(_tareaPesadaIsolate, 100000000);

    setState(() {
      _resultadoIsolate = "Cálculo terminado en Isolate. Sumatoria: $resultadoCalculado";
      _cargandoIsolate = false;
    });
  }

  // 4. Implementación de Timer (Timer.periodic)
  void _iniciarBatiTimer() {
    _detenerBatiTimer(); // Limpia cualquier timer previo activo para evitar duplicados
    _contadorTimer = 0;
    _batiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _contadorTimer++;
      });
    });
  }

  void _detenerBatiTimer() {
    if (_batiTimer != null) {
      _batiTimer!.cancel();
      _batiTimer = null;
    }
  }

  @override
  void dispose() {
    textoController.dispose();
    _detenerBatiTimer(); // Muy importante cancelar timers para evitar fugas de memoria
    super.dispose();
  }

  
  void _mostrarModalLaboratorio() {
    // Iniciamos el Timer al abrir el modal para que se vea en tiempo real
    _iniciarBatiTimer();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        // Usamos StateSetter para actualizar el modal si es necesario,
        // o simplemente confiamos en el setState de la página que redibuja la vista si está enlazada.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        '🔬 Bati-Laboratorio Asíncrono 🧪',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(height: 30),

                    // --- SECCIÓN 1: TIMER.PERIODIC ---
                    _buildSeccionTitulo("⏰ 1. IMPLEMENTACIÓN: Timer.periodic"),
                    const Text(
                      "Este cronómetro se actualiza de fondo cada segundo usando un Timer periódico.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bati-Segundos Transcurridos: $_contadorTimer",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                _iniciarBatiTimer();
                              });
                            },
                            child: const Text("Reiniciar"),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- SECCIÓN 2: FUTURE.BUILDER ---
                    _buildSeccionTitulo("🧱 2. IMPLEMENTACIÓN: Future.builder"),
                    const Text(
                      "Carga datos asíncronos directamente en la UI controlando sus estados.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<String>(
                      future: _obtenerDatosDeLaBaticomputadora(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Card(
                            color: Colors.blueGrey,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CircularProgressIndicator(color: Colors.white),
                                  SizedBox(width: 15),
                                  Text("Cargando Future.builder...", style: TextStyle(color: Colors.white))
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Text(
                              "${snapshot.data}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // --- SECCIÓN 3: ASYNC / AWAIT ---
                    _buildSeccionTitulo("⚡ 3. IMPLEMENTACIÓN: Async / Await"),
                    const Text(
                      "Ejecuta flujos secuenciales asíncronos esperando que terminen para continuar.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _cargandoAsyncAwait
                              ? null
                              : () async {
                                  await _ejecutarAccionAsyncAwait();
                                  setModalState(() {});
                                },
                          child: const Text("Iniciar await"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _resultadoAsyncAwait,
                            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- SECCIÓN 4: COMPUTE / ISOLATE ---
                    _buildSeccionTitulo("🚀 4. IMPLEMENTACIÓN: Compute / Isolate"),
                    const Text(
                      "Ejecuta un loop pesado (100 millones de ciclos) en otro hilo sin trabar la interfaz.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _cargandoIsolate
                              ? null
                              : () async {
                                  await _ejecutarTareaPesadaEnIsolate();
                                  setModalState(() {});
                                },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                          child: const Text("Procesar Isolate"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _resultadoIsolate,
                            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Botón para cerrar el modal
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _detenerBatiTimer();
                          Navigator.pop(context);
                        },
                        child: const Text("Cerrar Laboratorio"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      // Nos aseguramos de detener el timer si se cierra arrastrando hacia abajo
      _detenerBatiTimer();
    });
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
      ),
    );
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
              const SizedBox(height: 15),

              // --- BOTÓN PRINCIPAL DEL BATI-LABORATORIO ASÍNCRONO ---
              ElevatedButton.icon(
                onPressed: _mostrarModalLaboratorio,
                icon: const Icon(Icons.science),
                label: const Text('PROBAR LAB ASÍNCRONO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 10),

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