import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/date_range.dart';
import '../repositories/analytics_repository.dart';
import 'usecase.dart';

class GenerateInsights implements UseCase<List<Insight>, GenerateInsightsParams> {
  final AnalyticsRepository repository;

  GenerateInsights(this.repository);

  @override
  Future<Either<Failure, List<Insight>>> call(
      GenerateInsightsParams params) async {
    return await repository.generateInsights(params.dateRange);
  }
}

class GenerateInsightsParams extends Equatable {
  final DateRange dateRange;

  const GenerateInsightsParams({required this.dateRange});

  @override
  List<Object?> get props => [dateRange];
}
