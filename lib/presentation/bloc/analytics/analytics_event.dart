import 'package:equatable/equatable.dart';
import '../../../domain/entities/date_range.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeeklySummary extends AnalyticsEvent {
  final DateTime startDate;

  const LoadWeeklySummary(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

class LoadMonthlySummary extends AnalyticsEvent {
  final int year;
  final int month;

  const LoadMonthlySummary({
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [year, month];
}

class LoadProgressStats extends AnalyticsEvent {
  final DateRange dateRange;

  const LoadProgressStats(this.dateRange);

  @override
  List<Object?> get props => [dateRange];
}

class GenerateInsightsEvent extends AnalyticsEvent {
  final DateRange dateRange;

  const GenerateInsightsEvent(this.dateRange);

  @override
  List<Object?> get props => [dateRange];
}

class RefreshAnalytics extends AnalyticsEvent {
  const RefreshAnalytics();
}
