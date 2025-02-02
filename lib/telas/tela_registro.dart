import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_login.dart'; // Certifique-se de que o caminho está correto

class TelaRegistro extends StatefulWidget {
  @override
  _TelaRegistroState createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final TextEditingController _nomeGuerraController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String _mensagemErro = '';
  bool carregando = false;

  /// **Registrar usuário no Firebase**
  void _registrarUsuario() async {
    String nomeGuerra = _nomeGuerraController.text.trim();
    String rg = _rgController.text.trim();
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (nomeGuerra.isEmpty || rg.isEmpty || email.isEmpty || senha.isEmpty) {
      setState(() {
        _mensagemErro = 'Preencha todos os campos!';
      });
      return;
    }

    setState(() => carregando = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
        'nome_guerra': nomeGuerra,
        'rg': rg,
        'email': email,
        'reserva_atual': null,
        'tipo_usuario': 'pendente',
      });

      setState(() {
        _mensagemErro = 'Cadastro realizado com sucesso!';
        carregando = false;
      });

      // **Redirecionar para a tela de login**
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin(codigoReserva: "", codigoAtivacao: '',)),
      );
    } on FirebaseAuthException catch (e) {
      String erroMensagem = 'Erro ao registrar. Verifique os dados e tente novamente.';

      if (e.code == 'email-already-in-use') {
        erroMensagem = 'Este e-mail já está cadastrado.';
      } else if (e.code == 'weak-password') {
        erroMensagem = 'A senha deve ter pelo menos 6 caracteres.';
      } else if (e.code == 'invalid-email') {
        erroMensagem = 'Formato de e-mail inválido.';
      }

      setState(() {
        _mensagemErro = erroMensagem;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Ocorreu um erro inesperado. Tente novamente.';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // **Botão de voltar**
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nomeGuerraController,
              decoration: InputDecoration(labelText: "Nome de Guerra", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _rgController,
              decoration: InputDecoration(labelText: "RG", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "E-mail", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Senha", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: carregando ? null : _registrarUsuario,
              child: carregando
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                  : Text("Registrar"),
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
