import 'package:hive/hive.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/food_entry.dart';
import 'food_model.dart';
import 'nutritional_values_model.dart';

part 'food_entry_model.g.dart';

@HiveType(typeId: 5)
class FoodEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final FoodModel food;

  @HiveField(3)
  final double quantity;

  @HiveField(4)
  final String unit;

  @HiveField(5)
  final NutritionalValuesModel calculatedValues;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final int mealType; // Store as int index

  @HiveField(8)
  final int source; // Store as int index

  FoodEntryModel({
    required this.id,
    required this.userId,
    required this.food,
    required this.quantity,
    required this.unit,
    required this.calculatedValues,
    required this.timestamp,
    required this.mealType,
    required this.source,
  });

  factory FoodEntryModel.fromEntity(FoodEntry entity) {
    return FoodEntryModel(
      id: entity.id,
      userId: entity.userId,
      food: FoodModel.fromEntity(entity.food),
      quantity: entity.quantity,
      unit: entity.unit,
      calculatedValues:
          NutritionalValuesModel.fromEntity(entity.calculatedValues),
      timestamp: entity.timestamp,
      mealType: entity.mealType.index,
      source: entity.source.index,
    );
  }

  FoodEntry toEntity() {
    return FoodEntry(
      id: id,
      userId: userId,
      food: food.toEntity(),
      quantity: quantity,
      unit: unit,
      calculatedValues: calculatedValues.toEntity(),
      timestamp: timestamp,
      mealType: MealType.values[mealType],
      source: EntrySource.values[source],
    );
  }
}
