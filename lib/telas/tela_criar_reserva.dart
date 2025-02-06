import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../servicos/firebase_servico.dart';
import 'tela_principal.dart';

class TelaCriarReserva extends StatefulWidget {
  final String codigoAtivacao;
  const TelaCriarReserva({Key? key, required this.codigoAtivacao}) : super(key: key);

  @override
  _TelaCriarReservaState createState() => _TelaCriarReservaState();
}

class _TelaCriarReservaState extends State<TelaCriarReserva> {
  final FirebaseServico firebaseServico = FirebaseServico();
  String errorMessage = '';
  String? codigoReserva;

  @override
  void initState() {
    super.initState();
    _criarReserva();
  }

  Future<void> _criarReserva() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? reserva = await firebaseServico.ativarCodigoDeReserva(widget.codigoAtivacao);
      if (reserva != null) {
        setState(() {
          codigoReserva = reserva;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao criar a reserva. Tente novamente.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reserva Criada")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: codigoReserva == null
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Código da Reserva:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SelectableText(
                codigoReserva!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TelaPrincipal()));
                },
                child: const Text("Ir para Tela Principal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
