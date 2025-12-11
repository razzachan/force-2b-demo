class Cliente {
  final String id;
  final String nome;
  final String cnpj;
  final String endereco;
  final String cidade;
  final String estado;
  final double latitude;
  final double longitude;
  final double ticketMedio;
  final int diasUltimaCompra;
  final double probabilidadeRecompra;
  final double riscoChurn;
  final String categoria;
  final List<String> produtosFrequentes;
  final double totalComprado;
  final int numeroVisitas;

  Cliente({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.endereco,
    required this.cidade,
    required this.estado,
    required this.latitude,
    required this.longitude,
    required this.ticketMedio,
    required this.diasUltimaCompra,
    required this.probabilidadeRecompra,
    required this.riscoChurn,
    required this.categoria,
    required this.produtosFrequentes,
    required this.totalComprado,
    required this.numeroVisitas,
  });

  bool get isAltoRisco => riscoChurn > 0.7;
  bool get isMedioRisco => riscoChurn > 0.4 && riscoChurn <= 0.7;
  
  String get statusRisco {
    if (riscoChurn > 0.7) return 'Alto';
    if (riscoChurn > 0.4) return 'Médio';
    return 'Baixo';
  }
}
