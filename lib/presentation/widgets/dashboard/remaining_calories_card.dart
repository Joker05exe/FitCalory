import 'package:flutter/material.dart';
import '../../../domain/entities/daily_summary.dart';
import '../../../core/theme/app_theme.dart';

class RemainingCaloriesCard extends StatelessWidget {
  final DailySummary summary;

  const RemainingCaloriesCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = summary.remainingCalories;
    final isOverGoal = remaining < 0;
    final displayValue = remaining.abs().toInt();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOverGoal
                ? [
                    AppTheme.errorColor.withOpacity(0.05),
                    AppTheme.warningColor.withOpacity(0.05),
                  ]
                : [
                    AppTheme.successColor.withOpacity(0.05),
                    AppTheme.secondaryColor.withOpacity(0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isOverGoal
                  ? AppTheme.warningGradient
                  : AppTheme.successGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isOverGoal ? AppTheme.errorColor : AppTheme.successColor)
                      .withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              isOverGoal ? Icons.warning_rounded : Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isOverGoal ? 'Excedido' : 'Disponibles',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOverGoal
                            ? AppTheme.errorColor.withOpacity(0.2)
                            : AppTheme.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isOverGoal ? '⚠️' : '✓',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => (isOverGoal
                          ? AppTheme.warningGradient
                          : AppTheme.successGradient).createShader(bounds),
                      child: Text(
                        '$displayValue',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'kcal',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOverGoal
                        ? AppTheme.errorColor.withOpacity(0.1)
                        : AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isOverGoal
                          ? AppTheme.errorColor.withOpacity(0.3)
                          : AppTheme.successColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    isOverGoal
                        ? 'Has superado tu objetivo diario'
                        : 'Puedes consumir hasta tu objetivo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverGoal ? AppTheme.errorColor : AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
