import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import 'cliente_detail_screen.dart';

class RoteiroScreen extends StatelessWidget {
  const RoteiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    
    // Clientes ordenados por prioridade (risco de churn e valor)
    final clientesPriorizados = List.from(MockData.clientes)
      ..sort((a, b) {
        // Prioriza alto risco e alto ticket
        final scoreA = a.riscoChurn * 0.6 + (a.ticketMedio / 15000) * 0.4;
        final scoreB = b.riscoChurn * 0.6 + (b.ticketMedio / 15000) * 0.4;
        return scoreB.compareTo(scoreA);
      });

    return Scaffold(
      body: Column(
        children: [
          // Header com resumo do roteiro
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Roteiro Inteligente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Priorizado por IA • Geografia + Risco + Oportunidade',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildRouteMetric('${clientesPriorizados.length}', 'Clientes', Icons.people),
                    const SizedBox(width: 24),
                    _buildRouteMetric('4.2km', 'Distância', Icons.directions_car),
                    const SizedBox(width: 24),
                    _buildRouteMetric('~3h', 'Tempo Est.', Icons.access_time),
                  ],
                ),
              ],
            ),
          ),
          
          // Lista de clientes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clientesPriorizados.length,
              itemBuilder: (context, index) {
                final cliente = clientesPriorizados[index];
                return _buildClienteCard(context, cliente, index + 1, currencyFormat);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.navigation),
        label: const Text('Iniciar Rota'),
      ),
    );
  }

  Widget _buildRouteMetric(String value, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClienteCard(BuildContext context, dynamic cliente, int ordem, NumberFormat currencyFormat) {
    // Calcula prioridade para exibição
    String prioridade;
    Color prioridadeColor;
    
    if (cliente.riscoChurn > 0.7) {
      prioridade = 'URGENTE';
      prioridadeColor = AppTheme.dangerColor;
    } else if (cliente.riscoChurn > 0.4) {
      prioridade = 'ALTA';
      prioridadeColor = AppTheme.warningColor;
    } else {
      prioridade = 'NORMAL';
      prioridadeColor = AppTheme.accentColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClienteDetailScreen(cliente: cliente),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Número da ordem
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: prioridadeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$ordem',
                        style: TextStyle(
                          color: prioridadeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Info do cliente
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cliente.nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: prioridadeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                prioridade,
                                style: TextStyle(
                                  color: prioridadeColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${cliente.endereco} • ${cliente.cidade}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Métricas e insights
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetricItem(
                          'Ticket Médio',
                          currencyFormat.format(cliente.ticketMedio),
                          Icons.attach_money,
                        ),
                        _buildMetricItem(
                          'Última Compra',
                          '${cliente.diasUltimaCompra}d atrás',
                          Icons.calendar_today,
                        ),
                        _buildMetricItem(
                          'Prob. Recompra',
                          '${(cliente.probabilidadeRecompra * 100).toInt()}%',
                          Icons.trending_up,
                        ),
                      ],
                    ),
                    
                    // Insight da IA
                    if (cliente.riscoChurn > 0.7) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.alertChurn.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.alertChurn.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber, size: 18, color: AppTheme.alertChurn),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'IA: Risco alto de perda. Ofereça condições especiais.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.alertChurn,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (cliente.probabilidadeRecompra > 0.8) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 18, color: AppTheme.accentColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'IA: Momento ideal para upsell. Sugira produtos premium.',
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
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
