import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_registro.dart';

class TelaLoginRegistro extends StatelessWidget {
  final String codigoReserva;
  final String codigoAtivacao;

  const TelaLoginRegistro({Key? key, required this.codigoReserva, required this.codigoAtivacao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acesso à Reserva"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // **Botão de voltar**
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Escolha uma opção para acessar sua reserva:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaLogin(
                      codigoReserva: codigoReserva,
                      codigoAtivacao: codigoAtivacao,
                    ),
                  ),
                );
              },
              child: Text("Fazer Login"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaRegistro(
                      codigoReserva: codigoReserva,
                      codigoAtivacao: codigoAtivacao,
                    ),
                  ),
                );
              },
              child: Text("Registrar-se"),
            ),
          ],
        ),
      ),
    );
  }
}
