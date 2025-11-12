import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/entities/food.dart';
import '../../../domain/entities/macronutrients.dart';
import '../../models/food_model.dart';
import '../../repositories/food_repository_impl.dart';

class FoodSeedService {
  static Future<void> seedFoodDatabase(FoodRepositoryImpl repository) async {
    try {
      // Check if database is already seeded
      final existingFoods = await repository.searchFoods('arroz');
      if (existingFoods.isRight()) {
        final foods = existingFoods.getOrElse(() => []);
        if (foods.isNotEmpty) {
          // Database already has data
          return;
        }
      }

      // Load JSON file
      final jsonString =
          await rootBundle.loadString('assets/data/foods_seed.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      // Parse and add foods
      for (final item in jsonData) {
        final food = Food(
          id: item['id'],
          name: item['name'],
          brand: item['brand'],
          caloriesPer100g: (item['caloriesPer100g'] as num).toDouble(),
          macrosPer100g: Macronutrients(
            protein: (item['proteinPer100g'] as num).toDouble(),
            carbohydrates: (item['carbsPer100g'] as num).toDouble(),
            fats: (item['fatsPer100g'] as num).toDouble(),
            fiber: (item['fiberPer100g'] as num).toDouble(),
          ),
          barcode: item['barcode'],
          servingSizes: (item['servingSizes'] as List)
              .map((s) => ServingSize(
                    name: s['name'],
                    grams: (s['grams'] as num).toDouble(),
                    unit: s['unit'],
                  ))
              .toList(),
          lastUpdated: DateTime.now(),
        );

        await repository.addFood(food);
      }

      print('Food database seeded successfully with ${jsonData.length} items');
    } catch (e) {
      print('Error seeding food database: $e');
    }
  }
}
