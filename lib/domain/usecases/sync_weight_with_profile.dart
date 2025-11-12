import '../entities/weight_entry.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import '../repositories/weight_repository.dart';
import 'calculate_calorie_goal.dart' show CalculateCalorieGoal, CalculateCalorieGoalParams;

class SyncWeightWithProfile {
  final UserProfileRepository _profileRepository;
  final WeightRepository _weightRepository;
  final CalculateCalorieGoal _calculateCalorieGoal;

  SyncWeightWithProfile(
    this._profileRepository,
    this._weightRepository,
    this._calculateCalorieGoal,
  );

  /// Sincroniza el peso más reciente con el perfil y recalcula objetivos
  Future<void> call() async {
    // Obtener el peso más reciente
    final latestWeight = await _weightRepository.getLatestWeight();
    if (latestWeight == null) return;

    // Obtener el perfil actual
    final profileResult = await _profileRepository.getUserProfile();
    
    profileResult.fold(
      (failure) {
        print('❌ Error obteniendo perfil: $failure');
        return;
      },
      (profile) async {
        // Si el peso es diferente, actualizar
        if ((profile.weight - latestWeight.weight).abs() > 0.1) {
          final updatedProfile = profile.copyWith(
            weight: latestWeight.weight,
            updatedAt: DateTime.now(),
          );

          await _profileRepository.updateUserProfile(updatedProfile);

          // Recalcular objetivos con el nuevo peso
          final params = CalculateCalorieGoalParams(
            profile: updatedProfile,
            goalType: updatedProfile.goalType,
          );
          await _calculateCalorieGoal(params);

          print('✅ Perfil actualizado con nuevo peso: ${latestWeight.weight}kg');
          print('✅ Objetivos recalculados automáticamente');
        }
      },
    );
  }

  /// Sincroniza un peso específico
  Future<void> syncSpecificWeight(WeightEntry entry) async {
    final profileResult = await _profileRepository.getUserProfile();
    
    await profileResult.fold(
      (failure) async {
        print('❌ Error obteniendo perfil: $failure');
      },
      (profile) async {
        final updatedProfile = profile.copyWith(
          weight: entry.weight,
          updatedAt: DateTime.now(),
        );

        await _profileRepository.updateUserProfile(updatedProfile);
        
        final params = CalculateCalorieGoalParams(
          profile: updatedProfile,
          goalType: updatedProfile.goalType,
        );
        await _calculateCalorieGoal(params);

        print('✅ Peso sincronizado: ${entry.weight}kg');
      },
    );
  }
}
