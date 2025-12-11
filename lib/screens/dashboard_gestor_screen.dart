import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class DashboardGestorScreen extends StatelessWidget {
  const DashboardGestorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    
    // Calcular métricas
    final totalClientes = MockData.clientes.length;
    final clientesAltoRisco = MockData.clientes.where((c) => c.riscoChurn > 0.7).length;
    final ticketMedioGeral = MockData.clientes.fold<double>(0, (sum, c) => sum + c.ticketMedio) / totalClientes;
    final receitaTotal = MockData.clientes.fold<double>(0, (sum, c) => sum + c.totalComprado);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Dashboard Executivo',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Visão geral da performance comercial',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // KPIs principais
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    'Receita Total',
                    currencyFormat.format(receitaTotal),
                    Icons.attach_money,
                    AppTheme.accentColor,
                    '+12%',
                    true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    'Ticket Médio',
                    currencyFormat.format(ticketMedioGeral),
                    Icons.receipt_long,
                    AppTheme.primaryColor,
                    '+8%',
                    true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    'Total Clientes',
                    '$totalClientes',
                    Icons.people,
                    AppTheme.secondaryColor,
                    '+3',
                    true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    'Alto Risco',
                    '$clientesAltoRisco',
                    Icons.warning_amber,
                    AppTheme.dangerColor,
                    '-2',
                    false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Gráfico de vendas
            Text(
              'Performance de Vendas (6 meses)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 120000,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
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
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    months[value.toInt()],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        _makeGroupData(0, 95000),
                        _makeGroupData(1, 98000),
                        _makeGroupData(2, 87000),
                        _makeGroupData(3, 92000),
                        _makeGroupData(4, 78000),
                        _makeGroupData(5, 68000),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Distribuição de risco
            Text(
              'Distribuição de Risco de Churn',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: _buildPieChartSections(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Baixo Risco', AppTheme.accentColor, 
                          MockData.clientes.where((c) => c.riscoChurn <= 0.4).length),
                        const SizedBox(height: 8),
                        _buildLegendItem('Médio Risco', AppTheme.warningColor,
                          MockData.clientes.where((c) => c.riscoChurn > 0.4 && c.riscoChurn <= 0.7).length),
                        const SizedBox(height: 8),
                        _buildLegendItem('Alto Risco', AppTheme.dangerColor,
                          MockData.clientes.where((c) => c.riscoChurn > 0.7).length),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Top clientes em risco
            Text(
              'Clientes Prioritários para Atenção',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...MockData.clientes
                .where((c) => c.riscoChurn > 0.4)
                .take(4)
                .map((cliente) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.getRiscoColor(cliente.riscoChurn).withOpacity(0.2),
                    child: Text(
                      cliente.nome.substring(0, 1),
                      style: TextStyle(
                        color: AppTheme.getRiscoColor(cliente.riscoChurn),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(cliente.nome),
                  subtitle: Text('Última compra: ${cliente.diasUltimaCompra} dias atrás'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.getRiscoColor(cliente.riscoChurn).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Risco ${cliente.statusRisco}',
                          style: TextStyle(
                            color: AppTheme.getRiscoColor(cliente.riscoChurn),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(cliente.ticketMedio),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Insights da IA
            Card(
              color: AppTheme.accentColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Insights da IA',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInsightItem('2 clientes em alto risco precisam de atenção urgente'),
                    _buildInsightItem('Taxa de conversão aumentou 12% este mês'),
                    _buildInsightItem('Melhor dia para visitas: Terça-feira'),
                    _buildInsightItem('Produtos sugeridos têm 85% de taxa de aceitação'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color, String trend, bool isPositive) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppTheme.accentColor : AppTheme.dangerColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? AppTheme.accentColor : AppTheme.dangerColor,
                      ),
                      Text(
                        trend,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? AppTheme.accentColor : AppTheme.dangerColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppTheme.primaryColor,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final baixoRisco = MockData.clientes.where((c) => c.riscoChurn <= 0.4).length;
    final medioRisco = MockData.clientes.where((c) => c.riscoChurn > 0.4 && c.riscoChurn <= 0.7).length;
    final altoRisco = MockData.clientes.where((c) => c.riscoChurn > 0.7).length;
    final total = MockData.clientes.length;

    return [
      PieChartSectionData(
        color: AppTheme.accentColor,
        value: (baixoRisco / total) * 100,
        title: '${((baixoRisco / total) * 100).toInt()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppTheme.warningColor,
        value: (medioRisco / total) * 100,
        title: '${((medioRisco / total) * 100).toInt()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppTheme.dangerColor,
        value: (altoRisco / total) * 100,
        title: '${((altoRisco / total) * 100).toInt()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text('$label ($count)', style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildInsightItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppTheme.accentColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
