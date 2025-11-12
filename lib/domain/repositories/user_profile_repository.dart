import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/calorie_goal.dart';
import '../entities/enums.dart';
import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile);
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, CalorieGoal>> calculateCalorieGoal(
    UserProfile profile,
    GoalType goalType,
  );
}
