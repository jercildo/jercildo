import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_registro.dart';

class TelaEscolhaAutenticacao extends StatelessWidget {
  final String codigoReserva;

  const TelaEscolhaAutenticacao({Key? key, required this.codigoReserva}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha uma Opção")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Você inseriu um código válido! Agora escolha como deseja continuar.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TelaLogin(codigoReserva: "codigo_exemplo")),
                );
              },
              child: const Text("Criar uma Conta"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TelaRegistro(codigoReserva: "codigo_exemplo")),
                );
              },
              child: const Text("Fazer Login"),
            ),
          ],
        ),
      ),
    );
  }
}
