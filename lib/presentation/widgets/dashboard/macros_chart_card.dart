import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/daily_summary.dart';
import '../../../core/theme/app_theme.dart';

class MacrosChartCard extends StatelessWidget {
  final DailySummary summary;

  const MacrosChartCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final macros = summary.totalMacros;
    final goal = summary.goal;
    
    // Calculate calories from macros (protein: 4 kcal/g, carbs: 4 kcal/g, fats: 9 kcal/g)
    final proteinCalories = macros.protein * 4;
    final carbsCalories = macros.carbohydrates * 4;
    final fatsCalories = macros.fats * 9;
    final totalMacroCalories = proteinCalories + carbsCalories + fatsCalories;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppTheme.secondaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.secondaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Macronutrientes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Distribución de tu dieta',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
            
            if (totalMacroCalories > 0)
              Row(
                children: [
                  // Pie chart
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 35,
                        sections: _buildPieChartSections(
                          context,
                          proteinCalories,
                          carbsCalories,
                          fatsCalories,
                          totalMacroCalories,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  
                  // Legend and stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMacroStat(
                          context,
                          'Proteínas',
                          macros.protein,
                          goal.proteinGrams,
                          const Color(0xFF2196F3),
                        ),
                        const SizedBox(height: 12),
                        _buildMacroStat(
                          context,
                          'Carbohidratos',
                          macros.carbohydrates,
                          goal.carbsGrams,
                          const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 12),
                        _buildMacroStat(
                          context,
                          'Grasas',
                          macros.fats,
                          goal.fatsGrams,
                          const Color(0xFFFFC107),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.pie_chart_outline,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No hay datos para mostrar',
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

  List<PieChartSectionData> _buildPieChartSections(
    BuildContext context,
    double proteinCalories,
    double carbsCalories,
    double fatsCalories,
    double total,
  ) {
    return [
      PieChartSectionData(
        value: proteinCalories,
        title: '${(proteinCalories / total * 100).toInt()}%',
        color: const Color(0xFF2196F3),
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: carbsCalories,
        title: '${(carbsCalories / total * 100).toInt()}%',
        color: const Color(0xFF4CAF50),
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: fatsCalories,
        title: '${(fatsCalories / total * 100).toInt()}%',
        color: const Color(0xFFFFC107),
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildMacroStat(
    BuildContext context,
    String label,
    double current,
    double goal,
    Color color,
  ) {
    final percentage = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final isComplete = current >= goal;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ),
              if (isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${current.toInt()}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'g',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color.withOpacity(0.7),
                      ),
                ),
              ),
              const Spacer(),
              Text(
                '${(percentage * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: percentage),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Objetivo: ${goal.toInt()}g',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
