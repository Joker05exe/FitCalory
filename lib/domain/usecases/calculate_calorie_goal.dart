import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/calorie_goal.dart';
import '../entities/enums.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'usecase.dart';

class CalculateCalorieGoal
    implements UseCase<CalorieGoal, CalculateCalorieGoalParams> {
  final UserProfileRepository repository;

  CalculateCalorieGoal(this.repository);

  @override
  Future<Either<Failure, CalorieGoal>> call(
      CalculateCalorieGoalParams params) async {
    // Calculate BMR using Harris-Benedict formula
    final bmr = _calculateBMR(params.profile);

    // Apply activity level multiplier
    final tdee = _calculateTDEE(bmr, params.profile.activityLevel);

    // Adjust for goal type
    final adjustedCalories = _adjustForGoal(tdee, params.goalType);

    // Calculate macro distribution
    final macros = _calculateMacros(adjustedCalories, params.goalType);

    final goal = CalorieGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: params.profile.id,
      dailyCalories: adjustedCalories,
      proteinGrams: macros['protein']!,
      carbsGrams: macros['carbs']!,
      fatsGrams: macros['fats']!,
      effectiveDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    return Right(goal);
  }

  double _calculateBMR(UserProfile profile) {
    // Harris-Benedict formula
    // Men: BMR = 88.362 + (13.397 × weight in kg) + (4.799 × height in cm) - (5.677 × age in years)
    // Women: BMR = 447.593 + (9.247 × weight in kg) + (3.098 × height in cm) - (4.330 × age in years)

    if (profile.gender == Gender.male) {
      return 88.362 +
          (13.397 * profile.weight) +
          (4.799 * profile.height) -
          (5.677 * profile.age);
    } else {
      return 447.593 +
          (9.247 * profile.weight) +
          (3.098 * profile.height) -
          (4.330 * profile.age);
    }
  }

  double _calculateTDEE(double bmr, ActivityLevel activityLevel) {
    // Activity level multipliers
    const multipliers = {
      ActivityLevel.sedentary: 1.2,
      ActivityLevel.light: 1.375,
      ActivityLevel.moderate: 1.55,
      ActivityLevel.active: 1.725,
      ActivityLevel.veryActive: 1.9,
    };

    return bmr * multipliers[activityLevel]!;
  }

  double _adjustForGoal(double tdee, GoalType goalType) {
    switch (goalType) {
      case GoalType.loseWeight:
        return tdee - 500; // 500 calorie deficit for ~0.5kg/week loss
      case GoalType.maintainWeight:
        return tdee;
      case GoalType.gainMuscle:
        return tdee + 300; // 300 calorie surplus for muscle gain
    }
  }

  Map<String, double> _calculateMacros(double calories, GoalType goalType) {
    // Macro distribution based on goal type
    double proteinPercent;
    double carbsPercent;
    double fatsPercent;

    switch (goalType) {
      case GoalType.loseWeight:
        proteinPercent = 0.35; // 35% protein
        carbsPercent = 0.35; // 35% carbs
        fatsPercent = 0.30; // 30% fats
        break;
      case GoalType.maintainWeight:
        proteinPercent = 0.30; // 30% protein
        carbsPercent = 0.40; // 40% carbs
        fatsPercent = 0.30; // 30% fats
        break;
      case GoalType.gainMuscle:
        proteinPercent = 0.30; // 30% protein
        carbsPercent = 0.45; // 45% carbs
        fatsPercent = 0.25; // 25% fats
        break;
    }

    // Convert percentages to grams
    // Protein: 4 cal/g, Carbs: 4 cal/g, Fats: 9 cal/g
    final proteinGrams = (calories * proteinPercent) / 4;
    final carbsGrams = (calories * carbsPercent) / 4;
    final fatsGrams = (calories * fatsPercent) / 9;

    return {
      'protein': proteinGrams,
      'carbs': carbsGrams,
      'fats': fatsGrams,
    };
  }
}

class CalculateCalorieGoalParams extends Equatable {
  final UserProfile profile;
  final GoalType goalType;

  const CalculateCalorieGoalParams({
    required this.profile,
    required this.goalType,
  });

  @override
  List<Object?> get props => [profile, goalType];
}
