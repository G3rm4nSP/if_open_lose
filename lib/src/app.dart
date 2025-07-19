import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:if_open_lose/src/firebase/user_model.dart';

import 'game_feature/game_view.dart';
import 'firebase/firebase_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<(bool, Usuario?)> _debeMostrarPantallaJuego() async {
    final firebaseService = FirebaseService();
    Usuario? usuario = await firebaseService.getUsuarioSiExiste();
    return (usuario != null, usuario);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(bool, Usuario?)>(
      future: _debeMostrarPantallaJuego(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final (mostrarPantallaJuego, usuario) = snapshot.data!;

        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('es', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: GameView(
            mostrarPantallaJuego: mostrarPantallaJuego,
            usuario: usuario,
          ),
        );
      },
    );
  }
}
