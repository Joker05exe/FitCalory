import '../entities/food.dart';

abstract class FavoritesRepository {
  Future<List<Food>> getFavorites();
  Future<void> addFavorite(Food food);
  Future<void> removeFavorite(String foodId);
  Future<bool> isFavorite(String foodId);
  Stream<List<Food>> watchFavorites();
}
