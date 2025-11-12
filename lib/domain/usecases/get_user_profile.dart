import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'usecase.dart';

class GetUserProfile implements UseCase<UserProfile, NoParams> {
  final UserProfileRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
