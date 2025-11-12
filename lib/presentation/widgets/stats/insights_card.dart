import 'package:flutter/material.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../../screens/stats/stats_screen.dart';

class InsightsCard extends StatelessWidget {
  final StatsPeriod period;
  final AnalyticsState state;

  const InsightsCard({
    super.key,
    required this.period,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual insights from repository
    final mockInsights = _generateMockInsights();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Insights y Recomendaciones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...mockInsights.asMap().entries.map((entry) {
              final index = entry.key;
              final insight = entry.value;
              final isLast = index == mockInsights.length - 1;
              
              return _InsightItem(
                insight: insight,
                isLast: isLast,
              );
            }),
          ],
        ),
      ),
    );
  }

  List<InsightData> _generateMockInsights() {
    // TODO: Replace with actual insights from repository
    return [
      InsightData(
        type: InsightType.goalProgress,
        icon: Icons.trending_up,
        color: const Color(0xFF4CAF50),
        title: 'Excelente progreso',
        message:
            'Has cumplido tu objetivo de calorías en 5 de los últimos 7 días. ¡Sigue así!',
        recommendation:
            'Mantén la consistencia para alcanzar tus metas a largo plazo.',
      ),
      InsightData(
        type: InsightType.macroBalance,
        icon: Icons.pie_chart,
        color: const Color(0xFF2196F3),
        title: 'Balance de macros',
        message:
            'Tu consumo de proteínas está por debajo del objetivo en un 15%.',
        recommendation:
            'Intenta incluir más fuentes de proteína como pollo, pescado, huevos o legumbres.',
      ),
      InsightData(
        type: InsightType.consistency,
        icon: Icons.calendar_today,
        color: const Color(0xFFFFC107),
        title: 'Racha de 12 días',
        message: 'Has registrado alimentos durante 12 días consecutivos.',
        recommendation:
            'La consistencia es clave. Continúa registrando tus comidas diariamente.',
      ),
      InsightData(
        type: InsightType.caloriePattern,
        icon: Icons.access_time,
        color: const Color(0xFF9C27B0),
        title: 'Patrón de consumo',
        message:
            'Tiendes a consumir más calorías durante la cena (40% del total diario).',
        recommendation:
            'Considera distribuir mejor tus calorías a lo largo del día para mantener energía constante.',
      ),
    ];
  }
}

class _InsightItem extends StatelessWidget {
  final InsightData insight;
  final bool isLast;

  const _InsightItem({
    required this.insight,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: insight.color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: insight.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: insight.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      insight.icon,
                      color: insight.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      insight.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: insight.color,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                insight.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight.recommendation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const SizedBox(height: 12),
      ],
    );
  }
}

class InsightData {
  final InsightType type;
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String recommendation;

  const InsightData({
    required this.type,
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.recommendation,
  });
}

enum InsightType {
  caloriePattern,
  macroBalance,
  mealTiming,
  goalProgress,
  consistency,
}
