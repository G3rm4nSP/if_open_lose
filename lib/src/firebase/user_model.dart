class Usuario {
  final String id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFinal;
  final bool perdedor;

  Usuario({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFinal,
    this.perdedor = false,
  });

  set fechaFinal(DateTime fecha) {
    if (fecha.isBefore(fechaInicio)) {
      throw ArgumentError(
          "La fecha final no puede ser anterior a la fecha de inicio.");
    }
    fechaFinal = fecha;
  }

  set perdedor(bool valor) {
    if (valor && fechaFinal.isBefore(fechaInicio)) {
      throw ArgumentError(
          "No se puede marcar como perdedor si la fecha final es anterior a la fecha de inicio.");
    }
    perdedor = valor;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFinal': fechaFinal.toIso8601String(),
      'perdedor': perdedor,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFinal: DateTime.parse(map['fechaFinal']),
      perdedor: map['perdedor'] ?? false,
    );
  }

  Usuario copyWith({
    String? id,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFinal,
    bool? perdedor,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFinal: fechaFinal ?? this.fechaFinal,
      perdedor: perdedor ?? this.perdedor,
    );
  }
}
