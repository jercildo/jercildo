import 'package:flutter/material.dart';
import 'tela_operador.dart';
import 'tela_armeiro.dart';
import 'tela_administrador.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha sua Função")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const TelaOperador()));
              },
              child: const Text("Sou Operador"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const TelaArmeiro()));
              },
              child: const Text("Sou Armeiro"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const TelaAdministrador()));
              },
              child: const Text("Sou Administrador"),
            ),
          ],
        ),
      ),
    );
  }
}
