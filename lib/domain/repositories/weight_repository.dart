import '../entities/weight_entry.dart';

abstract class WeightRepository {
  Future<void> addWeightEntry(WeightEntry entry);
  Future<void> deleteWeightEntry(String id);
  Future<List<WeightEntry>> getWeightHistory({int? limit});
  Future<WeightEntry?> getLatestWeight();
  Future<List<WeightEntry>> getWeightEntriesInRange(DateTime start, DateTime end);
  Stream<List<WeightEntry>> watchWeightHistory();
}
