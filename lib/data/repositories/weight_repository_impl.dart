import 'package:hive/hive.dart';
import '../../domain/entities/weight_entry.dart';
import '../../domain/repositories/weight_repository.dart';
import '../models/weight_entry_model.dart';

class WeightRepositoryImpl implements WeightRepository {
  final Box<WeightEntryModel> _weightBox;

  WeightRepositoryImpl(this._weightBox);

  @override
  Future<void> addWeightEntry(WeightEntry entry) async {
    final model = WeightEntryModel.fromEntity(entry);
    await _weightBox.put(entry.id, model);
  }

  @override
  Future<void> deleteWeightEntry(String id) async {
    await _weightBox.delete(id);
  }

  @override
  Future<List<WeightEntry>> getWeightHistory({int? limit}) async {
    final entries = _weightBox.values
        .map((model) => model.toEntity())
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && entries.length > limit) {
      return entries.sublist(0, limit);
    }
    return entries;
  }

  @override
  Future<WeightEntry?> getLatestWeight() async {
    final entries = await getWeightHistory(limit: 1);
    return entries.isEmpty ? null : entries.first;
  }

  @override
  Future<List<WeightEntry>> getWeightEntriesInRange(
      DateTime start, DateTime end) async {
    final entries = _weightBox.values
        .map((model) => model.toEntity())
        .where((entry) =>
            entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return entries;
  }

  @override
  Stream<List<WeightEntry>> watchWeightHistory() async* {
    while (true) {
      yield await getWeightHistory();
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
