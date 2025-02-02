import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_escolha_autenticacao.dart';

class TelaCodigoReserva extends StatefulWidget {
  final String codigoReserva;

  const TelaCodigoReserva({Key? key, required this.codigoReserva}) : super(key: key);

  @override
  _TelaCodigoReservaState createState() => _TelaCodigoReservaState();
}

class _TelaCodigoReservaState extends State<TelaCodigoReserva> {
  bool carregando = false;
  String errorMessage = '';

  Future<void> validarReserva() async {
    setState(() {
      carregando = true;
      errorMessage = '';
    });

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('reservas')
          .doc(widget.codigoReserva)
          .get();

      if (!doc.exists) {
        setState(() {
          errorMessage = 'Código de reserva inválido.';
          carregando = false;
        });
        return;
      }

      // ✅ Navegação para a tela correta com o código da reserva
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaEscolhaAutenticacao(reservaId: widget.codigoReserva),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao validar reserva. Tente novamente.';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Código da Reserva')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o código da reserva para entrar.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: carregando ? null : validarReserva,
              child: carregando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Validar Reserva"),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
