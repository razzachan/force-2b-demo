class Produto {
  final String id;
  final String nome;
  final String codigo;
  final String categoria;
  final double preco;
  final String unidade;
  final int estoque;
  final String? imagemUrl;
  final bool sugeridoPelaIA;
  final double? probabilidadeCompra;

  Produto({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.categoria,
    required this.preco,
    required this.unidade,
    required this.estoque,
    this.imagemUrl,
    this.sugeridoPelaIA = false,
    this.probabilidadeCompra,
  });

  bool get temEstoque => estoque > 0;
}
