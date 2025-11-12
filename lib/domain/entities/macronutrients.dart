import 'package:equatable/equatable.dart';

class Macronutrients extends Equatable {
  final double protein;
  final double carbohydrates;
  final double fats;
  final double fiber;

  const Macronutrients({
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.fiber,
  });

  @override
  List<Object?> get props => [protein, carbohydrates, fats, fiber];

  Macronutrients copyWith({
    double? protein,
    double? carbohydrates,
    double? fats,
    double? fiber,
  }) {
    return Macronutrients(
      protein: protein ?? this.protein,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
    );
  }
}
