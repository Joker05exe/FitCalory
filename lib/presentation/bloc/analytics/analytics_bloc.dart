import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/date_range.dart';
import '../../../domain/usecases/generate_insights.dart';
import '../../../domain/usecases/get_monthly_summary.dart';
import '../../../domain/usecases/get_progress_stats.dart';
import '../../../domain/usecases/get_weekly_summary.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetWeeklySummary getWeeklySummary;
  final GetMonthlySummary getMonthlySummary;
  final GetProgressStats getProgressStats;
  final GenerateInsights generateInsights;

  AnalyticsBloc({
    required this.getWeeklySummary,
    required this.getMonthlySummary,
    required this.getProgressStats,
    required this.generateInsights,
  }) : super(const AnalyticsInitial()) {
    on<LoadWeeklySummary>(_onLoadWeeklySummary);
    on<LoadMonthlySummary>(_onLoadMonthlySummary);
    on<LoadProgressStats>(_onLoadProgressStats);
    on<GenerateInsightsEvent>(_onGenerateInsights);
    on<RefreshAnalytics>(_onRefreshAnalytics);
  }

  Future<void> _onLoadWeeklySummary(
    LoadWeeklySummary event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getWeeklySummary(
      GetWeeklySummaryParams(startDate: event.startDate),
    );

    result.fold(
      (failure) => emit(AnalyticsError(_mapFailureToMessage(failure))),
      (summary) => emit(WeeklySummaryLoaded(summary)),
    );
  }

  Future<void> _onLoadMonthlySummary(
    LoadMonthlySummary event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getMonthlySummary(
      GetMonthlySummaryParams(year: event.year, month: event.month),
    );

    result.fold(
      (failure) => emit(AnalyticsError(_mapFailureToMessage(failure))),
      (summary) => emit(MonthlySummaryLoaded(summary)),
    );
  }

  Future<void> _onLoadProgressStats(
    LoadProgressStats event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getProgressStats(
      GetProgressStatsParams(dateRange: event.dateRange),
    );

    result.fold(
      (failure) => emit(AnalyticsError(_mapFailureToMessage(failure))),
      (stats) => emit(ProgressStatsLoaded(stats)),
    );
  }

  Future<void> _onGenerateInsights(
    GenerateInsightsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await generateInsights(
      GenerateInsightsParams(dateRange: event.dateRange),
    );

    result.fold(
      (failure) => emit(AnalyticsError(_mapFailureToMessage(failure))),
      (insights) => emit(InsightsLoaded(insights)),
    );
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Refresh based on current state
    if (state is WeeklySummaryLoaded) {
      final currentState = state as WeeklySummaryLoaded;
      add(LoadWeeklySummary(currentState.summary.dateRange.start));
    } else if (state is MonthlySummaryLoaded) {
      final currentState = state as MonthlySummaryLoaded;
      add(LoadMonthlySummary(
        year: currentState.summary.year,
        month: currentState.summary.month,
      ));
    } else if (state is ProgressStatsLoaded) {
      // Default to last 30 days
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      add(LoadProgressStats(DateRange(start: thirtyDaysAgo, end: now)));
    }
  }

  String _mapFailureToMessage(failure) {
    return failure.toString();
  }
}
