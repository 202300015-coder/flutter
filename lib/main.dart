import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF111827),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool aceptaTerminos = false;

  final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void iniciarSesion() {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (!emailRegex.hasMatch(email)) {
      mostrarMensaje("El correo debe contener @");
      return;
    }

    if (password.length < 6) {
      mostrarMensaje("La contraseña debe tener al menos 6 caracteres");
      return;
    }

    if (!aceptaTerminos) {
      mostrarMensaje("Debes aceptar los términos y condiciones");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void mostrarTerminos() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Términos y Condiciones"),
          content: const SingleChildScrollView(
            child: Text(
              "Al utilizar esta aplicación aceptas "
              "las condiciones de uso establecidas "
              "para fines académicos.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cerrar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Correo",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                CheckboxListTile(
                  value: aceptaTerminos,
                  title: const Text(
                    "Acepto los términos y condiciones",
                  ),
                  onChanged: (value) {
                    setState(() {
                      aceptaTerminos = value!;
                    });
                  },
                ),

                TextButton(
                  onPressed: mostrarTerminos,
                  child: const Text(
                    "Ver términos y condiciones",
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: iniciarSesion,
                  child: const Text(
                    "Iniciar Sesión",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textoController = TextEditingController();

  bool mostrarResultado = false;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi App"),
        centerTitle: true,
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
            child: mostrarResultado
                ? _buildResultado()
                : _buildFormulario(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Card(
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
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Batman, en su versión más brutal",
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
                labelText: "Escribe tu texto",
                hintText: "Ingresa algo aquí...",
                prefixIcon: const Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            CheckboxListTile(
              title: const Text("Activar modo destacado"),
              value: checkboxValue,
              onChanged: (value) {
                setState(() {
                  checkboxValue = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                debugPrint(
                  "Texto: ${textoController.text} - Checkbox: $checkboxValue",
                );

                setState(() {
                  mostrarResultado = true;
                });
              },
              icon: const Icon(Icons.visibility),
              label: const Text("Mostrar Texto"),
            ),
          ],
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
              Image.file(
                File(r'C:\Users\User-PC\Documents\GitHub\proyecto-202300015-coder\flutter\absolute scarecraw.webp'),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              Text(
                textoController.text.isEmpty
                    ? "NO ESCRIBISTE NADA"
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
                label: const Text("Volver"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}