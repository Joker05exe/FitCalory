import 'package:hive/hive.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/macronutrients.dart';
import 'serving_size_model.dart';

part 'food_model.g.dart';

@HiveType(typeId: 10)
class FoodModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? brand;

  @HiveField(3)
  final double caloriesPer100g;

  @HiveField(4)
  final double protein;

  @HiveField(5)
  final double carbohydrates;

  @HiveField(6)
  final double fats;

  @HiveField(7)
  final double fiber;

  @HiveField(8)
  final String? barcode;

  @HiveField(9)
  final List<ServingSizeModel> servingSizes;

  @HiveField(10)
  final DateTime lastUpdated;

  @HiveField(11)
  final bool isFavorite;

  @HiveField(12)
  final bool isCustom;

  FoodModel({
    required this.id,
    required this.name,
    this.brand,
    required this.caloriesPer100g,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,
    this.barcode,
    required this.servingSizes,
    required this.lastUpdated,
    this.isFavorite = false,
    this.isCustom = false,
  });

  factory FoodModel.fromEntity(Food food, {bool isCustom = false}) {
    return FoodModel(
      id: food.id,
      name: food.name,
      brand: food.brand,
      caloriesPer100g: food.caloriesPer100g,
      protein: food.macrosPer100g.protein,
      carbohydrates: food.macrosPer100g.carbohydrates,
      fats: food.macrosPer100g.fats,
      fiber: food.macrosPer100g.fiber,
      barcode: food.barcode,
      servingSizes: food.servingSizes
          .map((s) => ServingSizeModel.fromEntity(s))
          .toList(),
      lastUpdated: food.lastUpdated,
      isFavorite: food.isFavorite,
      isCustom: isCustom,
    );
  }

  Food toEntity() {
    return Food(
      id: id,
      name: name,
      brand: brand,
      caloriesPer100g: caloriesPer100g,
      macrosPer100g: Macronutrients(
        protein: protein,
        carbohydrates: carbohydrates,
        fats: fats,
        fiber: fiber,
      ),
      barcode: barcode,
      servingSizes: servingSizes.map((s) => s.toEntity()).toList(),
      lastUpdated: lastUpdated,
      isFavorite: isFavorite,
    );
  }
}


