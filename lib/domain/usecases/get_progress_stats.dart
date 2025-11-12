import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/date_range.dart';
import '../repositories/analytics_repository.dart';
import 'usecase.dart';

class GetProgressStats
    implements UseCase<ProgressStats, GetProgressStatsParams> {
  final AnalyticsRepository repository;

  GetProgressStats(this.repository);

  @override
  Future<Either<Failure, ProgressStats>> call(
      GetProgressStatsParams params) async {
    return await repository.getProgressStats(params.dateRange);
  }
}

class GetProgressStatsParams extends Equatable {
  final DateRange dateRange;

  const GetProgressStatsParams({required this.dateRange});

  @override
  List<Object?> get props => [dateRange];
}
