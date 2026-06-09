import 'package:flutter/material.dart';

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
      home: const HomePage(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.auto_awesome,
          size: 80,
        ),

        const SizedBox(height: 20),

        Text(
          textoController.text.isEmpty
              ? "NO ESCRIBISTE NADA"
              : textoController.text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: checkboxValue ? 42 : 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 40),

        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              mostrarResultado = false;
            });
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text("Volver"),
        ),
      ],
    );
  }
}