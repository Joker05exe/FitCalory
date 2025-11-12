import 'package:hive/hive.dart';
import '../../domain/entities/food.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../models/food_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final Box<FoodModel> _foodBox;

  FavoritesRepositoryImpl(this._foodBox);

  @override
  Future<List<Food>> getFavorites() async {
    try {
      final allFoods = _foodBox.values.toList();
      final favorites = allFoods
          .where((food) => food.isFavorite)
          .map((model) => model.toEntity())
          .toList();
      
      // Ordenar por última actualización
      favorites.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      
      return favorites;
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  @override
  Future<void> addFavorite(Food food) async {
    try {
      final foodModel = FoodModel.fromEntity(food.copyWith(isFavorite: true));
      await _foodBox.put(food.id, foodModel);
      print('✅ Added to favorites: ${food.name}');
    } catch (e) {
      print('❌ Error adding favorite: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String foodId) async {
    try {
      final foodModel = _foodBox.get(foodId);
      if (foodModel != null) {
        final updatedFood = FoodModel(
          id: foodModel.id,
          name: foodModel.name,
          brand: foodModel.brand,
          caloriesPer100g: foodModel.caloriesPer100g,
          protein: foodModel.protein,
          carbohydrates: foodModel.carbohydrates,
          fats: foodModel.fats,
          fiber: foodModel.fiber,
          barcode: foodModel.barcode,
          servingSizes: foodModel.servingSizes,
          lastUpdated: foodModel.lastUpdated,
          isFavorite: false,
          isCustom: foodModel.isCustom,
        );
        await _foodBox.put(foodId, updatedFood);
        print('✅ Removed from favorites: $foodId');
      }
    } catch (e) {
      print('❌ Error removing favorite: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String foodId) async {
    try {
      final foodModel = _foodBox.get(foodId);
      return foodModel?.isFavorite ?? false;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  @override
  Stream<List<Food>> watchFavorites() async* {
    while (true) {
      yield await getFavorites();
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
