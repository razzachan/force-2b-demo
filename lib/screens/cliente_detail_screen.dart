import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../data/visita_service.dart';
import 'novo_pedido_screen.dart';

class ClienteDetailScreen extends StatefulWidget {
  final dynamic cliente;

  const ClienteDetailScreen({super.key, required this.cliente});

  @override
  State<ClienteDetailScreen> createState() => _ClienteDetailScreenState();
}

class _ClienteDetailScreenState extends State<ClienteDetailScreen> {
  bool get _emVisita => VisitaService.isClienteEmVisita(widget.cliente.id);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final visita = _emVisita ? VisitaService.visitaAtual : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de visita em andamento
            if (_emVisita && visita != null)
              Container(
                color: AppTheme.accentColor,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visita em andamento',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Iniciada às ${DateFormat('HH:mm').format(visita.checkIn!)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (visita.pedidoRealizado)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Pedido realizado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            
            // Header do cliente
            Container(
              color: AppTheme.primaryColor,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          widget.cliente.nome.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cliente.nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.cliente.cnpj,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.getRiscoColor(widget.cliente.riscoChurn),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Risco ${widget.cliente.statusRisco}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.cliente.endereco}, ${widget.cliente.cidade} - ${widget.cliente.estado}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Métricas principais
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Total Comprado',
                      currencyFormat.format(widget.cliente.totalComprado),
                      Icons.shopping_cart,
                      AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Ticket Médio',
                      currencyFormat.format(widget.cliente.ticketMedio),
                      Icons.receipt_long,
                      AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Visitas',
                      '${widget.cliente.numeroVisitas}',
                      Icons.event,
                      AppTheme.accentColor,
                    ),
                  ),
                ],
              ),
            ),

            // Alerta de churn se aplicável
            if (widget.cliente.riscoChurn > 0.7)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.alertChurn.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.alertChurn.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber, color: AppTheme.alertChurn),
                          const SizedBox(width: 8),
                          const Text(
                            'Alerta da IA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.alertChurn,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cliente sem comprar há ${widget.cliente.diasUltimaCompra} dias. Padrão anterior: ~30 dias.',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 20, color: AppTheme.accentColor),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Sugestão: Ofereça desconto de 10% + frete grátis',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Gráfico de compras
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Histórico de Compras (6 meses)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      'R\$${(value / 1000).toStringAsFixed(0)}k',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const months = ['Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
                                    if (value.toInt() >= 0 && value.toInt() < months.length) {
                                      return Text(
                                        months[value.toInt()],
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, widget.cliente.ticketMedio * 1.2),
                                  FlSpot(1, widget.cliente.ticketMedio * 1.1),
                                  FlSpot(2, widget.cliente.ticketMedio * 0.9),
                                  FlSpot(3, widget.cliente.ticketMedio * 1.0),
                                  FlSpot(4, widget.cliente.ticketMedio * 0.7),
                                  FlSpot(5, widget.cliente.ticketMedio * 0.3),
                                ],
                                isCurved: true,
                                color: AppTheme.primaryColor,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Produtos frequentes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Produtos Mais Comprados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.cliente.produtosFrequentes.map<Widget>((produto) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory_2, color: AppTheme.accentColor),
                        ),
                        title: Text(produto),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _emVisita
          ? FloatingActionButton.extended(
              onPressed: _fazerCheckOut,
              backgroundColor: AppTheme.dangerColor,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Finalizar Visita'),
            )
          : FloatingActionButton.extended(
              onPressed: _fazerCheckIn,
              icon: const Icon(Icons.location_on),
              label: const Text('Iniciar Visita'),
            ),
    );
  }

  void _fazerCheckIn() {
    VisitaService.fazerCheckIn(widget.cliente.id, widget.cliente.nome);
    
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Check-in realizado!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Visita iniciada às ${DateFormat('HH:mm').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentColor,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'PEDIDO',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NovoPedidoScreen(cliente: widget.cliente),
              ),
            );
          },
        ),
      ),
    );
  }

  void _fazerCheckOut() {
    final visita = VisitaService.visitaAtual;
    if (visita == null) return;

    showDialog(
      context: context,
      builder: (context) => _CheckOutDialog(
        cliente: widget.cliente,
        visita: visita,
        onCheckOut: (observacoes) {
          VisitaService.fazerCheckOut(
            observacoes: observacoes,
            pedidoRealizado: visita.pedidoRealizado,
            valorPedido: visita.valorPedido,
          );
          
          setState(() {});
          
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Visita finalizada!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Duração: ${_formatDuracao(visita.duracao!)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.primaryColor,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  String _formatDuracao(Duration duracao) {
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes.remainder(60);
    if (horas > 0) {
      return '${horas}h ${minutos}min';
    }
    return '${minutos}min';
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckOutDialog extends StatefulWidget {
  final dynamic cliente;
  final dynamic visita;
  final Function(String?) onCheckOut;

  const _CheckOutDialog({
    required this.cliente,
    required this.visita,
    required this.onCheckOut,
  });

  @override
  State<_CheckOutDialog> createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<_CheckOutDialog> {
  final _observacoesController = TextEditingController();

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duracao = widget.visita.duracao;
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes.remainder(60);

    return AlertDialog(
      title: const Text('Finalizar Visita'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cliente.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Check-in',
              DateFormat('HH:mm').format(widget.visita.checkIn),
              Icons.login,
            ),
            _buildInfoRow(
              'Duração',
              horas > 0 ? '${horas}h ${minutos}min' : '${minutos}min',
              Icons.timer,
            ),
            if (widget.visita.pedidoRealizado) ...[
              _buildInfoRow(
                'Pedido',
                'Realizado • ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.visita.valorPedido ?? 0)}',
                Icons.check_circle,
                color: AppTheme.accentColor,
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Observações (opcional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                hintText: 'Ex: Cliente interessado em novos produtos',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCheckOut(_observacoesController.text.isEmpty 
                ? null 
                : _observacoesController.text);
          },
          child: const Text('Finalizar'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
