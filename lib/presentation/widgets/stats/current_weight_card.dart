import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/user_profile_repository.dart';
import '../../../domain/repositories/weight_repository.dart';
import '../../../core/di/injection_container.dart';

class CurrentWeightCard extends StatefulWidget {
  const CurrentWeightCard({super.key});

  @override
  State<CurrentWeightCard> createState() => _CurrentWeightCardState();
}

class _CurrentWeightCardState extends State<CurrentWeightCard> {
  late Future<Map<String, dynamic>> _weightDataFuture;

  @override
  void initState() {
    super.initState();
    _weightDataFuture = _loadWeightData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _weightDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Card(
            child: Container(
              height: 120,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data!;
        final profile = data['profile'] as UserProfile?;
        final latestWeight = data['latestWeight'] as double?;
        final hasWeightHistory = data['hasHistory'] as bool;

        if (profile == null) {
          return const SizedBox();
        }

        final weight = latestWeight ?? profile.weight;
        final height = profile.height / 100; // convertir a metros
        final bmi = weight / (height * height);
        final bmiCategory = _getBMICategory(bmi);

        return Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.05),
                  AppTheme.secondaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.monitor_weight,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peso Actual',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (!hasWeightHistory)
                            Text(
                              'Del perfil',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                        ],
                      ),
                    ),
                    if (hasWeightHistory)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sync,
                              size: 14,
                              color: AppTheme.successColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sincronizado',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric(
                        context,
                        'Peso',
                        '${weight.toStringAsFixed(1)} kg',
                        Icons.scale,
                        AppTheme.primaryColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildMetric(
                        context,
                        'IMC',
                        bmi.toStringAsFixed(1),
                        Icons.analytics,
                        _getBMIColor(bmi),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildMetric(
                        context,
                        'Altura',
                        '${profile.height.toInt()} cm',
                        Icons.height,
                        AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getBMIColor(bmi).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getBMIColor(bmi).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getBMIIcon(bmi),
                        color: _getBMIColor(bmi),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bmiCategory,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getBMIColor(bmi),
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _getBMIDescription(bmi),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadWeightData() async {
    final profileRepo = sl<UserProfileRepository>();
    final weightRepo = sl<WeightRepository>();

    final profileResult = await profileRepo.getUserProfile();
    final latestWeight = await weightRepo.getLatestWeight();
    final history = await weightRepo.getWeightHistory(limit: 1);

    UserProfile? profile;
    profileResult.fold(
      (failure) => profile = null,
      (p) => profile = p,
    );

    return {
      'profile': profile,
      'latestWeight': latestWeight?.weight,
      'hasHistory': history.isNotEmpty,
    };
  }

  Widget _buildMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  String _getBMIDescription(double bmi) {
    if (bmi < 18.5) return 'Considera aumentar tu ingesta calórica';
    if (bmi < 25) return 'Tu peso está en el rango saludable';
    if (bmi < 30) return 'Considera reducir tu ingesta calórica';
    return 'Consulta con un profesional de la salud';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return AppTheme.warningColor;
    if (bmi < 25) return AppTheme.successColor;
    if (bmi < 30) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  IconData _getBMIIcon(double bmi) {
    if (bmi < 18.5) return Icons.trending_down;
    if (bmi < 25) return Icons.check_circle;
    if (bmi < 30) return Icons.trending_up;
    return Icons.warning;
  }
}
