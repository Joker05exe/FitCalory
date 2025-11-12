import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/local/food_seed_service.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/models/calorie_goal_model.dart';
import '../../data/models/food_entry_model.dart';
import '../../data/models/food_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/models/weight_entry_model.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/food_log_repository_impl.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../data/repositories/weight_repository_impl.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/food_log_repository.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/weight_repository.dart';
import '../../domain/usecases/calculate_calorie_goal.dart';
import '../../domain/usecases/generate_insights.dart';
import '../../domain/usecases/get_monthly_summary.dart';
import '../../domain/usecases/get_progress_stats.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/get_weekly_summary.dart';
import '../../domain/usecases/save_user_profile.dart';
import '../../domain/usecases/sync_weight_with_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../presentation/bloc/analytics/analytics_bloc.dart';
import '../../presentation/bloc/dashboard/dashboard_bloc.dart';
import '../../presentation/bloc/favorites/favorites_bloc.dart';
import '../../presentation/bloc/food_log/food_log_bloc.dart';
import '../../presentation/bloc/food_search/food_search_bloc.dart';
import '../../presentation/bloc/user_profile/user_profile_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Initialize Hive
  await HiveService.init();

  // Register Hive boxes
  sl.registerLazySingleton<Box<UserProfileModel>>(
    () => HiveService.getBox(HiveService.userProfileBox),
  );
  sl.registerLazySingleton<Box<FoodModel>>(
    () => HiveService.getBox(HiveService.foodsBox),
  );
  sl.registerLazySingleton<Box<FoodEntryModel>>(
    () => HiveService.getBox(HiveService.foodEntriesBox),
  );
  sl.registerLazySingleton<Box<CalorieGoalModel>>(
    () => HiveService.getBox(HiveService.calorieGoalsBox),
  );
  sl.registerLazySingleton<Box<WeightEntryModel>>(
    () => HiveService.getBox(HiveService.weightEntriesBox),
  );

  // Register Repositories
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      profileBox: sl(),
      goalBox: sl(),
    ),
  );
  sl.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(foodBox: sl()),
  );
  sl.registerLazySingleton<FoodLogRepository>(
    () => FoodLogRepositoryImpl(
      entriesBox: sl(),
      goalBox: sl(),
    ),
  );
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      foodLogRepository: sl(),
      entriesBox: sl(),
    ),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl<Box<FoodModel>>()),
  );
  sl.registerLazySingleton<WeightRepository>(
    () => WeightRepositoryImpl(sl<Box<WeightEntryModel>>()),
  );

  // Register Use Cases
  sl.registerLazySingleton(() => CalculateCalorieGoal(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => SaveUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => GetWeeklySummary(sl()));
  sl.registerLazySingleton(() => GetMonthlySummary(sl()));
  sl.registerLazySingleton(() => GetProgressStats(sl()));
  sl.registerLazySingleton(() => GenerateInsights(sl()));
  sl.registerLazySingleton(() => SyncWeightWithProfile(sl(), sl(), sl()));

  // Register BLoCs (as factories to create new instances)
  sl.registerFactory(
    () => UserProfileBloc(
      getUserProfileUseCase: sl(),
      saveUserProfileUseCase: sl(),
      updateUserProfileUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => FoodSearchBloc(foodRepository: sl()),
  );
  sl.registerFactory(
    () => DashboardBloc(foodLogRepository: sl()),
  );
  sl.registerFactory(
    () => FoodLogBloc(foodLogRepository: sl()),
  );
  sl.registerFactory(
    () => AnalyticsBloc(
      getWeeklySummary: sl(),
      getMonthlySummary: sl(),
      getProgressStats: sl(),
      generateInsights: sl(),
    ),
  );
  sl.registerFactory(
    () => FavoritesBloc(sl()),
  );

  // No seed needed - using OpenFoodFacts API
  print('✅ App inicializada - Usando OpenFoodFacts API para búsqueda');
}
