import 'package:flutter/material.dart';
import 'tela_principal.dart';

class TelaCodigoAtivacao extends StatefulWidget {
  final String user;

  TelaCodigoAtivacao({Key? key, required this.user}) : super(key: key);

  @override
  _TelaCodigoAtivacaoState createState() => _TelaCodigoAtivacaoState();
}

class _TelaCodigoAtivacaoState extends State<TelaCodigoAtivacao> {
  final TextEditingController _codigoController = TextEditingController();
  String _mensagemErro = '';

  @override
  void dispose() {
    _codigoController.dispose(); // Libera o controlador ao sair da tela
    super.dispose();
  }

  void _validarCodigo() {
    String codigoInserido = _codigoController.text.trim();

    if (codigoInserido.isEmpty) {
      setState(() {
        _mensagemErro = 'Por favor, insira um código.';
      });
      return;
    }

    if (codigoInserido.length < 7) {
      setState(() {
        _mensagemErro = 'Código muito curto. Verifique e tente novamente.';
      });
      return;
    }

    if (codigoInserido == "12345ABC") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaPrincipal()),
      );
    } else {
      setState(() {
        _mensagemErro = 'Código inválido. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ativação do Código")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Insira o código de ativação recebido:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _codigoController,
              decoration: InputDecoration(
                labelText: "Código de Ativação",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _validarCodigo,
              child: Text("Validar Código"),
            ),
            if (_mensagemErro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _mensagemErro,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
