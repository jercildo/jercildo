
import 'package:flutter/material.dart';

class TelaCodigoAtivacao extends StatefulWidget {
  final String user;
  const TelaCodigoAtivacao({Key? key, required this.user}) : super(key: key);

  @override
  _TelaCodigoAtivacaoState createState() => _TelaCodigoAtivacaoState();
}

class _TelaCodigoAtivacaoState extends State<TelaCodigoAtivacao> {
  final TextEditingController codigoController = TextEditingController();
  String errorMessage = '';

  Future<void> validarCodigo() async {
    setState(() {
      errorMessage = ''; // Resetando erro
    });

    if (codigoController.text == "12345ABC") {
      Navigator.pushNamed(context, '/tela_escolha_autenticacao');
    } else {
      setState(() {
        errorMessage = 'Código de ativação inválido!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Código de Ativação")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codigoController,
              decoration: const InputDecoration(labelText: 'Código de Ativação'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: validarCodigo,
              child: const Text("Validar Código"),
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
