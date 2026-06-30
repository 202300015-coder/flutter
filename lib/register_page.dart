import 'package:flutter/material.dart';

import 'auth_database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _formError = '';
  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  bool _isSaving = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  Future<void> _registerUser() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    String usernameError = '';
    String emailError = '';
    String passwordError = '';
    String confirmPasswordError = '';
    bool isValid = true;

    if (username.isEmpty) {
      usernameError = 'El usuario es obligatorio';
      isValid = false;
    }

    if (email.isEmpty) {
      emailError = 'El correo es obligatorio';
      isValid = false;
    } else if (!_isValidEmail(email)) {
      emailError = 'Ingresa un correo válido';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError = 'La contraseña es obligatoria';
      isValid = false;
    } else if (password.length < 4) {
      passwordError = 'La contraseña debe tener al menos 4 caracteres';
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Confirma la contraseña';
      isValid = false;
    } else if (confirmPassword != password) {
      confirmPasswordError = 'Las contraseñas no coinciden';
      isValid = false;
    }

    setState(() {
      _formError = '';
      _usernameError = usernameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmPasswordError;
    });

    if (!isValid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final created = await AuthDatabase.instance
          .registerUser(
            username: username,
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) {
        return;
      }

      if (!created) {
        setState(() {
          _formError = 'Ese usuario o correo ya existe';
        });
        return;
      }

      Navigator.pop(
        context,
        email,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _formError = 'No se pudo registrar. Intenta de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
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
                  hintText: 'Usuario',
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Correo',
                ),
              ),
              if (_emailError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _emailError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
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
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirmar contraseña',
                ),
              ),
              if (_confirmPasswordError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _confirmPasswordError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null : _registerUser,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Registrarme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
