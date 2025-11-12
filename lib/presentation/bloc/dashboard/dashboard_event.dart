import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailySummary extends DashboardEvent {
  final DateTime date;

  const LoadDailySummary(this.date);

  @override
  List<Object?> get props => [date];
}

class RefreshDailySummary extends DashboardEvent {
  const RefreshDailySummary();
}

class WatchDailySummary extends DashboardEvent {
  final DateTime date;

  const WatchDailySummary(this.date);

  @override
  List<Object?> get props => [date];
}
