import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/calorie_goal.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/local/hive_service.dart';
import '../models/calorie_goal_model.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final Box<UserProfileModel> _profileBox;
  final Box<CalorieGoalModel> _goalBox;

  UserProfileRepositoryImpl({
    Box<UserProfileModel>? profileBox,
    Box<CalorieGoalModel>? goalBox,
  })  : _profileBox =
            profileBox ?? HiveService.getBox(HiveService.userProfileBox),
        _goalBox = goalBox ?? HiveService.getBox(HiveService.calorieGoalsBox);

  static const String _userProfileKey = 'current_user_profile';

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final model = _profileBox.get(_userProfileKey);
      if (model == null) {
        return const Left(
          CacheFailure(message: 'No user profile found'),
        );
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to retrieve user profile',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile) async {
    try {
      // Validate profile data
      final validationError = _validateProfile(profile);
      if (validationError != null) {
        return Left(validationError);
      }

      final model = UserProfileModel.fromEntity(profile);
      await _profileBox.put(_userProfileKey, model);

      // Calculate and save initial calorie goal
      final goalResult = await calculateCalorieGoal(profile, profile.goalType);
      return goalResult.fold(
        (failure) => Left(failure),
        (goal) async {
          final goalModel = CalorieGoalModel.fromEntity(goal);
          await _goalBox.put(profile.id, goalModel);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to save user profile',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile) async {
    try {
      // Validate profile data
      final validationError = _validateProfile(profile);
      if (validationError != null) {
        return Left(validationError);
      }

      // Check if profile exists
      final existingProfile = _profileBox.get(_userProfileKey);
      if (existingProfile == null) {
        return const Left(
          CacheFailure(message: 'No existing profile to update'),
        );
      }

      final model = UserProfileModel.fromEntity(profile);
      await _profileBox.put(_userProfileKey, model);

      // Recalculate calorie goal if relevant fields changed
      final goalResult = await calculateCalorieGoal(profile, profile.goalType);
      return goalResult.fold(
        (failure) => Left(failure),
        (goal) async {
          final goalModel = CalorieGoalModel.fromEntity(goal);
          await _goalBox.put(profile.id, goalModel);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to update user profile',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CalorieGoal>> calculateCalorieGoal(
    UserProfile profile,
    GoalType goalType,
  ) async {
    try {
      // Calculate BMR using Harris-Benedict formula
      final bmr = _calculateBMR(profile);

      // Apply activity level multiplier
      final tdee = _calculateTDEE(bmr, profile.activityLevel);

      // Adjust for goal type
      final adjustedCalories = _adjustForGoal(tdee, goalType);

      // Calculate macro distribution
      final macros = _calculateMacros(adjustedCalories, goalType);

      final goal = CalorieGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: profile.id,
        dailyCalories: adjustedCalories,
        proteinGrams: macros['protein']!,
        carbsGrams: macros['carbs']!,
        fatsGrams: macros['fats']!,
        effectiveDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      return Right(goal);
    } catch (e) {
      return Left(
        ValidationFailure(
          message: 'Failed to calculate calorie goal',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  double _calculateBMR(UserProfile profile) {
    // Harris-Benedict formula
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
        return tdee - 500;
      case GoalType.maintainWeight:
        return tdee;
      case GoalType.gainMuscle:
        return tdee + 300;
    }
  }

  Map<String, double> _calculateMacros(double calories, GoalType goalType) {
    double proteinPercent;
    double carbsPercent;
    double fatsPercent;

    switch (goalType) {
      case GoalType.loseWeight:
        proteinPercent = 0.35;
        carbsPercent = 0.35;
        fatsPercent = 0.30;
        break;
      case GoalType.maintainWeight:
        proteinPercent = 0.30;
        carbsPercent = 0.40;
        fatsPercent = 0.30;
        break;
      case GoalType.gainMuscle:
        proteinPercent = 0.30;
        carbsPercent = 0.45;
        fatsPercent = 0.25;
        break;
    }

    final proteinGrams = (calories * proteinPercent) / 4;
    final carbsGrams = (calories * carbsPercent) / 4;
    final fatsGrams = (calories * fatsPercent) / 9;

    return {
      'protein': proteinGrams,
      'carbs': carbsGrams,
      'fats': fatsGrams,
    };
  }

  /// Validate user profile data
  Failure? _validateProfile(UserProfile profile) {
    if (profile.name.trim().isEmpty) {
      return const ValidationFailure(message: 'Name cannot be empty');
    }
    if (profile.age < 10 || profile.age > 120) {
      return const ValidationFailure(
          message: 'Age must be between 10 and 120');
    }
    if (profile.weight < 20 || profile.weight > 500) {
      return const ValidationFailure(
          message: 'Weight must be between 20 and 500 kg');
    }
    if (profile.height < 50 || profile.height > 300) {
      return const ValidationFailure(
          message: 'Height must be between 50 and 300 cm');
    }
    return null;
  }
}
