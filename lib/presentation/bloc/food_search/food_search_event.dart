import 'package:equatable/equatable.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchFoods extends FoodSearchEvent {
  final String query;

  const SearchFoods(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends FoodSearchEvent {
  const ClearSearch();
}

class GetFoodById extends FoodSearchEvent {
  final String foodId;

  const GetFoodById(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class GetFoodByBarcode extends FoodSearchEvent {
  final String barcode;

  const GetFoodByBarcode(this.barcode);

  @override
  List<Object?> get props => [barcode];
}
