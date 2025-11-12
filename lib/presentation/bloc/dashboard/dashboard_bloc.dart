import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/food_log_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FoodLogRepository foodLogRepository;
  StreamSubscription? _summarySubscription;

  DashboardBloc({required this.foodLogRepository})
      : super(const DashboardInitial()) {
    on<LoadDailySummary>(_onLoadDailySummary);
    on<RefreshDailySummary>(_onRefreshDailySummary);
    on<WatchDailySummary>(_onWatchDailySummary);
  }

  Future<void> _onLoadDailySummary(
    LoadDailySummary event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final result = await foodLogRepository.getDailySummary(event.date);

    result.fold(
      (failure) => emit(DashboardError(_mapFailureToMessage(failure))),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }

  Future<void> _onRefreshDailySummary(
    RefreshDailySummary event,
    Emitter<DashboardState> emit,
  ) async {
    // Get current date from state or use today
    DateTime date = DateTime.now();
    if (state is DashboardLoaded) {
      date = (state as DashboardLoaded).summary.date;
    }

    final result = await foodLogRepository.getDailySummary(date);

    result.fold(
      (failure) => emit(DashboardError(_mapFailureToMessage(failure))),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }

  Future<void> _onWatchDailySummary(
    WatchDailySummary event,
    Emitter<DashboardState> emit,
  ) async {
    // Cancel previous subscription
    await _summarySubscription?.cancel();

    emit(const DashboardLoading());

    // Watch for changes in daily summary
    await emit.forEach<dynamic>(
      foodLogRepository.watchDailySummary(event.date),
      onData: (result) {
        return result.fold(
          (failure) => DashboardError(_mapFailureToMessage(failure)),
          (summary) => DashboardLoaded(summary),
        );
      },
    );
  }

  String _mapFailureToMessage(failure) {
    return failure.toString();
  }

  @override
  Future<void> close() {
    _summarySubscription?.cancel();
    return super.close();
  }
}
