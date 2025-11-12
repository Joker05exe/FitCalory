import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/food.dart';

abstract class FoodRepository {
  Future<Either<Failure, List<Food>>> searchFoods(String query);
  Future<Either<Failure, Food>> getFoodById(String id);
  Future<Either<Failure, Food>> getFoodByBarcode(String barcode);
  Future<Either<Failure, void>> syncFoodDatabase();
  Stream<Either<Failure, List<Food>>> searchFoodsStream(String query);
}
