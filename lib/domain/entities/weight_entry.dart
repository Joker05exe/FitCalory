import 'package:equatable/equatable.dart';

class WeightEntry extends Equatable {
  final String id;
  final String userId;
  final double weight; // en kg
  final DateTime timestamp;
  final String? notes;

  const WeightEntry({
    required this.id,
    required this.userId,
    required this.weight,
    required this.timestamp,
    this.notes,
  });

  @override
  List<Object?> get props => [id, userId, weight, timestamp, notes];

  WeightEntry copyWith({
    String? id,
    String? userId,
    double? weight,
    DateTime? timestamp,
    String? notes,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }
}
