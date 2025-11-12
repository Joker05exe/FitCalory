import 'package:hive/hive.dart';
import '../../domain/entities/weight_entry.dart';

part 'weight_entry_model.g.dart';

@HiveType(typeId: 15)
class WeightEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double weight;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? notes;

  WeightEntryModel({
    required this.id,
    required this.userId,
    required this.weight,
    required this.timestamp,
    this.notes,
  });

  factory WeightEntryModel.fromEntity(WeightEntry entry) {
    return WeightEntryModel(
      id: entry.id,
      userId: entry.userId,
      weight: entry.weight,
      timestamp: entry.timestamp,
      notes: entry.notes,
    );
  }

  WeightEntry toEntity() {
    return WeightEntry(
      id: id,
      userId: userId,
      weight: weight,
      timestamp: timestamp,
      notes: notes,
    );
  }
}
