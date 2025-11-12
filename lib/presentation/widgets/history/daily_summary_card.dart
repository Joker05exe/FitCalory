import 'package:flutter/material.dart';
import '../../../domain/entities/daily_summary.dart';
import '../../../domain/entities/enums.dart';

class DailySummaryCard extends StatelessWidget {
  final DailySummary summary;

  const DailySummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen del Día',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            
            // Calories summary
            _buildCaloriesSummary(context),
            const SizedBox(height: 20),
            
            // Macros summary
            _buildMacrosSummary(context),
            const SizedBox(height: 20),
            
            // Meals breakdown
            if (summary.entries.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 20),
              _buildMealsBreakdown(context),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No hay alimentos registrados',
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
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesSummary(BuildContext context) {
    final progress = summary.totalCalories / summary.goal.dailyCalories;
    final isOverGoal = summary.totalCalories > summary.goal.dailyCalories;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Consumidas',
            '${summary.totalCalories.toInt()}',
            'kcal',
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Objetivo',
            '${summary.goal.dailyCalories.toInt()}',
            'kcal',
            Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            isOverGoal ? 'Excedido' : 'Restantes',
            '${summary.remainingCalories.abs().toInt()}',
            'kcal',
            isOverGoal
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            unit,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosSummary(BuildContext context) {
    final macros = summary.totalMacros;
    final goal = summary.goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macronutrientes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        _buildMacroBar(
          context,
          'Proteínas',
          macros.protein,
          goal.proteinGrams,
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        _buildMacroBar(
          context,
          'Carbohidratos',
          macros.carbohydrates,
          goal.carbsGrams,
          const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 12),
        _buildMacroBar(
          context,
          'Grasas',
          macros.fats,
          goal.fatsGrams,
          const Color(0xFFFFC107),
        ),
      ],
    );
  }

  Widget _buildMacroBar(
    BuildContext context,
    String label,
    double current,
    double goal,
    Color color,
  ) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '${current.toInt()}g / ${goal.toInt()}g ($percentage%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildMealsBreakdown(BuildContext context) {
    final mealGroups = _groupByMealType(summary.entries);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desglose por Comida',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        ...MealType.values.map((mealType) {
          final entries = mealGroups[mealType] ?? [];
          if (entries.isEmpty) return const SizedBox.shrink();

          final totalCalories = entries.fold<double>(
            0,
            (sum, entry) => sum + entry.calculatedValues.calories,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  _getMealIcon(mealType),
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getMealName(mealType),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '${entries.length} ${entries.length == 1 ? 'alimento' : 'alimentos'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${totalCalories.toInt()} kcal',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Map<MealType, List<dynamic>> _groupByMealType(List<dynamic> entries) {
    final grouped = <MealType, List<dynamic>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.mealType, () => []).add(entry);
    }
    return grouped;
  }

  IconData _getMealIcon(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.wb_sunny;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie;
    }
  }

  String _getMealName(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return 'Desayuno';
      case MealType.lunch:
        return 'Almuerzo';
      case MealType.dinner:
        return 'Cena';
      case MealType.snack:
        return 'Snack';
    }
  }
}
