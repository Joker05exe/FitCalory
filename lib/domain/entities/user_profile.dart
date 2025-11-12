import 'package:equatable/equatable.dart';
import 'enums.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final Gender gender;
  final ActivityLevel activityLevel;
  final GoalType goalType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.goalType,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        weight,
        height,
        gender,
        activityLevel,
        goalType,
        createdAt,
        updatedAt,
      ];

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    double? weight,
    double? height,
    Gender? gender,
    ActivityLevel? activityLevel,
    GoalType? goalType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goalType: goalType ?? this.goalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
