class Visita {
  final String id;
  final String clienteId;
  final String clienteNome;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? observacoes;
  final double? latitude;
  final double? longitude;
  final bool pedidoRealizado;
  final double? valorPedido;

  Visita({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    this.checkIn,
    this.checkOut,
    this.observacoes,
    this.latitude,
    this.longitude,
    this.pedidoRealizado = false,
    this.valorPedido,
  });

  bool get emAndamento => checkIn != null && checkOut == null;
  bool get finalizada => checkIn != null && checkOut != null;
  
  Duration? get duracao {
    if (checkIn == null) return null;
    final fim = checkOut ?? DateTime.now();
    return fim.difference(checkIn!);
  }

  Visita copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    String? observacoes,
    double? latitude,
    double? longitude,
    bool? pedidoRealizado,
    double? valorPedido,
  }) {
    return Visita(
      id: id,
      clienteId: clienteId,
      clienteNome: clienteNome,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      observacoes: observacoes ?? this.observacoes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pedidoRealizado: pedidoRealizado ?? this.pedidoRealizado,
      valorPedido: valorPedido ?? this.valorPedido,
    );
  }
}
