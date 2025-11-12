import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/date_range.dart';
import '../../domain/entities/daily_summary.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/macronutrients.dart';
import '../../domain/entities/weekly_summary.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/repositories/food_log_repository.dart';
import '../datasources/local/hive_service.dart';
import '../models/food_entry_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FoodLogRepository foodLogRepository;
  final Box<FoodEntryModel> _entriesBox;

  AnalyticsRepositoryImpl({
    required this.foodLogRepository,
    Box<FoodEntryModel>? entriesBox,
  }) : _entriesBox = entriesBox ?? HiveService.getBox(HiveService.foodEntriesBox);

  @override
  Future<Either<Failure, WeeklySummary>> getWeeklySummary(
      DateTime startDate) async {
    try {
      final dateRange = DateRange.weekFrom(startDate);
      final dailySummaries = <DailySummary>[];

      // Get daily summaries for each day in the week
      for (int i = 0; i < 7; i++) {
        final date = startDate.add(Duration(days: i));
        final summaryResult = await foodLogRepository.getDailySummary(date);

        summaryResult.fold(
          (failure) {
            // If no data for a day, create empty summary
            // This is not an error, just no entries for that day
          },
          (summary) => dailySummaries.add(summary),
        );
      }

      // Calculate weekly statistics
      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFats = 0;
      double totalFiber = 0;
      int daysMetGoal = 0;
      final caloriesByMeal = <MealType, double>{
        MealType.breakfast: 0,
        MealType.lunch: 0,
        MealType.dinner: 0,
        MealType.snack: 0,
      };

      for (final summary in dailySummaries) {
        totalCalories += summary.totalCalories;
        totalProtein += summary.totalMacros.protein;
        totalCarbs += summary.totalMacros.carbohydrates;
        totalFats += summary.totalMacros.fats;
        totalFiber += summary.totalMacros.fiber;

        // Check if goal was met (within 10% tolerance)
        if (summary.totalCalories >= summary.goal.dailyCalories * 0.9 &&
            summary.totalCalories <= summary.goal.dailyCalories * 1.1) {
          daysMetGoal++;
        }

        // Aggregate calories by meal type
        for (final entry in summary.entries) {
          caloriesByMeal[entry.mealType] =
              (caloriesByMeal[entry.mealType] ?? 0) +
                  entry.calculatedValues.calories;
        }
      }

      final daysWithData = dailySummaries.length;
      final averageCalories =
          daysWithData > 0 ? totalCalories / daysWithData : 0;

      final averageMacros = Macronutrients(
        protein: daysWithData > 0 ? totalProtein / daysWithData : 0,
        carbohydrates: daysWithData > 0 ? totalCarbs / daysWithData : 0,
        fats: daysWithData > 0 ? totalFats / daysWithData : 0,
        fiber: daysWithData > 0 ? totalFiber / daysWithData : 0,
      );

      final weeklySummary = WeeklySummary(
        dateRange: dateRange,
        averageCalories: averageCalories.toDouble(),
        averageMacros: averageMacros,
        daysMetGoal: daysMetGoal,
        dailySummaries: dailySummaries,
        caloriesByMeal: caloriesByMeal,
      );

      return Right(weeklySummary);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to generate weekly summary',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MonthlySummary>> getMonthlySummary(
    int year,
    int month,
  ) async {
    try {
      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0);
      final weeklySummaries = <WeeklySummary>[];

      // Get weekly summaries for the month
      DateTime currentWeekStart = firstDay;
      while (currentWeekStart.isBefore(lastDay) ||
          currentWeekStart.isAtSameMomentAs(lastDay)) {
        final weekResult = await getWeeklySummary(currentWeekStart);
        weekResult.fold(
          (failure) {
            // Continue even if a week fails
          },
          (summary) => weeklySummaries.add(summary),
        );
        currentWeekStart = currentWeekStart.add(const Duration(days: 7));
      }

      // Calculate monthly statistics
      double totalCalories = 0;
      int totalDaysMetGoal = 0;
      int totalDays = 0;

      for (final weekSummary in weeklySummaries) {
        totalCalories +=
            weekSummary.averageCalories * weekSummary.dailySummaries.length;
        totalDaysMetGoal += weekSummary.daysMetGoal;
        totalDays += weekSummary.dailySummaries.length;
      }

      final averageCalories = totalDays > 0 ? totalCalories / totalDays : 0;

      final monthlySummary = MonthlySummary(
        year: year,
        month: month,
        averageCalories: averageCalories.toDouble(),
        daysMetGoal: totalDaysMetGoal,
        weeklySummaries: weeklySummaries,
      );

      return Right(monthlySummary);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to generate monthly summary',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ProgressStats>> getProgressStats(
      DateRange range) async {
    try {
      final allEntries = _entriesBox.values.toList();
      final entriesInRange = allEntries.where((entry) {
        return range.contains(entry.timestamp);
      }).toList();

      if (entriesInRange.isEmpty) {
        return Right(
          ProgressStats(
            averageCalories: 0,
            calorieVariance: 0,
            weightHistory: const [],
            weightChange: 0,
            streakDays: 0,
            goalAdherence: 0,
          ),
        );
      }

      // Calculate daily calories
      final dailyCalories = <DateTime, double>{};
      for (final entry in entriesInRange) {
        final date = DateTime(
          entry.timestamp.year,
          entry.timestamp.month,
          entry.timestamp.day,
        );
        dailyCalories[date] =
            (dailyCalories[date] ?? 0) + entry.calculatedValues.calories;
      }

      // Calculate average and variance
      final calorieValues = dailyCalories.values.toList();
      final averageCalories =
          calorieValues.reduce((a, b) => a + b) / calorieValues.length;

      final variance = calorieValues
              .map((cal) => (cal - averageCalories) * (cal - averageCalories))
              .reduce((a, b) => a + b) /
          calorieValues.length;

      // Calculate streak (consecutive days with entries)
      int streakDays = 0;
      DateTime checkDate = DateTime.now();
      while (true) {
        final dateKey = DateTime(
          checkDate.year,
          checkDate.month,
          checkDate.day,
        );
        if (dailyCalories.containsKey(dateKey)) {
          streakDays++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      // Calculate goal adherence (simplified - would need goal data)
      final goalAdherence = 0.75; // Placeholder

      // Weight history (would need actual weight tracking)
      final weightHistory = <WeightEntry>[];

      final stats = ProgressStats(
        averageCalories: averageCalories,
        calorieVariance: variance,
        weightHistory: weightHistory,
        weightChange: 0,
        streakDays: streakDays,
        goalAdherence: goalAdherence,
      );

      return Right(stats);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to calculate progress stats',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Insight>>> generateInsights(
      DateRange range) async {
    try {
      final insights = <Insight>[];

      // Get progress stats for analysis
      final statsResult = await getProgressStats(range);
      await statsResult.fold(
        (failure) async => null,
        (stats) async {
          // Insight 1: Calorie consistency
          if (stats.calorieVariance < 10000) {
            insights.add(
              const Insight(
                type: InsightType.consistency,
                message: 'Tu consumo de calorías es muy consistente',
                recommendation:
                    'Mantén esta consistencia para mejores resultados',
                relevanceScore: 0.8,
              ),
            );
          } else if (stats.calorieVariance > 50000) {
            insights.add(
              const Insight(
                type: InsightType.consistency,
                message: 'Tu consumo de calorías varía mucho día a día',
                recommendation:
                    'Intenta mantener un consumo más consistente para mejores resultados',
                relevanceScore: 0.9,
              ),
            );
          }

          // Insight 2: Streak
          if (stats.streakDays >= 7) {
            insights.add(
              Insight(
                type: InsightType.goalProgress,
                message: '¡Excelente! Llevas ${stats.streakDays} días consecutivos registrando',
                recommendation: 'Sigue así, la consistencia es clave',
                relevanceScore: 0.9,
              ),
            );
          } else if (stats.streakDays == 0) {
            insights.add(
              const Insight(
                type: InsightType.goalProgress,
                message: 'No has registrado alimentos hoy',
                recommendation:
                    'Registra tus comidas para mantener el seguimiento',
                relevanceScore: 0.7,
              ),
            );
          }

          // Insight 3: Average calories
          if (stats.averageCalories > 0) {
            insights.add(
              Insight(
                type: InsightType.caloriePattern,
                message:
                    'Tu promedio diario es ${stats.averageCalories.toStringAsFixed(0)} calorías',
                recommendation: 'Compara esto con tu objetivo diario',
                relevanceScore: 0.6,
              ),
            );
          }
        },
      );

      // Sort by relevance
      insights.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

      return Right(insights);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to generate insights',
          technicalDetails: e.toString(),
        ),
      );
    }
  }
}
