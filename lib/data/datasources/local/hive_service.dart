import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user_profile_model.dart';
import '../../models/macronutrients_model.dart';
import '../../models/serving_size_model.dart';
import '../../models/food_model.dart';
import '../../models/nutritional_values_model.dart';
import '../../models/food_entry_model.dart';
import '../../models/calorie_goal_model.dart';
import '../../models/weight_entry_model.dart';

class HiveService {
  static const String userProfileBox = 'user_profiles';
  static const String foodsBox = 'foods';
  static const String foodEntriesBox = 'food_entries';
  static const String calorieGoalsBox = 'calorie_goals';
  static const String weightEntriesBox = 'weight_entries';

  /// Initialize Hive and register all type adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register type adapters
    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(MacronutrientsModelAdapter());
    Hive.registerAdapter(ServingSizeModelAdapter());
    Hive.registerAdapter(FoodModelAdapter());
    Hive.registerAdapter(NutritionalValuesModelAdapter());
    Hive.registerAdapter(FoodEntryModelAdapter());
    Hive.registerAdapter(CalorieGoalModelAdapter());
    Hive.registerAdapter(WeightEntryModelAdapter());

    // Open boxes
    await Hive.openBox<UserProfileModel>(userProfileBox);
    await Hive.openBox<FoodModel>(foodsBox);
    await Hive.openBox<FoodEntryModel>(foodEntriesBox);
    await Hive.openBox<CalorieGoalModel>(calorieGoalsBox);
    await Hive.openBox<WeightEntryModel>(weightEntriesBox);
  }

  /// Get a box by name
  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Close all boxes
  static Future<void> closeAll() async {
    await Hive.close();
  }

  /// Delete all data (for testing or reset)
  static Future<void> deleteAllData() async {
    await Hive.box<UserProfileModel>(userProfileBox).clear();
    await Hive.box<FoodModel>(foodsBox).clear();
    await Hive.box<FoodEntryModel>(foodEntriesBox).clear();
    await Hive.box<CalorieGoalModel>(calorieGoalsBox).clear();
    await Hive.box<WeightEntryModel>(weightEntriesBox).clear();
  }
}
