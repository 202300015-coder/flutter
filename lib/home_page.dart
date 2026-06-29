import 'package:flutter/material.dart';
import 'alazar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textoController = TextEditingController();

  bool mostrarResultado = false;
  bool checkboxValue = false;
  double imageScale = 1.0;

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
                  builder: (_) => const AlazarPage(),
                ),
              );
            },
            child: const Text('Nuevo'),
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

                  setState(() {
                    mostrarResultado = true;
                  });
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Mostrar Texto'),
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