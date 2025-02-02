import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'telas/tela_login.dart';
import 'telas/tela_codigo_ativacao.dart';
import 'telas/tela_principal.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _codigoReservaController = TextEditingController();
  String _mensagemErro = '';

  /// **Função para validar o código de reserva**
  void _validarCodigo() async {
    String codigoInserido = _codigoReservaController.text.trim();

    if (codigoInserido.isEmpty) {
      setState(() {
        _mensagemErro = 'Por favor, insira um código de reserva.';
      });
      return;
    }

    try {
      DocumentSnapshot reserva = await FirebaseFirestore.instance
          .collection('codigos_ativacao')
          .doc(codigoInserido)
          .get();

      if (!reserva.exists) {
        setState(() {
          _mensagemErro = 'Código de reserva inválido.';
        });
        return;
      }

      Map<String, dynamic>? dadosReserva = reserva.data() as Map<String, dynamic>?;

      if (dadosReserva == null || !dadosReserva.containsKey('usado')) {
        setState(() {
          _mensagemErro = 'Erro ao validar o código. Tente novamente.';
        });
        return;
      }

      if (dadosReserva['usado'] == true) {
        setState(() {
          _mensagemErro = 'Este código já foi utilizado.';
        });
        return;
      }

      // Atualiza o Firestore para marcar o código como usado
      await FirebaseFirestore.instance
          .collection('codigos_ativacao')
          .doc(codigoInserido)
          .update({
        'usado': true,
        'utilizado_por': FirebaseAuth.instance.currentUser?.uid ?? "Desconhecido",
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaPrincipal()),
      );
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao verificar o código. Tente novamente.';
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
            future: FirebaseFirestore.instance
                .collection('usuarios')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (userSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Erro ao carregar os dados do usuário')),
                );
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return TelaCodigoAtivacao(user: snapshot.data!.uid);
              }

              // **Correção aqui: Obtendo os dados corretamente**
              var userData = userSnapshot.data?.data() as Map<String, dynamic>?;

              if (userData != null && userData.containsKey('reserva_atual')) {
                return TelaPrincipal();
              } else {
                return Scaffold(
                  appBar: AppBar(title: Text("Reserva de Arma")),
                  body: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Insira seu código de reserva:",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _codigoReservaController,
                          decoration: InputDecoration(
                            labelText: "Código",
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
            },
          );
        } else {
          return TelaLogin(codigoReserva: "codigo_padrao");
        }
      },
    );
  }
}
