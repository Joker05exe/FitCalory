import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/openfoodfacts_service.dart';
import '../models/food_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  final Box<FoodModel> _foodBox;
  final OpenFoodFactsService _openFoodFactsService;

  FoodRepositoryImpl({
    Box<FoodModel>? foodBox,
    OpenFoodFactsService? openFoodFactsService,
  })  : _foodBox = foodBox ?? HiveService.getBox(HiveService.foodsBox),
        _openFoodFactsService = openFoodFactsService ?? OpenFoodFactsService();

  @override
  Future<Either<Failure, List<Food>>> searchFoods(String query) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      print('🔍 Buscando en OpenFoodFacts: $query');

      // Buscar en OpenFoodFacts API
      final offResults = await _openFoodFactsService.searchProducts(query, pageSize: 30);
      
      print('✅ Encontrados ${offResults.length} productos en OpenFoodFacts');

      // También buscar en favoritos y alimentos personalizados locales
      final normalizedQuery = query.toLowerCase().trim();
      final localFoods = _foodBox.values.where((foodModel) {
        // Solo incluir favoritos y alimentos personalizados
        if (!foodModel.isFavorite && !foodModel.isCustom) return false;
        
        final name = foodModel.name.toLowerCase();
        final brand = foodModel.brand?.toLowerCase() ?? '';
        return name.contains(normalizedQuery) || brand.contains(normalizedQuery);
      }).map((model) => model.toEntity()).toList();

      print('✅ Encontrados ${localFoods.length} alimentos locales (favoritos/personalizados)');

      // Combinar resultados: locales primero, luego OpenFoodFacts
      final combinedResults = [...localFoods, ...offResults];

      // Eliminar duplicados por ID
      final uniqueResults = <String, Food>{};
      for (final food in combinedResults) {
        uniqueResults[food.id] = food;
      }

      return Right(uniqueResults.values.toList());
    } catch (e) {
      print('❌ Error buscando alimentos: $e');
      return Left(
        DatabaseFailure(
          message: 'Error al buscar alimentos',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Food>> getFoodById(String id) async {
    try {
      final model = _foodBox.get(id);
      if (model == null) {
        return const Left(
          CacheFailure(message: 'Food not found'),
        );
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to retrieve food',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Food>> getFoodByBarcode(String barcode) async {
    try {
      // First, try to find in local database
      final allFoods = _foodBox.values.toList();
      final localFood = allFoods.where((food) => food.barcode == barcode).firstOrNull;
      
      if (localFood != null) {
        return Right(localFood.toEntity());
      }

      // If not found locally, try OpenFoodFacts API
      final offFood = await _openFoodFactsService.getProductByBarcode(barcode);
      
      if (offFood != null) {
        // Save to local database for future use
        final foodModel = FoodModel.fromEntity(offFood);
        await _foodBox.put(offFood.id, foodModel);
        return Right(offFood);
      }

      // Not found anywhere
      return const Left(
        CacheFailure(message: 'Food with barcode not found'),
      );
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to retrieve food by barcode',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> syncFoodDatabase() async {
    try {
      // TODO: Implement sync with remote database
      // For now, this is a placeholder for future implementation
      return const Right(null);
    } catch (e) {
      return Left(
        SyncFailure(
          message: 'Failed to sync food database',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, List<Food>>> searchFoodsStream(String query) {
    final controller = StreamController<Either<Failure, List<Food>>>();

    // Initial search
    searchFoods(query).then((result) {
      if (!controller.isClosed) {
        controller.add(result);
      }
    });

    // Listen to box changes and re-search
    final subscription = _foodBox.watch().listen((_) {
      searchFoods(query).then((result) {
        if (!controller.isClosed) {
          controller.add(result);
        }
      });
    });

    controller.onCancel = () {
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }

  /// Add a food to the local database (helper method for seeding)
  Future<Either<Failure, void>> addFood(Food food) async {
    try {
      final model = FoodModel.fromEntity(food);
      await _foodBox.put(food.id, model);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to add food',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  /// Delete a food from the local database
  Future<Either<Failure, void>> deleteFood(String id) async {
    try {
      await _foodBox.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to delete food',
          technicalDetails: e.toString(),
        ),
      );
    }
  }
}
