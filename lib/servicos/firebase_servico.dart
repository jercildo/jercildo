import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServico {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// **Ativar código de reserva e criar a reserva automaticamente**
  Future<String?> ativarCodigoDeReserva(String codigoAtivacao) async {
    User? usuarioAtual = auth.currentUser;

    if (usuarioAtual == null) {
      print("Usuário não autenticado!");
      return null;
    }

    DocumentReference codigoRef =
    firestore.collection("codigos_ativacao").doc(codigoAtivacao);

    try {
      DocumentSnapshot codigoDoc = await codigoRef.get();

      if (!codigoDoc.exists || codigoDoc["usado"] == true) {
        print("Código de ativação inválido ou já utilizado.");
        return null;
      }

      // Gerar um código de reserva único
      String codigoReserva = DateTime.now().millisecondsSinceEpoch.toString();

      // Criar a nova reserva no Firestore
      DocumentReference reservaRef = firestore.collection("reservas").doc(codigoReserva);
      await reservaRef.set({
        "codigo_reserva": codigoReserva,
        "codigo_ativacao": codigoAtivacao,
        "criador": usuarioAtual.uid,
        "data_criacao": FieldValue.serverTimestamp(),
      });

      // Criar configurações iniciais da reserva (se necessário)
      await reservaRef.collection("configuracoes").doc("geral").set({
        "status": "ativa",
        "permitir_novos_usuarios": true,
      });

      // Criar o usuário administrador na nova reserva
      await reservaRef.collection("usuarios").doc(usuarioAtual.uid).set({
        "nome": usuarioAtual.displayName ?? "Administrador",
        "email": usuarioAtual.email,
        "tipo": "administrador",
        "data_registro": FieldValue.serverTimestamp(),
      });

      // Marcar código de ativação como usado
      await marcarCodigoComoUsado(codigoAtivacao, usuarioAtual.uid);

      print("Reserva criada com sucesso! Código da reserva: $codigoReserva");

      return codigoReserva; // Retorna o código da reserva para exibição no app

    } catch (e) {
      print("Erro ao criar reserva: ${e.toString()}");
      return null;
    }
  }

  /// **Marcar o código de ativação como usado**
  Future<void> marcarCodigoComoUsado(String codigoAtivacao, String userId) async {
    try {
      DocumentReference codigoRef =
      firestore.collection("codigos_ativacao").doc(codigoAtivacao);

      await codigoRef.update({
        "usado": true,
        "utilizado_por": userId,
      });

      print("Código de ativação marcado como usado no Firestore.");
    } catch (e) {
      print("Erro ao marcar código como usado: ${e.toString()}");
    }
  }


  /// **Gerar um código de reserva único**
  String gerarCodigoReserva() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // Exemplo de geração de código único
  }
}
