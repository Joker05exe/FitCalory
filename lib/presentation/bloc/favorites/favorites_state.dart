import 'package:equatable/equatable.dart';
import '../../../domain/entities/food.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Food> favorites;
  final Set<String> favoriteIds;

  const FavoritesLoaded(this.favorites, this.favoriteIds);

  @override
  List<Object?> get props => [favorites, favoriteIds];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
