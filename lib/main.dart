import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:upgrader/upgrader.dart'; // 1. Importación del paquete upgrader
import 'login_page.dart';

void main() async {
  // Asegura que los bindings de Flutter estén listos antes de inicializar servicios nativos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de la base de datos para Windows
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.brown,
      ),
      // 2. Envolvemos la LoginPage con UpgradeAlert para activar las alertas de actualización
      home: UpgradeAlert(
        upgrader: Upgrader(
        
          debugLogging: kDebugMode, // Solo muestra registros de depuración en consola si estás en modo debug
        ),
        child: const LoginPage(),
      ),
    );
  }
}