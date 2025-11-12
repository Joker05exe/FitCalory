import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/date_range.dart';
import '../entities/weekly_summary.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, WeeklySummary>> getWeeklySummary(DateTime startDate);
  Future<Either<Failure, MonthlySummary>> getMonthlySummary(
    int year,
    int month,
  );
  Future<Either<Failure, ProgressStats>> getProgressStats(DateRange range);
  Future<Either<Failure, List<Insight>>> generateInsights(DateRange range);
}

class MonthlySummary {
  final int year;
  final int month;
  final double averageCalories;
  final int daysMetGoal;
  final List<WeeklySummary> weeklySummaries;

  const MonthlySummary({
    required this.year,
    required this.month,
    required this.averageCalories,
    required this.daysMetGoal,
    required this.weeklySummaries,
  });
}

class ProgressStats {
  final double averageCalories;
  final double calorieVariance;
  final List<WeightEntry> weightHistory;
  final double weightChange;
  final int streakDays;
  final double goalAdherence;

  const ProgressStats({
    required this.averageCalories,
    required this.calorieVariance,
    required this.weightHistory,
    required this.weightChange,
    required this.streakDays,
    required this.goalAdherence,
  });
}

class WeightEntry {
  final double weight;
  final DateTime recordedAt;

  const WeightEntry({
    required this.weight,
    required this.recordedAt,
  });
}

class Insight {
  final InsightType type;
  final String message;
  final String recommendation;
  final double relevanceScore;

  const Insight({
    required this.type,
    required this.message,
    required this.recommendation,
    required this.relevanceScore,
  });
}

enum InsightType {
  caloriePattern,
  macroBalance,
  mealTiming,
  goalProgress,
  consistency,
}
