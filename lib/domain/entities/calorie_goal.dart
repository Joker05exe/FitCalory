import 'package:equatable/equatable.dart';

class CalorieGoal extends Equatable {
  final String id;
  final String userId;
  final double dailyCalories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatsGrams;
  final DateTime effectiveDate;
  final DateTime createdAt;

  const CalorieGoal({
    required this.id,
    required this.userId,
    required this.dailyCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.effectiveDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        dailyCalories,
        proteinGrams,
        carbsGrams,
        fatsGrams,
        effectiveDate,
        createdAt,
      ];

  CalorieGoal copyWith({
    String? id,
    String? userId,
    double? dailyCalories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatsGrams,
    DateTime? effectiveDate,
    DateTime? createdAt,
  }) {
    return CalorieGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatsGrams: fatsGrams ?? this.fatsGrams,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
