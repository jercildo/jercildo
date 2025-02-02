
import 'package:flutter/material.dart';

class TelaRegistro extends StatefulWidget {
  final String codigoReserva;
  const TelaRegistro({Key? key, required this.codigoReserva}) : super(key: key);

  @override
  _TelaRegistroState createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String errorMessage = '';

  Future<void> _registrar() async {
    setState(() {
      errorMessage = ''; // Resetando erro
    });

    if (nomeController.text.isNotEmpty && emailController.text.isNotEmpty && senhaController.text.length >= 6) {
      Navigator.pushNamed(context, '/tela_principal');
    } else {
      setState(() {
        errorMessage = 'Erro no registro. Verifique os dados preenchidos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome Completo'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrar,
              child: const Text("Registrar"),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
