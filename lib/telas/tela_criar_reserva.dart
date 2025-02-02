import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../servicos/firebase_servico.dart';
import 'tela_principal.dart';

class TelaCriarReserva extends StatefulWidget {
  final String codigoAtivacao;
  const TelaCriarReserva({Key? key, required this.codigoAtivacao}) : super(key: key); // Adicionando `super.key`

  @override
  _TelaCriarReservaState createState() => _TelaCriarReservaState();
}

class _TelaCriarReservaState extends State<TelaCriarReserva> {
  final TextEditingController nomeReservaController = TextEditingController();
  final FirebaseServico firebaseServico = FirebaseServico();
  String errorMessage = '';

  Future<void> criarReserva() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentReference novaReserva = FirebaseFirestore.instance.collection('reservas').doc();

      await novaReserva.set({
        'nome': nomeReservaController.text,
        'codigo_acesso': novaReserva.id,
        'admin': user.uid,
      });

      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
        'nome': user.displayName ?? 'Administrador',
        'email': user.email,
        'funcao': 'Administrador',
        'reserva_atual': novaReserva.id,
      });

      // Marcar código de ativação como usado
      await firebaseServico.marcarCodigoComoUsado(widget.codigoAtivacao, user.uid);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const TelaPrincipal()));
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao criar a reserva. Tente novamente.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Nova Reserva")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeReservaController,
              decoration: const InputDecoration(labelText: "Nome da Reserva"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: criarReserva,
              child: const Text("Criar Reserva"),
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
