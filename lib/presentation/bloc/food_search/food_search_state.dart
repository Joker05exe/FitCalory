import 'package:equatable/equatable.dart';
import '../../../domain/entities/food.dart';

abstract class FoodSearchState extends Equatable {
  const FoodSearchState();

  @override
  List<Object?> get props => [];
}

class FoodSearchInitial extends FoodSearchState {
  const FoodSearchInitial();
}

class FoodSearchLoading extends FoodSearchState {
  const FoodSearchLoading();
}

class FoodSearchLoaded extends FoodSearchState {
  final List<Food> foods;
  final String query;

  const FoodSearchLoaded({
    required this.foods,
    required this.query,
  });

  @override
  List<Object?> get props => [foods, query];
}

class FoodSearchEmpty extends FoodSearchState {
  final String query;

  const FoodSearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class FoodDetailLoaded extends FoodSearchState {
  final Food food;

  const FoodDetailLoaded(this.food);

  @override
  List<Object?> get props => [food];
}

class FoodSearchError extends FoodSearchState {
  final String message;

  const FoodSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
