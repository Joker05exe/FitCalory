import 'package:hive/hive.dart';
import '../../domain/entities/food.dart';

part 'serving_size_model.g.dart';

@HiveType(typeId: 2)
class ServingSizeModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double grams;

  @HiveField(2)
  final String unit;

  ServingSizeModel({
    required this.name,
    required this.grams,
    required this.unit,
  });

  factory ServingSizeModel.fromEntity(ServingSize entity) {
    return ServingSizeModel(
      name: entity.name,
      grams: entity.grams,
      unit: entity.unit,
    );
  }

  ServingSize toEntity() {
    return ServingSize(
      name: name,
      grams: grams,
      unit: unit,
    );
  }
}
