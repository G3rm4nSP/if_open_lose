import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:if_open_lose/src/SharedPreferneces/shared_preferences_controller.dart';
import 'user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Usuario?> getUsuarioSiExiste() async {
    String? id = await SharedPreferencesController.getStoredId();
    bool? perdedor = await SharedPreferencesController.getUserLose();

    if (id != null && perdedor == true) {
      return await SharedPreferencesController.getStoredUser();
    }
    if (id != null) {
      final doc = await _firestore.collection('usuarios').doc(id).get();
      if (doc.exists) {
        final usuario = Usuario.fromMap(doc.data()!);

        // Actualizar la fechaFinal al momento actual
        final actualizado = usuario.copyWith(
          temaNotificacion: 'rojo',
          fechaFinal: DateTime.now(),
          perdedor: true,
        );
        await actualizarUsuario(actualizado);
        await SharedPreferencesController.storeUser(actualizado);
        return actualizado;
      }
    }

    return null; // Usuario no encontrado
  }

  Future<void> actualizarFcmToken(String id, String token) async {
    await _firestore.collection('usuarios').doc(id).update({'fcmToken': token});
  }

  Future<Usuario> crearUsuario(String nombreUsuario, {String? fcmToken}) async {
    final now = DateTime.now();
    final id = now.toIso8601String();

    final usuario = Usuario(
      id: id,
      nombre: nombreUsuario,
      fechaInicio: now,
      fechaFinal: now,
      perdedor: false,
      fcmToken: fcmToken,
    );

    await _firestore.collection('usuarios').doc(id).set(usuario.toMap());
    await SharedPreferencesController.storeUser(usuario);

    return usuario;
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await _firestore
        .collection('usuarios')
        .doc(usuario.id)
        .update(usuario.toMap());
  }
}
