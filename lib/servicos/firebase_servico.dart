import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Verifica se o código de ativação é válido e não foi utilizado
  Future<bool> verificarCodigoAtivacao(String codigo) async {
    DocumentSnapshot codigoDoc = await _firestore.collection('codigos_ativacao').doc(codigo).get();

    if (codigoDoc.exists && codigoDoc['usado'] == false) {
      return true; // Código válido e ainda não foi usado
    }
    return false; // Código inválido ou já usado
  }

  /// Marca o código como utilizado, associando ao usuário que o usou
  Future<void> marcarCodigoComoUsado(String codigo, String usuarioId) async {
    await _firestore.collection('codigos_ativacao').doc(codigo).update({
      'usado': true,
      'utilizado_por': usuarioId, // Registra o usuário que utilizou o código
    });
  }
}
