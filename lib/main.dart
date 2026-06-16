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
  // Controladores de entrada.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Estado del formulario.
  bool aceptaTerminos = false;
  String? emailError;
  String? passwordError;
  String? terminosError;

  // Regex basica para validar correo.
  final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void iniciarSesion() {
    // Lee y limpia los datos del formulario.
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    setState(() {
      // Reinicia los errores antes de validar.
      emailError = null;
      passwordError = null;
      terminosError = null;

      if (!emailRegex.hasMatch(email)) {
        emailError = "Ingresa un correo válido";
      }

      if (password.length < 9) {
        passwordError = "Minimo 9 caracteres";
      }

      if (!aceptaTerminos) {
        terminosError = "Debes aceptar los términos";
      }
    });

    if (emailError != null || passwordError != null || terminosError != null) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          // Contenedor simple y centrado del formulario.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Card(
              elevation: 0,
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo de correo con error en linea.
                    TextField(
                      controller: emailController,
                      onChanged: (_) {
                        if (emailError != null) {
                          setState(() {
                            emailError = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Correo",
                        border: const OutlineInputBorder(),
                        errorText: emailError,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Campo de contrasena con longitud minima.
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (_) {
                        if (passwordError != null) {
                          setState(() {
                            passwordError = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: const OutlineInputBorder(),
                        errorText: passwordError,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Checkbox de terminos.
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      value: aceptaTerminos,
                      title: const Text("Acepto los terminos y condiciones"),
                      onChanged: (value) {
                        setState(() {
                          aceptaTerminos = value ?? false;
                          terminosError = null;
                        });
                      },
                    ),
                    if (terminosError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 2),
                        child: Text(
                          terminosError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    // Enlace al modal de terminos.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: mostrarTerminos,
                        child: const Text("Ver términos y condiciones"),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Boton de envio del formulario.
                    ElevatedButton(
                      onPressed: iniciarSesion,
                      child: const Text("Iniciar Sesión"),
                    ),
                  ],
                ),
              ),
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