# Data Layer Implementation

This directory contains the data layer implementation following Clean Architecture principles.

## Structure

```
data/
├── datasources/
│   └── local/
│       └── hive_service.dart          # Hive initialization and box management
├── models/                             # Hive data models with type adapters
│   ├── user_profile_model.dart
│   ├── food_model.dart
│   ├── food_entry_model.dart
│   ├── macronutrients_model.dart
│   ├── serving_size_model.dart
│   ├── nutritional_values_model.dart
│   ├── calorie_goal_model.dart
│   └── *.g.dart                       # Generated type adapters
└── repositories/                       # Repository implementations
    ├── user_profile_repository_impl.dart
    ├── food_repository_impl.dart
    └── food_log_repository_impl.dart
```

## Hive Setup

### Initialization

Before using any repository, initialize Hive:

```dart
import 'package:calorie_tracker/data/datasources/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive and open boxes
  await HiveService.init();
  
  runApp(MyApp());
}
```

### Generating Type Adapters

After modifying any model files, regenerate the type adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Repository Implementations

### UserProfileRepositoryImpl

Manages user profile data with validation and automatic calorie goal calculation.

**Features:**
- Save/update user profile with validation
- Automatic calorie goal calculation using Harris-Benedict formula
- Data validation (age, weight, height ranges)

**Usage:**
```dart
final repository = UserProfileRepositoryImpl(
  calculateCalorieGoalUseCase: calculateCalorieGoalUseCase,
);

// Save profile
final result = await repository.saveUserProfile(profile);

// Get profile
final profileResult = await repository.getUserProfile();
```

### FoodRepositoryImpl

Manages food database with search capabilities.

**Features:**
- Search foods by name or brand
- Retrieve food by ID or barcode
- Relevance-based search sorting
- Stream-based search with live updates

**Usage:**
```dart
final repository = FoodRepositoryImpl();

// Search foods
final results = await repository.searchFoods('chicken');

// Get by barcode
final food = await repository.getFoodByBarcode('1234567890');

// Stream search results
repository.searchFoodsStream('apple').listen((result) {
  // Handle results
});
```

### FoodLogRepositoryImpl

Manages food entries and daily summaries.

**Features:**
- Log, update, and delete food entries
- Get entries by date
- Calculate daily summaries with totals
- Stream-based daily summary with live updates
- Entry validation

**Usage:**
```dart
final repository = FoodLogRepositoryImpl();

// Log food
await repository.logFood(foodEntry);

// Get daily summary
final summary = await repository.getDailySummary(DateTime.now());

// Watch daily summary (live updates)
repository.watchDailySummary(DateTime.now()).listen((result) {
  // Handle summary updates
});
```

## Error Handling

All repositories return `Either<Failure, T>` from the dartz package:

```dart
final result = await repository.getUserProfile();

result.fold(
  (failure) {
    // Handle error
    print('Error: ${failure.message}');
  },
  (profile) {
    // Handle success
    print('Profile: ${profile.name}');
  },
);
```

## Validation

Repositories include built-in validation:

- **UserProfile**: Name, age (10-120), weight (20-500kg), height (50-300cm)
- **FoodEntry**: User ID, quantity (>0), unit, non-negative calories

## Data Models

All models include:
- `fromEntity()` - Convert domain entity to data model
- `toEntity()` - Convert data model to domain entity
- Hive type adapters for serialization

## Box Names

Defined in `HiveService`:
- `user_profiles` - User profile data
- `foods` - Food database
- `food_entries` - Food log entries
- `calorie_goals` - Calorie goals

## Testing

To clear all data (useful for testing):

```dart
await HiveService.deleteAllData();
```

## Next Steps

1. Implement remote data sources for sync
2. Add caching strategies
3. Implement conflict resolution for offline sync
4. Add data migration support
