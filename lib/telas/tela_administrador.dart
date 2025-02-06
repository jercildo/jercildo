import 'package:flutter/material.dart';

class TelaAdministrador extends StatelessWidget {
  const TelaAdministrador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Administrador - Gerenciamento")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para aprovação de armeiros
              },
              child: const Text("Aprovar Novos Armeiros"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para gerenciar usuários
              },
              child: const Text("Gerenciar Usuários"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica para ver relatórios do sistema
              },
              child: const Text("Visualizar Relatórios"),
            ),
          ],
        ),
      ),
    );
  }
}
