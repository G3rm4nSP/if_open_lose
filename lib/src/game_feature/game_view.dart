import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:if_open_lose/src/firebase/user_model.dart';
import '../notifications/notification_service.dart';
import 'game_controller.dart';

class GameView extends StatefulWidget {
  final bool mostrarPantallaJuego;
  final Usuario? usuario;

  const GameView({
    super.key,
    required this.mostrarPantallaJuego,
    required this.usuario,
  });

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final _controller = TextEditingController();
  final _gameController = GameController();

  bool _procesando = false;
  bool _nombreVacio = false;

  Future<void> _firmar() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      setState(() => _nombreVacio = true);
      return;
    }

    setState(() {
      _procesando = true;
      _nombreVacio = false;
    });

    await _gameController.crearNuevoUsuario(nombre);
    await NotificationService.showStartNotification();
    await NotificationService.scheduleRandomNotifications();

    Future.delayed(const Duration(milliseconds: 500), () {
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_procesando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.usuario != null) {
      final duracion = _gameController.formatearDuracion(
        widget.usuario!.fechaInicio,
        widget.usuario!.fechaFinal,
        context,
      );

      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "${loc.notificacionTitulo}: ${loc.notificacionCuerpo}\n\n${loc.juegoMensaje}\n\n${loc.duracion}: $duracion",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.juegoMensaje,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: loc.ingresaNombre,
                  errorText: _nombreVacio ? loc.nombreRequerido : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _firmar,
                child: Text(loc.firmar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
