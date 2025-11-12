import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/daily_summary.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/macronutrients.dart';
import '../../domain/repositories/food_log_repository.dart';
import '../datasources/local/hive_service.dart';
import '../models/calorie_goal_model.dart';
import '../models/food_entry_model.dart';

class FoodLogRepositoryImpl implements FoodLogRepository {
  final Box<FoodEntryModel> _entriesBox;
  final Box<CalorieGoalModel> _goalBox;

  FoodLogRepositoryImpl({
    Box<FoodEntryModel>? entriesBox,
    Box<CalorieGoalModel>? goalBox,
  })  : _entriesBox = entriesBox ?? HiveService.getBox(HiveService.foodEntriesBox),
        _goalBox = goalBox ?? HiveService.getBox(HiveService.calorieGoalsBox);

  @override
  Future<Either<Failure, void>> logFood(FoodEntry entry) async {
    try {
      // Validate entry
      final validationError = _validateEntry(entry);
      if (validationError != null) {
        return Left(validationError);
      }

      final model = FoodEntryModel.fromEntity(entry);
      await _entriesBox.put(entry.id, model);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to log food entry',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateFoodEntry(FoodEntry entry) async {
    try {
      // Validate entry
      final validationError = _validateEntry(entry);
      if (validationError != null) {
        return Left(validationError);
      }

      // Check if entry exists
      final existingEntry = _entriesBox.get(entry.id);
      if (existingEntry == null) {
        return const Left(
          CacheFailure(message: 'Food entry not found'),
        );
      }

      final model = FoodEntryModel.fromEntity(entry);
      await _entriesBox.put(entry.id, model);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to update food entry',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteFoodEntry(String entryId) async {
    try {
      final existingEntry = _entriesBox.get(entryId);
      if (existingEntry == null) {
        return const Left(
          CacheFailure(message: 'Food entry not found'),
        );
      }

      await _entriesBox.delete(entryId);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to delete food entry',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<FoodEntry>>> getFoodEntriesByDate(
      DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final allEntries = _entriesBox.values.toList();
      final entriesForDate = allEntries.where((entry) {
        return entry.timestamp.isAfter(startOfDay) &&
            entry.timestamp.isBefore(endOfDay);
      }).toList();

      // Sort by timestamp
      entriesForDate.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return Right(entriesForDate.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to retrieve food entries',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DailySummary>> getDailySummary(DateTime date) async {
    try {
      // Get entries for the date
      final entriesResult = await getFoodEntriesByDate(date);

      return entriesResult.fold(
        (failure) => Left(failure),
        (entries) {
          // Calculate totals
          double totalCalories = 0;
          double totalProtein = 0;
          double totalCarbs = 0;
          double totalFats = 0;
          double totalFiber = 0;

          for (final entry in entries) {
            totalCalories += entry.calculatedValues.calories;
            totalProtein += entry.calculatedValues.macros.protein;
            totalCarbs += entry.calculatedValues.macros.carbohydrates;
            totalFats += entry.calculatedValues.macros.fats;
            totalFiber += entry.calculatedValues.macros.fiber;
          }

          final totalMacros = Macronutrients(
            protein: totalProtein,
            carbohydrates: totalCarbs,
            fats: totalFats,
            fiber: totalFiber,
          );

          // Get user's calorie goal
          // For now, use the first goal found (in a real app, filter by userId)
          final goalModel = _goalBox.values.isNotEmpty
              ? _goalBox.values.first
              : null;

          if (goalModel == null) {
            return const Left(
              CacheFailure(message: 'No calorie goal found for user'),
            );
          }

          final goal = goalModel.toEntity();
          final remainingCalories = goal.dailyCalories - totalCalories;

          final summary = DailySummary(
            date: date,
            totalCalories: totalCalories,
            totalMacros: totalMacros,
            entries: entries,
            goal: goal,
            remainingCalories: remainingCalories,
          );

          return Right(summary);
        },
      );
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to generate daily summary',
          technicalDetails: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, DailySummary>> watchDailySummary(DateTime date) {
    final controller = StreamController<Either<Failure, DailySummary>>();

    // Initial summary
    getDailySummary(date).then((result) {
      if (!controller.isClosed) {
        controller.add(result);
      }
    });

    // Listen to entries box changes and recalculate
    final subscription = _entriesBox.watch().listen((_) {
      getDailySummary(date).then((result) {
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

  /// Validate food entry data
  Failure? _validateEntry(FoodEntry entry) {
    if (entry.userId.trim().isEmpty) {
      return const ValidationFailure(message: 'User ID cannot be empty');
    }
    if (entry.quantity <= 0) {
      return const ValidationFailure(message: 'Quantity must be greater than 0');
    }
    if (entry.unit.trim().isEmpty) {
      return const ValidationFailure(message: 'Unit cannot be empty');
    }
    if (entry.calculatedValues.calories < 0) {
      return const ValidationFailure(
          message: 'Calories cannot be negative');
    }
    return null;
  }

  /// Get entries by user ID (helper method)
  Future<Either<Failure, List<FoodEntry>>> getEntriesByUserId(
      String userId) async {
    try {
      final allEntries = _entriesBox.values.toList();
      final userEntries = allEntries
          .where((entry) => entry.userId == userId)
          .toList();

      // Sort by timestamp descending
      userEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return Right(userEntries.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to retrieve user entries',
          technicalDetails: e.toString(),
        ),
      );
    }
  }
}
