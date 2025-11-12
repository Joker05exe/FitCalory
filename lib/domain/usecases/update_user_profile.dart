import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'usecase.dart';

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParams> {
  final UserProfileRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.profile);
  }
}

class UpdateUserProfileParams extends Equatable {
  final UserProfile profile;

  const UpdateUserProfileParams({required this.profile});

  @override
  List<Object?> get props => [profile];
}
