import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../firebase/firebase_service.dart';

class GameController {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> crearNuevoUsuario(String nombre) async {
    await _firebaseService.crearUsuario(nombre);
  }

  String formatearDuracion(
      DateTime inicio, DateTime fin, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duracion = fin.difference(inicio);
    final int dias = duracion.inDays;
    final int horas = duracion.inHours % 24;
    final int minutos = duracion.inMinutes % 60;
    final int segundos = duracion.inSeconds % 60;

    if (dias >= 365) {
      final int anios = dias ~/ 365;
      final int meses = (dias % 365) ~/ 30;
      final int diasRest = (dias % 365) % 30;
      return l10n.duracionAnosMesesDias(anios, meses, diasRest);
    } else if (dias >= 30) {
      final int meses = dias ~/ 30;
      final int diasRest = dias % 30;
      return l10n.duracionMesesDias(meses, diasRest);
    } else if (dias >= 1) {
      return l10n.duracionDiasHorasMinutos(dias, horas, minutos);
    } else if (horas > 0) {
      return l10n.duracionHorasMinutosSegundos(horas, minutos, segundos);
    } else if (minutos > 0) {
      return l10n.duracionMinutosSegundos(minutos, segundos);
    } else {
      return l10n.duracionSegundos(segundos);
    }
  }
}
