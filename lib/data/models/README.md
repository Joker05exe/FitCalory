# Hive Data Models

This directory contains Hive data models for local storage.

## Generating Type Adapters

After creating or modifying any model files with `@HiveType` annotations, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the `.g.dart` files containing the Hive type adapters.

## Type IDs

The following type IDs are registered:
- 0: UserProfileModel
- 1: MacronutrientsModel
- 2: ServingSizeModel
- 3: FoodModel
- 4: NutritionalValuesModel
- 5: FoodEntryModel
- 6: CalorieGoalModel

## Models

- **UserProfileModel**: Stores user profile data (name, age, weight, height, etc.)
- **FoodModel**: Stores food information with nutritional data
- **FoodEntryModel**: Stores individual food log entries
- **MacronutrientsModel**: Stores macronutrient values (protein, carbs, fats, fiber)
- **ServingSizeModel**: Stores serving size information for foods
- **NutritionalValuesModel**: Stores calculated nutritional values for food entries
- **CalorieGoalModel**: Stores user's calorie and macro goals
