enum TipoAlerta {
  churn,
  oportunidade,
  anomalia,
  urgente,
}

enum PrioridadeAlerta {
  alta,
  media,
  baixa,
}

class Alerta {
  final String id;
  final String clienteId;
  final String clienteNome;
  final TipoAlerta tipo;
  final PrioridadeAlerta prioridade;
  final String titulo;
  final String descricao;
  final String? acao;
  final DateTime dataHora;
  final bool lido;

  Alerta({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.tipo,
    required this.prioridade,
    required this.titulo,
    required this.descricao,
    this.acao,
    required this.dataHora,
    this.lido = false,
  });

  String get icone {
    switch (tipo) {
      case TipoAlerta.churn:
        return '⚠️';
      case TipoAlerta.oportunidade:
        return '💰';
      case TipoAlerta.anomalia:
        return '📊';
      case TipoAlerta.urgente:
        return '🔥';
    }
  }
}
