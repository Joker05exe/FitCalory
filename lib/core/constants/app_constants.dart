/// Application-wide constants

class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.example.com/v1';
  static const int apiTimeout = 30000; // milliseconds
  
  // Open Food Facts
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org';
  
  // Database
  static const String databaseName = 'calorie_tracker.db';
  static const int databaseVersion = 1;
  
  // Hive Boxes
  static const String userProfileBox = 'user_profile';
  static const String foodEntriesBox = 'food_entries';
  static const String foodsBox = 'foods';
  static const String syncQueueBox = 'sync_queue';
  
  // Nutritional Constants
  static const double proteinCaloriesPerGram = 4.0;
  static const double carbsCaloriesPerGram = 4.0;
  static const double fatsCaloriesPerGram = 9.0;
  
  // UI Constants
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Sync
  static const int maxSyncRetries = 3;
  static const int syncRetryDelaySeconds = 5;
}
