import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../../screens/stats/stats_screen.dart';

class MacrosDistributionCard extends StatelessWidget {
  final StatsPeriod period;
  final AnalyticsState state;

  const MacrosDistributionCard({
    super.key,
    required this.period,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final macrosData = _getMacrosData();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución Promedio de Macros',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Bar chart
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toInt()}g',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const labels = ['Proteínas', 'Carbos', 'Grasas'];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < labels.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      labels[value.toInt()],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}g',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: macrosData['protein']!,
                                color: const Color(0xFF2196F3),
                                width: 30,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: macrosData['carbs']!,
                                color: const Color(0xFF4CAF50),
                                width: 30,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: macrosData['fats']!,
                                color: const Color(0xFFFFC107),
                                width: 30,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMacroStat(
                        context,
                        'Proteínas',
                        macrosData['protein']!,
                        const Color(0xFF2196F3),
                      ),
                      const SizedBox(height: 16),
                      _buildMacroStat(
                        context,
                        'Carbohidratos',
                        macrosData['carbs']!,
                        const Color(0xFF4CAF50),
                      ),
                      const SizedBox(height: 16),
                      _buildMacroStat(
                        context,
                        'Grasas',
                        macrosData['fats']!,
                        const Color(0xFFFFC107),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroStat(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            '${value.toInt()}g',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ),
      ],
    );
  }

  Map<String, double> _getMacrosData() {
    // Intentar obtener datos de WeeklySummary primero
    if (state is WeeklySummaryLoaded) {
      final weeklyState = state as WeeklySummaryLoaded;
      final macros = weeklyState.summary.averageMacros;
      
      return {
        'protein': macros.protein,
        'carbs': macros.carbohydrates,
        'fats': macros.fats,
      };
    }
    
    // Si no hay datos de weekly, intentar con ProgressStats
    if (state is ProgressStatsLoaded) {
      final progressState = state as ProgressStatsLoaded;
      final stats = progressState.stats;
      
      // Calcular distribución de macros basada en calorías promedio
      // Usando distribución estándar: 30% proteína, 40% carbos, 30% grasas
      if (stats.averageCalories > 0) {
        final proteinCalories = stats.averageCalories * 0.30;
        final carbsCalories = stats.averageCalories * 0.40;
        final fatsCalories = stats.averageCalories * 0.30;
        
        return {
          'protein': proteinCalories / 4, // 4 cal/g
          'carbs': carbsCalories / 4, // 4 cal/g
          'fats': fatsCalories / 9, // 9 cal/g
        };
      }
    }
    
    // Valores por defecto si no hay datos
    return {
      'protein': 0,
      'carbs': 0,
      'fats': 0,
    };
  }
}
