import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/entities/enums.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  const LoadUserProfile();
}

class SaveUserProfileEvent extends UserProfileEvent {
  final String name;
  final int age;
  final double weight;
  final double height;
  final Gender gender;
  final ActivityLevel activityLevel;
  final GoalType goalType;

  const SaveUserProfileEvent({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.goalType,
  });

  @override
  List<Object?> get props => [name, age, weight, height, gender, activityLevel, goalType];
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final UserProfile profile;

  const UpdateUserProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
