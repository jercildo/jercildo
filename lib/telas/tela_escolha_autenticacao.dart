import 'package:flutter/material.dart';

class TelaEscolhaAutenticacao extends StatelessWidget {
  final String reservaId;

  const TelaEscolhaAutenticacao({Key? key, required this.reservaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha de Autenticação")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reserva confirmada! ID: $reservaId",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicionar lógica para seguir para login ou cadastro
              },
              child: const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
