import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool aceptaTerminos = false;

  final RegExp emailRegex =
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Correo inválido"),
        ),
      );
      return;
    }

    if (password.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mínimo 9 caracteres"),
        ),
      );
      return;
    }

    if (!aceptaTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Debes aceptar los términos"),
        ),
      );
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
      builder: (_) => AlertDialog(
        title: const Text(
          "Términos y Condiciones",
        ),
        content: const Text(
          "Al utilizar esta aplicación aceptas los términos y condiciones.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cerrar"),
          ),
        ],
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
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                ),
              ),

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
    );
  }
}