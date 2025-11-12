import 'package:equatable/equatable.dart';
import '../../../domain/entities/weekly_summary.dart';
import '../../../domain/repositories/analytics_repository.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class WeeklySummaryLoaded extends AnalyticsState {
  final WeeklySummary summary;

  const WeeklySummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class MonthlySummaryLoaded extends AnalyticsState {
  final MonthlySummary summary;

  const MonthlySummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class ProgressStatsLoaded extends AnalyticsState {
  final ProgressStats stats;

  const ProgressStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class InsightsLoaded extends AnalyticsState {
  final List<Insight> insights;

  const InsightsLoaded(this.insights);

  @override
  List<Object?> get props => [insights];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
