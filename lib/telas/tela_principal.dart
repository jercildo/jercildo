import 'package:flutter/material.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Principal")),
      body: Center(
        child: Text(
          "Bem-vindo à tela principal!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
