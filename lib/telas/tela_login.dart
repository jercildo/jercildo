import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tela_escolher_funcao.dart';

class TelaLogin extends StatefulWidget {
  final String? codigoReserva;
  final String? codigoAtivacao;

  const TelaLogin({Key? key, this.codigoReserva, this.codigoAtivacao}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  String errorMessage = '';
  bool carregando = false;

  /// **Valida se os campos foram preenchidos**
  bool _validarCampos() {
    if (emailController.text.trim().isEmpty || senhaController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Preencha todos os campos antes de continuar!';
      });
      return false;
    }
    return true;
  }

  /// **Faz o login no Firebase**
  Future<void> _login() async {
    if (!_validarCampos()) return;

    setState(() => carregando = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaEscolherFuncao(
            reservaId: widget.codigoReserva ?? "",
            user: FirebaseAuth.instance.currentUser,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String erroMensagem = 'Erro ao fazer login. Verifique suas credenciais.';

      if (e.code == 'user-not-found') {
        erroMensagem = 'E-mail não encontrado. Verifique e tente novamente.';
      } else if (e.code == 'wrong-password') {
        erroMensagem = 'Senha incorreta. Verifique e tente novamente.';
      } else if (e.code == 'invalid-email') {
        erroMensagem = 'Formato de e-mail inválido.';
      }

      setState(() {
        errorMessage = erroMensagem;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro inesperado. Tente novamente.';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: carregando ? null : _login,
              child: carregando
                  ? CircularProgressIndicator()
                  : Text("Entrar"),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
