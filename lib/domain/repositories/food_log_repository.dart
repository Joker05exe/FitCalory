import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/daily_summary.dart';
import '../entities/food_entry.dart';

abstract class FoodLogRepository {
  Future<Either<Failure, void>> logFood(FoodEntry entry);
  Future<Either<Failure, void>> updateFoodEntry(FoodEntry entry);
  Future<Either<Failure, void>> deleteFoodEntry(String entryId);
  Future<Either<Failure, List<FoodEntry>>> getFoodEntriesByDate(DateTime date);
  Future<Either<Failure, DailySummary>> getDailySummary(DateTime date);
  Stream<Either<Failure, DailySummary>> watchDailySummary(DateTime date);
}
