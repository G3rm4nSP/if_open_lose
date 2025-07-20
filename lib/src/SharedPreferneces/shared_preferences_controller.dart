import 'package:if_open_lose/src/firebase/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController {
  static Future<String?> getStoredId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<void> storeId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
  }

  static Future<bool?> getUserLose() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('user_lose');
  }

  static Future<void> userLose(bool lose) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_lose', lose);
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> storeUser(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', usuario.id);
    await prefs.setBool('user_lose', usuario.perdedor);
    await prefs.setString('user_name', usuario.nombre);
    await prefs.setString(
        'user_start_date', usuario.fechaInicio.toIso8601String());
    await prefs.setString(
        'user_end_date', usuario.fechaFinal.toIso8601String());
    await prefs.setString('user_fcm_token', usuario.fcmToken ?? '');
    await prefs.setString(
        'user_notification_theme', usuario.temaNotificacion ?? '');
  }

  static Future<Usuario?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('user_id');
    if (id == null) return null;

    String? nombre = prefs.getString('user_name');
    String? fcmToken = prefs.getString('user_fcm_token');
    String? temaNotificacion = prefs.getString('user_notification_theme');
    DateTime? fechaInicio =
        DateTime.tryParse(prefs.getString('user_start_date') ?? '');
    DateTime? fechaFinal =
        DateTime.tryParse(prefs.getString('user_end_date') ?? '');
    bool perdedor = prefs.getBool('user_lose') ?? false;

    return Usuario(
      id: id,
      nombre: nombre ?? 'Perdedor',
      fcmToken: fcmToken,
      temaNotificacion: temaNotificacion,
      fechaInicio: fechaInicio ?? DateTime.now(),
      fechaFinal: fechaFinal ?? DateTime.now(),
      perdedor: perdedor,
    );
  }
}
