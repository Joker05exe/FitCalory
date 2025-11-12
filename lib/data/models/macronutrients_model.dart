import 'package:hive/hive.dart';
import '../../domain/entities/macronutrients.dart';

part 'macronutrients_model.g.dart';

@HiveType(typeId: 1)
class MacronutrientsModel extends HiveObject {
  @HiveField(0)
  final double protein;

  @HiveField(1)
  final double carbohydrates;

  @HiveField(2)
  final double fats;

  @HiveField(3)
  final double fiber;

  MacronutrientsModel({
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,
  });

  factory MacronutrientsModel.fromEntity(Macronutrients entity) {
    return MacronutrientsModel(
      protein: entity.protein,
      carbohydrates: entity.carbohydrates,
      fats: entity.fats,
      fiber: entity.fiber,
    );
  }

  Macronutrients toEntity() {
    return Macronutrients(
      protein: protein,
      carbohydrates: carbohydrates,
      fats: fats,
      fiber: fiber,
    );
  }
}
