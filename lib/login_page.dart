import 'package:flutter/material.dart';

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

  String _formError = '';
  String _usernameError = '';
  String _passwordError = '';
  String _termsError = '';
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndLogin() async {
    String usernameError = '';
    String passwordError = '';
    String termsError = '';
    bool isValid = true;

    if (_usernameController.text.isEmpty) {
      usernameError = 'El usuario es obligatorio';
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      passwordError = 'La contraseña es obligatoria';
      isValid = false;
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
              ElevatedButton(
                onPressed: _validateAndLogin,
                child: const Text("Entrar"),
              ),
              TextButton(
                onPressed: _openRegisterPage,
                child: const Text('No tienes cuenta? Registrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}