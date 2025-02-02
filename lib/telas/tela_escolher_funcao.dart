import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_principal.dart';

class TelaEscolherFuncao extends StatefulWidget {
  final User user;
  final String reservaId;

  const TelaEscolherFuncao({Key? key, required this.user, required this.reservaId}) : super(key: key);

  @override
  _TelaEscolherFuncaoState createState() => _TelaEscolherFuncaoState();
}

class _TelaEscolherFuncaoState extends State<TelaEscolherFuncao> {
  String errorMessage = '';
  bool aguardandoAprovacao = false;
  bool aprovado = false;
  String funcaoEscolhida = '';
  bool funcaoEscolhidaBloqueada = false;

  @override
  void initState() {
    super.initState();
    _verificarAprovacao();
  }

  Future<void> _verificarAprovacao() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        funcaoEscolhida = userDoc['funcao'];
        aguardandoAprovacao = userDoc['aprovado'] == false && userDoc['funcao'] != 'Operador';
        aprovado = userDoc['aprovado'];
        funcaoEscolhidaBloqueada = userDoc['funcao'] != '';
      });
    }
  }

  Future<void> _selecionarFuncao(String funcao) async {
    if (funcaoEscolhidaBloqueada) {
      return;
    }

    bool precisaAprovacao = (funcao == 'Armeiro' || funcao == 'Administrador');

    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(widget.user.uid).update({
        'funcao': funcao,
        'aprovado': !precisaAprovacao,
        'reserva_atual': widget.reservaId,
      });

      setState(() {
        aguardandoAprovacao = precisaAprovacao;
        funcaoEscolhida = funcao;
        funcaoEscolhidaBloqueada = true;
        errorMessage = precisaAprovacao
            ? 'Função "$funcao" escolhida! Aguarde a aprovação do Administrador.'
            : 'Você agora é um "$funcao"! Acesso liberado.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: precisaAprovacao ? Colors.orange : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      if (!precisaAprovacao) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaPrincipal()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao selecionar função. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolher Função')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (aguardandoAprovacao)
              Column(
                children: [
                  Text(
                    'Você escolheu a função "$funcaoEscolhida". Aguarde até que o Administrador libere seu acesso.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              )
            else if (aprovado)
              Column(
                children: [
                  Text(
                    'Seu acesso para "$funcaoEscolhida" foi aprovado! Agora você pode continuar.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const TelaPrincipal()),
                      );
                    },
                    child: const Text('Continuar'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    'Escolha sua função:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: funcaoEscolhidaBloqueada ? null : () => _selecionarFuncao('Operador'),
                    child: const Text('Operador (Acesso imediato)'),
                  ),
                  ElevatedButton(
                    onPressed: funcaoEscolhidaBloqueada ? null : () => _selecionarFuncao('Armeiro'),
                    child: const Text('Armeiro (Aguarda aprovação)'),
                  ),
                  ElevatedButton(
                    onPressed: funcaoEscolhidaBloqueada ? null : () => _selecionarFuncao('Administrador'),
                    child: const Text('Administrador (Aguarda aprovação)'),
                  ),
                ],
              ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
