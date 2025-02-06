import 'package:flutter/material.dart';

class TelaArmeiro extends StatelessWidget {
  const TelaArmeiro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Armeiro - Gestão de Itens")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para aprovar cautelas
              },
              child: const Text("Autorizar Cautela"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para receber descautela
              },
              child: const Text("Receber Descautela"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para cadastrar novos itens
              },
              child: const Text("Cadastrar Novo Item"),
            ),
          ],
        ),
      ),
    );
  }
}
