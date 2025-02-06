import 'package:flutter/material.dart';

class TelaOperador extends StatelessWidget {
  const TelaOperador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Operador - Cautela e Descautela")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para cautela de itens
              },
              child: const Text("Realizar Cautela"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para descautela de itens
              },
              child: const Text("Realizar Descautela"),
            ),
          ],
        ),
      ),
    );
  }
}
