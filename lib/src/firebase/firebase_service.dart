import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> _getStoredId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _storeId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
  }

  Future<Usuario?> getUsuarioSiExiste() async {
    String? id = await _getStoredId();

    if (id != null) {
      final doc = await _firestore.collection('usuarios').doc(id).get();
      if (doc.exists) {
        final usuario = Usuario.fromMap(doc.data()!);

        if (usuario.perdedor) {
          // Si el usuario ya es perdedor, no hacemos nada
          return usuario;
        }
        // Actualizar la fechaFinal al momento actual
        final actualizado = usuario.copyWith(
          fechaFinal: DateTime.now(),
          perdedor: true,
        );
        await actualizarUsuario(actualizado);

        return actualizado;
      }
    }

    return null; // Usuario no encontrado
  }

  Future<Usuario> crearUsuario(String nombreUsuario) async {
    final now = DateTime.now();
    final id = now.toIso8601String();

    final usuario = Usuario(
      id: id,
      nombre: nombreUsuario,
      fechaInicio: now,
      fechaFinal: now,
      perdedor: false,
    );

    await _firestore.collection('usuarios').doc(id).set(usuario.toMap());
    await _storeId(id);

    return usuario;
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await _firestore
        .collection('usuarios')
        .doc(usuario.id)
        .update(usuario.toMap());
  }
}
