import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_codigo_ativacao.dart';
import 'tela_principal.dart';
import 'tela_login.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({Key? key}) : super(key: key); // ✅ Adicionado Key

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data != null) {
          final String userId = snapshot.data!.uid; // ✅ Obtendo o ID do usuário

          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('usuarios').doc(userId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                var userData = userSnapshot.data!.data();

                if (userData != null && userData.containsKey('reserva_atual') && userData['reserva_atual'] != null) {
                  return const TelaPrincipal(); // ✅ Se tem reserva, vai para a principal
                }
              }

              return TelaCodigoAtivacao(user: userId); // ✅ Agora userId está definido
            },
          );
        } else {
          return const TelaLogin(codigoReserva: "codigo_padrao"); // ✅ Se não há login, vai para login
        }
      },
    );
  }
}
