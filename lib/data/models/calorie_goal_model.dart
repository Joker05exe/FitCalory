import 'package:hive/hive.dart';
import '../../domain/entities/calorie_goal.dart';

part 'calorie_goal_model.g.dart';

@HiveType(typeId: 6)
class CalorieGoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double dailyCalories;

  @HiveField(3)
  final double proteinGrams;

  @HiveField(4)
  final double carbsGrams;

  @HiveField(5)
  final double fatsGrams;

  @HiveField(6)
  final DateTime effectiveDate;

  @HiveField(7)
  final DateTime createdAt;

  CalorieGoalModel({
    required this.id,
    required this.userId,
    required this.dailyCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.effectiveDate,
    required this.createdAt,
  });

  factory CalorieGoalModel.fromEntity(CalorieGoal entity) {
    return CalorieGoalModel(
      id: entity.id,
      userId: entity.userId,
      dailyCalories: entity.dailyCalories,
      proteinGrams: entity.proteinGrams,
      carbsGrams: entity.carbsGrams,
      fatsGrams: entity.fatsGrams,
      effectiveDate: entity.effectiveDate,
      createdAt: entity.createdAt,
    );
  }

  CalorieGoal toEntity() {
    return CalorieGoal(
      id: id,
      userId: userId,
      dailyCalories: dailyCalories,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatsGrams: fatsGrams,
      effectiveDate: effectiveDate,
      createdAt: createdAt,
    );
  }
}
