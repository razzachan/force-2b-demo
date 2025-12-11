import '../models/visita.dart';

class VisitaService {
  static Visita? _visitaAtual;
  static final List<Visita> _historicoVisitas = [];

  static Visita? get visitaAtual => _visitaAtual;
  static List<Visita> get historicoVisitas => List.unmodifiable(_historicoVisitas);

  static Visita fazerCheckIn(String clienteId, String clienteNome) {
    // Se já existe visita em andamento, finaliza automaticamente
    if (_visitaAtual != null && _visitaAtual!.emAndamento) {
      fazerCheckOut();
    }

    _visitaAtual = Visita(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clienteId: clienteId,
      clienteNome: clienteNome,
      checkIn: DateTime.now(),
      latitude: -23.550520, // Mock - em produção seria GPS real
      longitude: -46.633308,
    );

    return _visitaAtual!;
  }

  static Visita? fazerCheckOut({String? observacoes, bool pedidoRealizado = false, double? valorPedido}) {
    if (_visitaAtual == null || !_visitaAtual!.emAndamento) {
      return null;
    }

    _visitaAtual = _visitaAtual!.copyWith(
      checkOut: DateTime.now(),
      observacoes: observacoes,
      pedidoRealizado: pedidoRealizado,
      valorPedido: valorPedido,
    );

    _historicoVisitas.insert(0, _visitaAtual!);
    final visitaFinalizada = _visitaAtual;
    _visitaAtual = null;

    return visitaFinalizada;
  }

  static void registrarPedido(double valor) {
    if (_visitaAtual != null && _visitaAtual!.emAndamento) {
      _visitaAtual = _visitaAtual!.copyWith(
        pedidoRealizado: true,
        valorPedido: valor,
      );
    }
  }

  static bool temVisitaEmAndamento() {
    return _visitaAtual != null && _visitaAtual!.emAndamento;
  }

  static bool isClienteEmVisita(String clienteId) {
    return _visitaAtual?.clienteId == clienteId && _visitaAtual!.emAndamento;
  }
}
