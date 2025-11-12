import 'package:flutter/material.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../../screens/stats/stats_screen.dart';

class AverageCaloriesCard extends StatelessWidget {
  final StatsPeriod period;
  final AnalyticsState state;

  const AverageCaloriesCard({
    super.key,
    required this.period,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final averageCalories = _getAverageCalories();
    final mockGoal = 2000; // TODO: Get from user profile
    final difference = (averageCalories - mockGoal).round();
    final isAboveGoal = difference > 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Promedio',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${averageCalories.round()}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Text(
              'kcal/día',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            if (averageCalories > 0)
              Row(
                children: [
                  Icon(
                    isAboveGoal ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: isAboveGoal
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${difference.abs()} kcal ${isAboveGoal ? 'sobre' : 'bajo'} objetivo',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isAboveGoal
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              )
            else
              Text(
                'Sin datos',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  double _getAverageCalories() {
    if (state is ProgressStatsLoaded) {
      return (state as ProgressStatsLoaded).stats.averageCalories;
    }
    return 0;
  }
}
