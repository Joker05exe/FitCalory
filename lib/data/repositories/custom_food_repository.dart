import 'package:hive/hive.dart';
import '../../domain/entities/food.dart';
import '../models/food_model.dart';

class CustomFoodRepository {
  static const String _boxName = 'custom_foods';
  Box<FoodModel>? _box;

  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<FoodModel>(_boxName);
    }
  }

  Future<void> saveFood(Food food, {bool isCustom = true}) async {
    await init();
    final model = FoodModel.fromEntity(food, isCustom: isCustom);
    await _box!.put(food.id, model);
  }

  Future<void> deleteFood(String id) async {
    await init();
    await _box!.delete(id);
  }

  Future<void> toggleFavorite(String id) async {
    await init();
    final food = _box!.get(id);
    if (food != null) {
      final updated = FoodModel(
        id: food.id,
        name: food.name,
        brand: food.brand,
        caloriesPer100g: food.caloriesPer100g,
        protein: food.protein,
        carbohydrates: food.carbohydrates,
        fats: food.fats,
        fiber: food.fiber,
        barcode: food.barcode,
        servingSizes: food.servingSizes,
        lastUpdated: DateTime.now(),
        isFavorite: !food.isFavorite,
        isCustom: food.isCustom,
      );
      await _box!.put(id, updated);
    }
  }

  Future<List<Food>> getAllFoods() async {
    await init();
    return _box!.values.map((model) => model.toEntity()).toList();
  }

  Future<List<Food>> getCustomFoods() async {
    await init();
    return _box!.values
        .where((model) => model.isCustom)
        .map((model) => model.toEntity())
        .toList();
  }

  Future<List<Food>> getFavorites() async {
    await init();
    return _box!.values
        .where((model) => model.isFavorite)
        .map((model) => model.toEntity())
        .toList();
  }

  Future<Food?> getFood(String id) async {
    await init();
    final model = _box!.get(id);
    return model?.toEntity();
  }

  Future<List<Food>> searchFoods(String query) async {
    await init();
    final lowerQuery = query.toLowerCase();
    return _box!.values
        .where((model) =>
            model.name.toLowerCase().contains(lowerQuery) ||
            (model.brand?.toLowerCase().contains(lowerQuery) ?? false))
        .map((model) => model.toEntity())
        .toList();
  }

  Stream<List<Food>> watchAllFoods() async* {
    await init();
    yield* Stream.periodic(const Duration(milliseconds: 500), (_) {
      return _box!.values.map((model) => model.toEntity()).toList();
    });
  }

  Stream<List<Food>> watchFavorites() async* {
    await init();
    yield* Stream.periodic(const Duration(milliseconds: 500), (_) {
      return _box!.values
          .where((model) => model.isFavorite)
          .map((model) => model.toEntity())
          .toList();
    });
  }
}
