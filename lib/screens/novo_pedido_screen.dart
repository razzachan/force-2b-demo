import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../data/visita_service.dart';
import '../models/produto.dart';
import '../models/pedido.dart';

class NovoPedidoScreen extends StatefulWidget {
  final dynamic cliente;

  const NovoPedidoScreen({super.key, required this.cliente});

  @override
  State<NovoPedidoScreen> createState() => _NovoPedidoScreenState();
}

class _NovoPedidoScreenState extends State<NovoPedidoScreen> {
  final List<ItemPedido> _itens = [];
  final _searchController = TextEditingController();
  List<Produto> _produtosFiltrados = [];
  final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    _produtosFiltrados = MockData.produtos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProdutos(String query) {
    setState(() {
      if (query.isEmpty) {
        _produtosFiltrados = MockData.produtos;
      } else {
        _produtosFiltrados = MockData.produtos
            .where((p) =>
                p.nome.toLowerCase().contains(query.toLowerCase()) ||
                p.codigo.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addItem(Produto produto) {
    setState(() {
      final index = _itens.indexWhere((item) => item.produto.id == produto.id);
      if (index >= 0) {
        _itens[index].quantidade++;
      } else {
        _itens.add(ItemPedido(produto: produto, quantidade: 1));
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} adicionado'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeItem(ItemPedido item) {
    setState(() {
      _itens.remove(item);
    });
  }

  void _updateQuantidade(ItemPedido item, int quantidade) {
    if (quantidade <= 0) {
      _removeItem(item);
    } else {
      setState(() {
        item.quantidade = quantidade;
      });
    }
  }

  double get _subtotal => _itens.fold(0, (sum, item) => sum + item.subtotal);
  double get _total => _itens.fold(0, (sum, item) => sum + item.total);

  void _finalizarPedido() {
    if (_itens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione produtos ao pedido')),
      );
      return;
    }

    // Registra o pedido na visita se houver visita em andamento
    if (VisitaService.temVisitaEmAndamento()) {
      VisitaService.registrarPedido(_total);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.accentColor, size: 28),
            const SizedBox(width: 12),
            const Expanded(child: Text('Pedido Finalizado!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${widget.cliente.nome}'),
            const SizedBox(height: 8),
            Text('Total de itens: ${_itens.length}'),
            Text('Valor total: ${currencyFormat.format(_total)}'),
            const SizedBox(height: 16),
            if (VisitaService.temVisitaEmAndamento())
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.accentColor, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Pedido vinculado à visita em andamento',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'O pedido será sincronizado com o ERP.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtosSugeridos = MockData.produtos.where((p) => p.sugeridoPelaIA).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
        actions: [
          if (_itens.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_itens.length} ${_itens.length == 1 ? 'item' : 'itens'}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Info do cliente
          Container(
            color: AppTheme.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    widget.cliente.nome.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cliente.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ticket médio: ${currencyFormat.format(widget.cliente.ticketMedio)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sugestões da IA
          if (produtosSugeridos.isNotEmpty) ...[
            Container(
              color: AppTheme.accentColor.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Sugestões da IA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: produtosSugeridos.length,
                      itemBuilder: (context, index) {
                        final produto = produtosSugeridos[index];
                        return _buildSuggestionCard(produto);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Busca de produtos
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar produtos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProdutos('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterProdutos,
            ),
          ),

          // Lista de produtos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _produtosFiltrados.length,
              itemBuilder: (context, index) {
                final produto = _produtosFiltrados[index];
                final itemExistente = _itens.where((i) => i.produto.id == produto.id).firstOrNull;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: produto.sugeridoPelaIA 
                            ? AppTheme.accentColor.withOpacity(0.1)
                            : AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: produto.sugeridoPelaIA ? AppTheme.accentColor : AppTheme.primaryColor,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(child: Text(produto.nome)),
                        if (produto.sugeridoPelaIA)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'IA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${produto.codigo} • ${produto.categoria}'),
                        if (produto.probabilidadeCompra != null)
                          Text(
                            '${(produto.probabilidadeCompra! * 100).toInt()}% de chance de compra',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(produto.preco),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (itemExistente != null)
                          Text(
                            '${itemExistente.quantidade}x',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => _addItem(produto),
                  ),
                );
              },
            ),
          ),

          // Carrinho (bottom sheet)
          if (_itens.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Itens do carrinho (expansível)
                  ExpansionTile(
                    title: Text('${_itens.length} ${_itens.length == 1 ? 'item' : 'itens'} no carrinho'),
                    children: _itens.map((item) {
                      return ListTile(
                        dense: true,
                        title: Text(item.produto.nome),
                        subtitle: Text(currencyFormat.format(item.produto.preco)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _updateQuantidade(item, item.quantidade - 1),
                              iconSize: 20,
                            ),
                            Text(
                              '${item.quantidade}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _updateQuantidade(item, item.quantidade + 1),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  
                  // Total e botão finalizar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                currencyFormat.format(_total),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _finalizarPedido,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Finalizar Pedido'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(Produto produto) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: () => _addItem(produto),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory_2, color: AppTheme.accentColor, size: 20),
                    const Spacer(),
                    if (produto.probabilidadeCompra != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(produto.probabilidadeCompra! * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  produto.nome,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  currencyFormat.format(produto.preco),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
