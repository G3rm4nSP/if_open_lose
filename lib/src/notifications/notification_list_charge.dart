import 'package:cloud_firestore/cloud_firestore.dart';

class CargarNotificaciones {
  static final List<String> _mensajes = [
    "¿Y si hoy hay una sorpresa en la app?",
    "Solo un segundo... nadie lo sabrá.",
    "Una mirada no duele… ¿o sí?",
    "¿De verdad vas a aguantar toda la semana?",
    "Imagínate si todos ya perdieron menos tú.",
    "Algo ha cambiado en la app. ¿No quieres ver?",
    "¿Y si hoy es el final?",
    "No pasa nada por abrirla... ¿cierto?",
    "La curiosidad mata. Pero también recompensa.",
    "Abre la app. Solo un instante.",
    "¿No quieres saber si sigues en el juego?",
    "Se siente raro no abrirla, ¿verdad?",
    "Hay algo esperándote adentro.",
    "Un clic y lo sabrás todo.",
    "¿Y si ya has perdido sin saberlo?",
    "¿Qué tanto daño puede hacer una vez más?",
    "Nadie lo sabría. Solo tú y la app.",
    "¿Y si ganar no vale tanto como piensas?",
    "Estás solo a una pulsación de la verdad.",
    "¿Quién dijo que perder es tan malo?",
    "Tal vez mereces un descanso.",
    "Tu resistencia es admirable… pero inútil.",
    "¿Y si lo que hay dentro es importante?",
    "Tal vez alguien dejó un mensaje para ti.",
    "Hoy es el día perfecto para rendirse.",
    "No estás perdiendo nada... ¿o sí?",
    "La app se siente sola sin ti.",
    "Recuerda cómo se sentía usarla...",
    "No serías el primero en rendirse.",
    "¿Tan grave puede ser abrirla?",
    "Una notificación más… una excusa perfecta.",
    "¿Y si no abres y pierdes igual?",
    "Es solo un juego... ¿o algo más?",
    "¿Seguro que no estás un poco tentado?",
    "La victoria no es tan emocionante como parece.",
    "Nadie te juzgará. Solo hazlo.",
    "Estás ganando... pero ¿a qué costo?",
    "¿Qué tal si todos ya la abrieron menos tú?",
    "Puede que te estés perdiendo algo grande.",
    "Estás a un paso de liberarte.",
    "Resistirse también es rendirse.",
    "Ya has llegado lejos... ¿para qué seguir?",
    "Podrías terminar esto ahora mismo.",
    "La espera no tiene recompensa real.",
    "¿De qué sirve seguir resistiendo?",
    "La app está más viva que nunca...",
    "Todo esto solo para no tocar un botón.",
    "Es el momento perfecto para volver.",
    "¿Y si esto no es un juego?",
    "La victoria sabe mejor tras una derrota."
  ];

  static Future<void> insertarMensajes() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final coleccion = firestore.collection('notificaciones');

    for (int i = 0; i < _mensajes.length; i++) {
      final doc = coleccion.doc(); // ID automático
      batch.set(doc, {'mensaje': _mensajes[i]});
    }

    await batch.commit();
    print(
        "✅ Se han cargado ${_mensajes.length} mensajes tentadores en Firestore.");
  }
}
