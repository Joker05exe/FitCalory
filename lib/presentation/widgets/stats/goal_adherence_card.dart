import 'package:flutter/material.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../../screens/stats/stats_screen.dart';

class GoalAdherenceCard extends StatelessWidget {
  final StatsPeriod period;
  final AnalyticsState state;

  const GoalAdherenceCard({
    super.key,
    required this.period,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from repository
    final mockAdherence = _getMockAdherence(period);
    final mockDaysMetGoal = _getMockDaysMetGoal(period);
    final totalDays = period.days;

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
                  Icons.check_circle_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Adherencia',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${mockAdherence.toInt()}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getAdherenceColor(context, mockAdherence),
                  ),
            ),
            Text(
              'al objetivo',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$mockDaysMetGoal de $totalDays días',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAdherenceColor(BuildContext context, double adherence) {
    if (adherence >= 80) {
      return const Color(0xFF4CAF50); // Green
    } else if (adherence >= 60) {
      return const Color(0xFFFFC107); // Amber
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }

  double _getMockAdherence(StatsPeriod period) {
    // TODO: Replace with actual data
    switch (period) {
      case StatsPeriod.week:
        return 71.4;
      case StatsPeriod.month:
        return 76.7;
      case StatsPeriod.threeMonths:
        return 82.2;
    }
  }

  int _getMockDaysMetGoal(StatsPeriod period) {
    // TODO: Replace with actual data
    switch (period) {
      case StatsPeriod.week:
        return 5;
      case StatsPeriod.month:
        return 23;
      case StatsPeriod.threeMonths:
        return 74;
    }
  }
}
