import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/food_log_repository.dart';
import 'food_log_event.dart';
import 'food_log_state.dart';

class FoodLogBloc extends Bloc<FoodLogEvent, FoodLogState> {
  final FoodLogRepository foodLogRepository;

  FoodLogBloc({required this.foodLogRepository})
      : super(const FoodLogInitial()) {
    on<LogFoodEntry>(_onLogFoodEntry);
    on<UpdateFoodEntry>(_onUpdateFoodEntry);
    on<DeleteFoodEntry>(_onDeleteFoodEntry);
  }

  Future<void> _onLogFoodEntry(
    LogFoodEntry event,
    Emitter<FoodLogState> emit,
  ) async {
    emit(const FoodLogLogging());

    final result = await foodLogRepository.logFood(event.entry);

    result.fold(
      (failure) => emit(FoodLogError(_mapFailureToMessage(failure))),
      (_) => emit(const FoodLogSuccess('Alimento registrado exitosamente')),
    );
  }

  Future<void> _onUpdateFoodEntry(
    UpdateFoodEntry event,
    Emitter<FoodLogState> emit,
  ) async {
    emit(const FoodLogLogging());

    final result = await foodLogRepository.updateFoodEntry(event.entry);

    result.fold(
      (failure) => emit(FoodLogError(_mapFailureToMessage(failure))),
      (_) => emit(const FoodLogSuccess('Entrada actualizada exitosamente')),
    );
  }

  Future<void> _onDeleteFoodEntry(
    DeleteFoodEntry event,
    Emitter<FoodLogState> emit,
  ) async {
    emit(const FoodLogLogging());

    final result = await foodLogRepository.deleteFoodEntry(event.entryId);

    result.fold(
      (failure) => emit(FoodLogError(_mapFailureToMessage(failure))),
      (_) => emit(const FoodLogSuccess('Entrada eliminada exitosamente')),
    );
  }

  String _mapFailureToMessage(failure) {
    return failure.toString();
  }
}
