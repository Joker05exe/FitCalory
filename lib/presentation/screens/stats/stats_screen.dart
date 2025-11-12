import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/date_range.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/analytics/analytics_event.dart';
import '../../bloc/analytics/analytics_state.dart';
import '../../widgets/stats/period_selector.dart';
import '../../widgets/stats/current_weight_card.dart';
import '../../widgets/stats/average_calories_card.dart';
import '../../widgets/stats/goal_adherence_card.dart';
import '../../widgets/stats/weight_progress_chart.dart';
import '../../widgets/stats/macros_distribution_card.dart';
import '../../widgets/stats/insights_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.week;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Cargar resumen semanal para obtener macros reales
    if (_selectedPeriod == StatsPeriod.week) {
      final startDate = DateTime.now().subtract(const Duration(days: 7));
      context.read<AnalyticsBloc>().add(LoadWeeklySummary(startDate));
    }
    
    final dateRange = DateRange.lastDays(_selectedPeriod.days);
    context.read<AnalyticsBloc>().add(LoadProgressStats(dateRange));
    context.read<AnalyticsBloc>().add(GenerateInsightsEvent(dateRange));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Period selector
              PeriodSelector(
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: (period) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                  _loadData();
                },
              ),
              const SizedBox(height: 20),
              
              // Current weight and BMI card
              const CurrentWeightCard(),
              const SizedBox(height: 16),
              
              // Loading or error state
              if (state is AnalyticsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state is AnalyticsError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar estadísticas',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Average calories and goal adherence
                Row(
                  children: [
                    Expanded(
                      child: AverageCaloriesCard(
                        period: _selectedPeriod,
                        state: state,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GoalAdherenceCard(
                        period: _selectedPeriod,
                        state: state,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Weight progress chart
                WeightProgressChart(
                  period: _selectedPeriod,
                  state: state,
                ),
                const SizedBox(height: 16),
                
                // Macros distribution
                MacrosDistributionCard(
                  period: _selectedPeriod,
                  state: state,
                ),
                const SizedBox(height: 16),
                
                // Insights
                InsightsCard(
                  period: _selectedPeriod,
                  state: state,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

enum StatsPeriod {
  week,
  month,
  threeMonths,
}

extension StatsPeriodExtension on StatsPeriod {
  String get label {
    switch (this) {
      case StatsPeriod.week:
        return '7 días';
      case StatsPeriod.month:
        return '30 días';
      case StatsPeriod.threeMonths:
        return '90 días';
    }
  }

  int get days {
    switch (this) {
      case StatsPeriod.week:
        return 7;
      case StatsPeriod.month:
        return 30;
      case StatsPeriod.threeMonths:
        return 90;
    }
  }
}
