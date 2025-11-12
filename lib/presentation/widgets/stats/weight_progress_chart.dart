import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../../screens/stats/stats_screen.dart';

class WeightProgressChart extends StatelessWidget {
  final StatsPeriod period;
  final AnalyticsState state;

  const WeightProgressChart({
    super.key,
    required this.period,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from repository
    final mockData = _generateMockWeightData(period);
    
    if (mockData.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.monitor_weight_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'No hay datos de peso registrados',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final weightChange = mockData.last.y - mockData.first.y;
    final isWeightLoss = weightChange < 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progreso de Peso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isWeightLoss
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isWeightLoss ? Icons.trending_down : Icons.trending_up,
                        size: 16,
                        color: isWeightLoss
                            ? const Color(0xFF4CAF50)
                            : Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${weightChange.abs().toStringAsFixed(1)} kg',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isWeightLoss
                                  ? const Color(0xFF4CAF50)
                                  : Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
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
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()} kg',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getBottomInterval(period),
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _getBottomLabel(value.toInt(), period),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: mockData.length.toDouble() - 1,
                  minY: _getMinY(mockData) - 2,
                  maxY: _getMaxY(mockData) + 2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: mockData,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(1)} kg',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateMockWeightData(StatsPeriod period) {
    // TODO: Replace with actual data from repository
    switch (period) {
      case StatsPeriod.week:
        return [
          const FlSpot(0, 75.5),
          const FlSpot(1, 75.3),
          const FlSpot(2, 75.2),
          const FlSpot(3, 75.0),
          const FlSpot(4, 74.8),
          const FlSpot(5, 74.9),
          const FlSpot(6, 74.7),
        ];
      case StatsPeriod.month:
        return [
          const FlSpot(0, 76.5),
          const FlSpot(5, 76.0),
          const FlSpot(10, 75.5),
          const FlSpot(15, 75.2),
          const FlSpot(20, 74.8),
          const FlSpot(25, 74.5),
          const FlSpot(29, 74.2),
        ];
      case StatsPeriod.threeMonths:
        return [
          const FlSpot(0, 78.0),
          const FlSpot(15, 77.0),
          const FlSpot(30, 76.2),
          const FlSpot(45, 75.5),
          const FlSpot(60, 75.0),
          const FlSpot(75, 74.5),
          const FlSpot(89, 74.0),
        ];
    }
  }

  double _getMinY(List<FlSpot> data) {
    return data.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
  }

  double _getMaxY(List<FlSpot> data) {
    return data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
  }

  double _getBottomInterval(StatsPeriod period) {
    switch (period) {
      case StatsPeriod.week:
        return 1;
      case StatsPeriod.month:
        return 5;
      case StatsPeriod.threeMonths:
        return 15;
    }
  }

  String _getBottomLabel(int value, StatsPeriod period) {
    switch (period) {
      case StatsPeriod.week:
        const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
        return value < days.length ? days[value] : '';
      case StatsPeriod.month:
        return 'D${value + 1}';
      case StatsPeriod.threeMonths:
        return 'S${(value / 7).ceil()}';
    }
  }
}
