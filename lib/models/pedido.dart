import 'produto.dart';

class ItemPedido {
  final Produto produto;
  int quantidade;
  double? desconto;

  ItemPedido({
    required this.produto,
    required this.quantidade,
    this.desconto,
  });

  double get subtotal => produto.preco * quantidade;
  double get valorDesconto => (desconto ?? 0) * subtotal / 100;
  double get total => subtotal - valorDesconto;
}

class Pedido {
  final String id;
  final String clienteId;
  final String clienteNome;
  final DateTime data;
  final List<ItemPedido> itens;
  final String? observacoes;
  final String status;

  Pedido({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.data,
    required this.itens,
    this.observacoes,
    this.status = 'Rascunho',
  });

  double get subtotal => itens.fold(0, (sum, item) => sum + item.subtotal);
  double get descontoTotal => itens.fold(0, (sum, item) => sum + item.valorDesconto);
  double get total => itens.fold(0, (sum, item) => sum + item.total);
  int get totalItens => itens.fold(0, (sum, item) => sum + item.quantidade);
}
