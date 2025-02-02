
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  final String codigoReserva;
  const TelaLogin({Key? key, required this.codigoReserva}) : super(key: key);

    @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String errorMessage = '';

  Future<void> _login() async {
    setState(() {
      errorMessage = ''; // Resetando mensagem de erro
    });

    // Lógica de login (simulada)
    if (emailController.text.isNotEmpty && senhaController.text.length >= 6) {
      Navigator.pushNamed(context, '/tela_principal');
    } else {
      setState(() {
        errorMessage = 'Erro ao fazer login. Verifique suas credenciais.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onPressed: _login,
              child: const Text("Entrar"),
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
