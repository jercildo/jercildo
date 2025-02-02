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

class TelaInicial extends StatelessWidget {
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
                .get()
                .catchError((error) {
              print("Erro ao buscar dados do usuário: $error");
              return null;
            }),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (userSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Erro ao carregar dados do usuário"),
                  ),
                );
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                var userData = userSnapshot.data!.data() as Map<String, dynamic>?;

                // ✅ Verifica se o campo "reserva_atual" existe e não é nulo
                if (userData != null && userData.containsKey('reserva_atual') && userData['reserva_atual'] != null) {
                  return TelaPrincipal(); // ✅ Se o usuário tem uma reserva, vai para a tela principal
                }
              }

              return TelaCodigoAtivacao(user: snapshot.data!.uid); // ✅ Se não tem reserva, vai para ativação do código
            },
          );
        } else {
          return TelaLogin(codigoReserva: "codigo_padrao");
        }
      },
    );
  }
}
