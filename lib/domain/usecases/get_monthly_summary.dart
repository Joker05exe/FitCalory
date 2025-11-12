import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../repositories/analytics_repository.dart';
import 'usecase.dart';

class GetMonthlySummary
    implements UseCase<MonthlySummary, GetMonthlySummaryParams> {
  final AnalyticsRepository repository;

  GetMonthlySummary(this.repository);

  @override
  Future<Either<Failure, MonthlySummary>> call(
      GetMonthlySummaryParams params) async {
    return await repository.getMonthlySummary(params.year, params.month);
  }
}

class GetMonthlySummaryParams extends Equatable {
  final int year;
  final int month;

  const GetMonthlySummaryParams({
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [year, month];
}
