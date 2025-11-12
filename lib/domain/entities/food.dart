import 'package:equatable/equatable.dart';
import 'macronutrients.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final String? brand;
  final double caloriesPer100g;
  final Macronutrients macrosPer100g;
  final String? barcode;
  final List<ServingSize> servingSizes;
  final DateTime lastUpdated;
  final bool isFavorite;

  const Food({
    required this.id,
    required this.name,
    this.brand,
    required this.caloriesPer100g,
    required this.macrosPer100g,
    this.barcode,
    required this.servingSizes,
    required this.lastUpdated,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        caloriesPer100g,
        macrosPer100g,
        barcode,
        servingSizes,
        lastUpdated,
        isFavorite,
      ];

  Food copyWith({
    String? id,
    String? name,
    String? brand,
    double? caloriesPer100g,
    Macronutrients? macrosPer100g,
    String? barcode,
    List<ServingSize>? servingSizes,
    DateTime? lastUpdated,
    bool? isFavorite,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      macrosPer100g: macrosPer100g ?? this.macrosPer100g,
      barcode: barcode ?? this.barcode,
      servingSizes: servingSizes ?? this.servingSizes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ServingSize extends Equatable {
  final String name;
  final double grams;
  final String unit;

  const ServingSize({
    required this.name,
    required this.grams,
    required this.unit,
  });

  @override
  List<Object?> get props => [name, grams, unit];

  ServingSize copyWith({
    String? name,
    double? grams,
    String? unit,
  }) {
    return ServingSize(
      name: name ?? this.name,
      grams: grams ?? this.grams,
      unit: unit ?? this.unit,
    );
  }
}
