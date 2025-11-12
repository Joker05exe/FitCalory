import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'usecase.dart';

class SaveUserProfile implements UseCase<void, SaveUserProfileParams> {
  final UserProfileRepository repository;

  SaveUserProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUserProfileParams params) async {
    return await repository.saveUserProfile(params.profile);
  }
}

class SaveUserProfileParams extends Equatable {
  final UserProfile profile;

  const SaveUserProfileParams({required this.profile});

  @override
  List<Object?> get props => [profile];
}
