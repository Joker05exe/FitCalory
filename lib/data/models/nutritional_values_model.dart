import 'package:hive/hive.dart';
import '../../domain/entities/food_entry.dart';
import 'macronutrients_model.dart';

part 'nutritional_values_model.g.dart';

@HiveType(typeId: 4)
class NutritionalValuesModel extends HiveObject {
  @HiveField(0)
  final double calories;

  @HiveField(1)
  final MacronutrientsModel macros;

  NutritionalValuesModel({
    required this.calories,
    required this.macros,
  });

  factory NutritionalValuesModel.fromEntity(NutritionalValues entity) {
    return NutritionalValuesModel(
      calories: entity.calories,
      macros: MacronutrientsModel.fromEntity(entity.macros),
    );
  }

  NutritionalValues toEntity() {
    return NutritionalValues(
      calories: calories,
      macros: macros.toEntity(),
    );
  }
}
