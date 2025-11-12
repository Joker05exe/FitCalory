import 'package:equatable/equatable.dart';
import 'calorie_goal.dart';
import 'food_entry.dart';
import 'macronutrients.dart';

class DailySummary extends Equatable {
  final DateTime date;
  final double totalCalories;
  final Macronutrients totalMacros;
  final List<FoodEntry> entries;
  final CalorieGoal goal;
  final double remainingCalories;

  const DailySummary({
    required this.date,
    required this.totalCalories,
    required this.totalMacros,
    required this.entries,
    required this.goal,
    required this.remainingCalories,
  });

  @override
  List<Object?> get props => [
        date,
        totalCalories,
        totalMacros,
        entries,
        goal,
        remainingCalories,
      ];

  DailySummary copyWith({
    DateTime? date,
    double? totalCalories,
    Macronutrients? totalMacros,
    List<FoodEntry>? entries,
    CalorieGoal? goal,
    double? remainingCalories,
  }) {
    return DailySummary(
      date: date ?? this.date,
      totalCalories: totalCalories ?? this.totalCalories,
      totalMacros: totalMacros ?? this.totalMacros,
      entries: entries ?? this.entries,
      goal: goal ?? this.goal,
      remainingCalories: remainingCalories ?? this.remainingCalories,
    );
  }
}
