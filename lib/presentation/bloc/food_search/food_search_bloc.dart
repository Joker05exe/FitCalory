import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/food_repository.dart';
import 'food_search_event.dart';
import 'food_search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  final FoodRepository foodRepository;
  Timer? _debounceTimer;

  FoodSearchBloc({required this.foodRepository})
      : super(const FoodSearchInitial()) {
    on<SearchFoods>(_onSearchFoods);
    on<ClearSearch>(_onClearSearch);
    on<GetFoodById>(_onGetFoodById);
    on<GetFoodByBarcode>(_onGetFoodByBarcode);
  }

  Future<void> _onSearchFoods(
    SearchFoods event,
    Emitter<FoodSearchState> emit,
  ) async {
    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    final query = event.query.trim();

    // If query is empty, clear results
    if (query.isEmpty) {
      emit(const FoodSearchInitial());
      return;
    }

    // Debounce search for 300ms
    final completer = Completer<void>();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      completer.complete();
    });

    await completer.future;

    if (!emit.isDone) {
      emit(const FoodSearchLoading());

      final result = await foodRepository.searchFoods(query);

      if (!emit.isDone) {
        result.fold(
          (failure) => emit(FoodSearchError(_mapFailureToMessage(failure))),
          (foods) {
            if (foods.isEmpty) {
              emit(FoodSearchEmpty(query));
            } else {
              emit(FoodSearchLoaded(foods: foods, query: query));
            }
          },
        );
      }
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<FoodSearchState> emit,
  ) async {
    _debounceTimer?.cancel();
    emit(const FoodSearchInitial());
  }

  Future<void> _onGetFoodById(
    GetFoodById event,
    Emitter<FoodSearchState> emit,
  ) async {
    emit(const FoodSearchLoading());

    final result = await foodRepository.getFoodById(event.foodId);

    result.fold(
      (failure) => emit(FoodSearchError(_mapFailureToMessage(failure))),
      (food) => emit(FoodDetailLoaded(food)),
    );
  }

  Future<void> _onGetFoodByBarcode(
    GetFoodByBarcode event,
    Emitter<FoodSearchState> emit,
  ) async {
    emit(const FoodSearchLoading());

    final result = await foodRepository.getFoodByBarcode(event.barcode);

    result.fold(
      (failure) => emit(FoodSearchError(_mapFailureToMessage(failure))),
      (food) => emit(FoodDetailLoaded(food)),
    );
  }

  String _mapFailureToMessage(failure) {
    return failure.toString();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
