import 'package:equatable/equatable.dart';
import 'daily_summary.dart';
import 'date_range.dart';
import 'enums.dart';
import 'macronutrients.dart';

class WeeklySummary extends Equatable {
  final DateRange dateRange;
  final double averageCalories;
  final Macronutrients averageMacros;
  final int daysMetGoal;
  final List<DailySummary> dailySummaries;
  final Map<MealType, double> caloriesByMeal;

  const WeeklySummary({
    required this.dateRange,
    required this.averageCalories,
    required this.averageMacros,
    required this.daysMetGoal,
    required this.dailySummaries,
    required this.caloriesByMeal,
  });

  @override
  List<Object?> get props => [
        dateRange,
        averageCalories,
        averageMacros,
        daysMetGoal,
        dailySummaries,
        caloriesByMeal,
      ];

  WeeklySummary copyWith({
    DateRange? dateRange,
    double? averageCalories,
    Macronutrients? averageMacros,
    int? daysMetGoal,
    List<DailySummary>? dailySummaries,
    Map<MealType, double>? caloriesByMeal,
  }) {
    return WeeklySummary(
      dateRange: dateRange ?? this.dateRange,
      averageCalories: averageCalories ?? this.averageCalories,
      averageMacros: averageMacros ?? this.averageMacros,
      daysMetGoal: daysMetGoal ?? this.daysMetGoal,
      dailySummaries: dailySummaries ?? this.dailySummaries,
      caloriesByMeal: caloriesByMeal ?? this.caloriesByMeal,
    );
  }
}
