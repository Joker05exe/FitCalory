import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'food.dart';
import 'macronutrients.dart';

class FoodEntry extends Equatable {
  final String id;
  final String userId;
  final Food food;
  final double quantity;
  final String unit;
  final NutritionalValues calculatedValues;
  final DateTime timestamp;
  final MealType mealType;
  final EntrySource source;

  const FoodEntry({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        food,
        quantity,
        unit,
        calculatedValues,
        timestamp,
        mealType,
        source,
      ];

  FoodEntry copyWith({
    String? id,
    String? userId,
    Food? food,
    double? quantity,
    String? unit,
    NutritionalValues? calculatedValues,
    DateTime? timestamp,
    MealType? mealType,
    EntrySource? source,
  }) {
    return FoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calculatedValues: calculatedValues ?? this.calculatedValues,
      timestamp: timestamp ?? this.timestamp,
      mealType: mealType ?? this.mealType,
      source: source ?? this.source,
    );
  }
}

class NutritionalValues extends Equatable {
  final double calories;
  final Macronutrients macros;

  const NutritionalValues({
    required this.calories,
    required this.macros,
  });

  @override
  List<Object?> get props => [calories, macros];

  NutritionalValues copyWith({
    double? calories,
    Macronutrients? macros,
  }) {
    return NutritionalValues(
      calories: calories ?? this.calories,
      macros: macros ?? this.macros,
    );
  }
}
