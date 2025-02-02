import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'telas/tela_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Reserva',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _codigoAtivacaoController = TextEditingController();
  final TextEditingController _codigoReservaController = TextEditingController();
  String _mensagemErro = '';
  bool _carregandoAtivacao = false;
  bool _carregandoReserva = false;

  /// **Função para validar código de ativação**
  Future<void> _validarCodigoAtivacao() async {
    String codigoAtivacao = _codigoAtivacaoController.text.trim();
    if (codigoAtivacao.isEmpty) {
      setState(() {
        _mensagemErro = 'Por favor, insira um código de ativação.';
      });
      return;
    }

    setState(() {
      _carregandoAtivacao = true;
      _mensagemErro = '';
    });

    try {
      print("Verificando código de ativação: $codigoAtivacao");

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('codigos_ativacao')
          .doc(codigoAtivacao)
          .get();

      if (!doc.exists) {
        setState(() {
          _mensagemErro = 'Código de ativação inválido.';
          _carregandoAtivacao = false;
        });
        return;
      }

      print("Código de ativação encontrado!");

      // Redirecionar para tela de login/registro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin(codigoAtivacao: codigoAtivacao)),
      );
    } catch (e) {
      print("Erro ao validar código de ativação: $e");
      setState(() {
        _mensagemErro = 'Erro ao validar o código. Tente novamente.';
        _carregandoAtivacao = false;
      });
    }
  }

  /// **Função para validar código de reserva**
  Future<void> _validarCodigoReserva() async {
    String codigoReserva = _codigoReservaController.text.trim();
    if (codigoReserva.isEmpty) {
      setState(() {
        _mensagemErro = 'Por favor, insira um código de reserva.';
      });
      return;
    }

    setState(() {
      _carregandoReserva = true;
      _mensagemErro = '';
    });

    try {
      print("Verificando código de reserva: $codigoReserva");

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('reservas')
          .doc(codigoReserva)
          .get();

      if (!doc.exists) {
        setState(() {
          _mensagemErro = 'Código de reserva inválido.';
          _carregandoReserva = false;
        });
        return;
      }

      print("Código de reserva encontrado!");

      // Redirecionar para tela de login/registro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin(codigoReserva: codigoReserva)),
      );
    } catch (e) {
      print("Erro ao validar código de reserva: $e");
      setState(() {
        _mensagemErro = 'Erro ao verificar o código.';
        _carregandoReserva = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem-vindo ao Sistema de Reservas")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Digite o código de ativação ou código da reserva:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: _codigoAtivacaoController,
              decoration: InputDecoration(
                labelText: "Código de Ativação",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _carregandoAtivacao ? null : _validarCodigoAtivacao,
              child: _carregandoAtivacao ? CircularProgressIndicator() : Text("Validar Código de Ativação"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codigoReservaController,
              decoration: InputDecoration(
                labelText: "Código da Reserva",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _carregandoReserva ? null : _validarCodigoReserva,
              child: _carregandoReserva ? CircularProgressIndicator() : Text("Validar Código da Reserva"),
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
