import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const String _validUsername = 'admin';
  static const String _validPasswordHash =
      '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9';

  String _emailError = '';
  String _passwordError = '';
  String _termsError = '';
  bool _acceptedTerms = false;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndLogin() {
    String emailError = '';
    String passwordError = '';
    String termsError = '';
    bool isValid = true;

    if (_emailController.text.isEmpty) {
      emailError = 'El usuario es obligatorio';
      isValid = false;
    } else if (_emailController.text.trim() != _validUsername) {
      emailError = 'Usuario incorrecto';
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      passwordError = 'La contraseña es obligatoria';
      isValid = false;
    } else if (_hashPassword(_passwordController.text) != _validPasswordHash) {
      passwordError = 'Contraseña incorrecta';
      isValid = false;
    }

    if (!_acceptedTerms) {
      termsError = 'Debes aceptar los términos y condiciones';
      isValid = false;
    }

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _termsError = termsError;
    });

    if (!isValid) {
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
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Usuario",
                ),
              ),
              if (_emailError.isNotEmpty)
                Text(
                  _emailError,
                  style: const TextStyle(color: Colors.red),
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
                Text(
                  _passwordError,
                  style: const TextStyle(color: Colors.red),
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
                    }
                  });
                },
              ),
              if (_termsError.isNotEmpty)
                Text(
                  _termsError,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateAndLogin,
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}