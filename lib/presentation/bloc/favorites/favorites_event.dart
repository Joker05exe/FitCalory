import 'package:equatable/equatable.dart';
import '../../../domain/entities/food.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final Food food;

  const AddFavorite(this.food);

  @override
  List<Object?> get props => [food];
}

class RemoveFavorite extends FavoritesEvent {
  final String foodId;

  const RemoveFavorite(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class ToggleFavorite extends FavoritesEvent {
  final Food food;

  const ToggleFavorite(this.food);

  @override
  List<Object?> get props => [food];
}
