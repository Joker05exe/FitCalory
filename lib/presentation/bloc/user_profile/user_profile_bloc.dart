import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/save_user_profile.dart';
import '../../../domain/usecases/update_user_profile.dart';
import '../../../domain/usecases/usecase.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfileUseCase;
  final SaveUserProfile saveUserProfileUseCase;
  final UpdateUserProfile updateUserProfileUseCase;

  UserProfileBloc({
    required this.getUserProfileUseCase,
    required this.saveUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(const UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<SaveUserProfileEvent>(_onSaveUserProfileEvent);
    on<UpdateUserProfileEvent>(_onUpdateUserProfileEvent);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileLoading());

    final result = await getUserProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(UserProfileError(_mapFailureToMessage(failure))),
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  Future<void> _onSaveUserProfileEvent(
    SaveUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileSaving());

    // Create UserProfile from event data
    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.name,
      age: event.age,
      weight: event.weight,
      height: event.height,
      gender: event.gender,
      activityLevel: event.activityLevel,
      goalType: event.goalType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Validate profile data
    final validationError = _validateProfile(profile);
    if (validationError != null) {
      emit(UserProfileError(validationError));
      return;
    }

    final result = await saveUserProfileUseCase(
      SaveUserProfileParams(profile: profile),
    );

    result.fold(
      (failure) => emit(UserProfileError(_mapFailureToMessage(failure))),
      (_) => emit(UserProfileSaved(profile)),
    );
  }

  Future<void> _onUpdateUserProfileEvent(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    // Validate profile data
    final validationError = _validateProfile(event.profile);
    if (validationError != null) {
      emit(UserProfileError(validationError));
      return;
    }

    emit(const UserProfileSaving());

    final result = await updateUserProfileUseCase(
      UpdateUserProfileParams(profile: event.profile),
    );

    result.fold(
      (failure) => emit(UserProfileError(_mapFailureToMessage(failure))),
      (_) => emit(UserProfileSaved(event.profile)),
    );
  }

  String? _validateProfile(UserProfile profile) {
    if (profile.name.trim().isEmpty) {
      return 'El nombre no puede estar vacío';
    }

    if (profile.age < 10 || profile.age > 120) {
      return 'La edad debe estar entre 10 y 120 años';
    }

    if (profile.weight <= 0 || profile.weight > 500) {
      return 'El peso debe estar entre 0 y 500 kg';
    }

    if (profile.height <= 0 || profile.height > 300) {
      return 'La altura debe estar entre 0 y 300 cm';
    }

    return null;
  }

  String _mapFailureToMessage(failure) {
    return failure.toString();
  }
}
