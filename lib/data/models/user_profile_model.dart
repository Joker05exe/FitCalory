import 'package:hive/hive.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final double weight;

  @HiveField(4)
  final double height;

  @HiveField(5)
  final int gender; // Store as int index

  @HiveField(6)
  final int activityLevel; // Store as int index

  @HiveField(7)
  final int goalType; // Store as int index

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  UserProfileModel({
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

  // Convert from domain entity to model
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      weight: entity.weight,
      height: entity.height,
      gender: entity.gender.index,
      activityLevel: entity.activityLevel.index,
      goalType: entity.goalType.index,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert from model to domain entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      age: age,
      weight: weight,
      height: height,
      gender: Gender.values[gender],
      activityLevel: ActivityLevel.values[activityLevel],
      goalType: GoalType.values[goalType],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
