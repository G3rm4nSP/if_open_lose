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
    final l10n = AppLocalizations.of(context)!;

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
        appBar: AppBar(
          title: Text(l10n.perdedorTitulo),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${l10n.notificacionTitulo}: ${l10n.perdedorMensaje}\n\n${l10n.perdedorDescripcion}\n\n${l10n.perdedorDuracion}:\n $duracion",
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes navegar a la pantalla de ranking
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RankingScreen()));
                  },
                  child: Text("ver ranking"),
                ),
              ],
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
                l10n.juegoMensaje,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: l10n.ingresaNombre,
                  errorText: _nombreVacio ? l10n.nombreRequerido : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _firmar,
                child: Text(l10n.firmar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
