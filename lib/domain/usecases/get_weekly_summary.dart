import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/weekly_summary.dart';
import '../repositories/analytics_repository.dart';
import 'usecase.dart';

class GetWeeklySummary
    implements UseCase<WeeklySummary, GetWeeklySummaryParams> {
  final AnalyticsRepository repository;

  GetWeeklySummary(this.repository);

  @override
  Future<Either<Failure, WeeklySummary>> call(
      GetWeeklySummaryParams params) async {
    return await repository.getWeeklySummary(params.startDate);
  }
}

class GetWeeklySummaryParams extends Equatable {
  final DateTime startDate;

  const GetWeeklySummaryParams({required this.startDate});

  @override
  List<Object?> get props => [startDate];
}
