import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'telas/tela_login.dart';
import 'telas/tela_codigo_ativacao.dart';
import 'telas/tela_principal.dart';
import 'telas/tela_escolher_funcao.dart';

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
      title: 'Reserva de Arma',
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
  bool carregando = false;

  /// Gera um código aleatório para a reserva
  String _gerarCodigoReserva() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
    );
  }

  /// Função para criar uma nova reserva (Administrador)
  void _criarReserva() async {
    String codigoAtivacao = _codigoAtivacaoController.text.trim();

    if (codigoAtivacao.isEmpty) {
      setState(() => _mensagemErro = 'Por favor, insira um código de ativação.');
      return;
    }

    setState(() => carregando = true);

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('codigos_ativacao').doc(codigoAtivacao).get();

      if (!doc.exists) {
        setState(() {
          _mensagemErro = 'Código de ativação inválido.';
          carregando = false;
        });
        return;
      }

      Map<String, dynamic>? dadosAtivacao = doc.data() as Map<String, dynamic>?;

      if (dadosAtivacao?['usado'] == true) {
        setState(() {
          _mensagemErro = 'Este código de ativação já foi utilizado.';
          carregando = false;
        });
        return;
      }

      // Gerar um novo código de reserva
      String codigoReserva = _gerarCodigoReserva();

      // Criar a nova reserva no banco de dados
      await FirebaseFirestore.instance.collection('reservas').doc(codigoReserva).set({
        'administrador': FirebaseAuth.instance.currentUser?.uid ?? "Administrador",
        'data_criacao': Timestamp.now(),
      });

      // Marcar o código de ativação como usado somente após a criação da reserva
      await FirebaseFirestore.instance.collection('codigos_ativacao').doc(codigoAtivacao).update({
        'usado': true,
        'utilizado_por': FirebaseAuth.instance.currentUser?.uid ?? "Administrador",
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TelaPrincipal()));
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao criar a reserva. Tente novamente.';
        carregando = false;
      });
    }
  }

  /// Função para validar um código de reserva existente
  void _validarReserva() async {
    String codigoReserva = _codigoReservaController.text.trim();

    if (codigoReserva.isEmpty) {
      setState(() => _mensagemErro = 'Por favor, insira um código de reserva.');
      return;
    }

    setState(() => carregando = true);

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('reservas').doc(codigoReserva).get();

      if (!doc.exists) {
        setState(() {
          _mensagemErro = 'Código de reserva inválido.';
          carregando = false;
        });
        return;
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TelaLogin(codigoReserva: codigoReserva)));
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao verificar o código.';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('usuarios').doc(snapshot.data!.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (userSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Erro ao carregar os dados do usuário')),
                );
              }

              Map<String, dynamic>? userData = userSnapshot.data?.data() as Map<String, dynamic>?;

              if (userData != null && userData.containsKey('reserva_atual')) {
                return TelaPrincipal();
              } else {
                return Scaffold(
                  appBar: AppBar(title: Text("Bem-vindo ao Sistema de Reservas")),
                  body: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Escolha uma opção:", style: TextStyle(fontSize: 18)),
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
                          onPressed: carregando ? null : _criarReserva,
                          child: carregando ? CircularProgressIndicator() : Text("Criar Reserva"),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _codigoReservaController,
                          decoration: InputDecoration(
                            labelText: "Código de Reserva",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: carregando ? null : _validarReserva,
                          child: carregando ? CircularProgressIndicator() : Text("Entrar na Reserva"),
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
            },
          );
        } else {
          return TelaLogin(codigoReserva: "codigo_padrao");
        }
      },
    );
  }
}
