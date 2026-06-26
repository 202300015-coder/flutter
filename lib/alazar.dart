import 'package:flutter/material.dart';

class AlazarPage extends StatefulWidget {
	const AlazarPage({super.key});

	@override
	State<AlazarPage> createState() => _AlazarPageState();
}

class _AlazarPageState extends State<AlazarPage> {
	double valorSlider = 120;
	bool encendido = false;
	Color colorActual = Colors.red;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Alazar'),
				centerTitle: true,
			),
			body: Center(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(20),
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							Container(
								width: valorSlider,
								height: valorSlider,
								decoration: BoxDecoration(
									color: encendido ? colorActual : Colors.grey,
									shape: BoxShape.circle,
								),
							),
							const SizedBox(height: 20),
							Text('Tamaño: ${valorSlider.toInt()}'),
							Slider(
								value: valorSlider,
								min: 60,
								max: 220,
								onChanged: (value) {
									setState(() {
										valorSlider = value;
									});
								},
							),
							SwitchListTile(
								value: encendido,
								title: Text(encendido ? 'Encendido' : 'Apagado'),
								onChanged: (value) {
									setState(() {
										encendido = value;
									});
								},
							),
							const SizedBox(height: 10),
							Wrap(
								spacing: 10,
								children: [
									_colorButton('Rojo', Colors.red),
									_colorButton('Verde', Colors.green),
									_colorButton('Azul', Colors.blue),
									_colorButton('Amarillo', Colors.amber),
								],
							),
							const SizedBox(height: 25),
							ElevatedButton(
								onPressed: () {
									Navigator.pop(context);
								},
								child: const Text('Salir'),
							),
						],
					),
				),
			),
		);
	}

	Widget _colorButton(String texto, Color color) {
		return ElevatedButton(
			style: ElevatedButton.styleFrom(backgroundColor: color),
			onPressed: () {
				setState(() {
					colorActual = color;
				});
			},
			child: Text(texto),
		);
	}
}
