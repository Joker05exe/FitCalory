import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/responsive_builder.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/user_profile_repository.dart';
import '../../../domain/usecases/calculate_calorie_goal.dart';
import '../../bloc/user_profile/user_profile_barrel.dart';

class GoalsSettingsScreen extends StatefulWidget {
  const GoalsSettingsScreen({super.key});

  @override
  State<GoalsSettingsScreen> createState() => _GoalsSettingsScreenState();
}

class _GoalsSettingsScreenState extends State<GoalsSettingsScreen> {
  GoalType? _selectedGoalType;
  double? _calculatedCalories;
  double? _calculatedProtein;
  double? _calculatedCarbs;
  double? _calculatedFats;
  
  bool _useCustomGoals = false;
  final _customCaloriesController = TextEditingController();
  final _customProteinController = TextEditingController();
  final _customCarbsController = TextEditingController();
  final _customFatsController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(const LoadUserProfile());
  }

  @override
  void dispose() {
    _customCaloriesController.dispose();
    _customProteinController.dispose();
    _customCarbsController.dispose();
    _customFatsController.dispose();
    super.dispose();
  }

  void _calculateGoals(UserProfile profile) {
    if (_selectedGoalType == null) return;

    final calculateCalorieGoal = CalculateCalorieGoal(
      sl<UserProfileRepository>(),
    );

    calculateCalorieGoal(CalculateCalorieGoalParams(
      profile: profile,
      goalType: _selectedGoalType!,
    )).then((result) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al calcular objetivos')),
          );
        },
        (calorieGoal) {
          setState(() {
            _calculatedCalories = calorieGoal.dailyCalories;
            _calculatedProtein = calorieGoal.proteinGrams;
            _calculatedCarbs = calorieGoal.carbsGrams;
            _calculatedFats = calorieGoal.fatsGrams;
          });
        },
      );
    });
  }

  void _saveGoals(UserProfile profile) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProfile = UserProfile(
        id: profile.id,
        name: profile.name,
        age: profile.age,
        weight: profile.weight,
        height: profile.height,
        gender: profile.gender,
        activityLevel: profile.activityLevel,
        goalType: _selectedGoalType ?? profile.goalType,
        createdAt: profile.createdAt,
        updatedAt: DateTime.now(),
      );

      context.read<UserProfileBloc>().add(UpdateUserProfileEvent(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetivos Nutricionales'),
      ),
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Objetivos actualizados correctamente')),
            );
            Navigator.pop(context);
          } else if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileLoaded) {
            if (_selectedGoalType == null) {
              _selectedGoalType = state.profile.goalType;
              _calculateGoals(state.profile);
            }

            return ResponsiveBuilder(
              builder: (context, deviceType) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(deviceType == DeviceType.mobile ? 16 : 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: deviceType == DeviceType.mobile ? double.infinity : 800,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGoalTypeSection(context, state.profile, deviceType),
                            const SizedBox(height: 24),
                            _buildCalculatedGoalsSection(context, deviceType),
                            const SizedBox(height: 24),
                            _buildCustomGoalsSection(context, deviceType),
                            const SizedBox(height: 24),
                            _buildMacroDistributionInfo(context, deviceType),
                            const SizedBox(height: 32),
                            _buildSaveButton(context, state.profile, deviceType),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No hay perfil disponible'));
        },
      ),
    );
  }

  Widget _buildGoalTypeSection(BuildContext context, UserProfile profile, DeviceType deviceType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu objetivo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _GoalTypeCard(
              title: 'Perder peso',
              subtitle: 'Déficit calórico del 20%',
              icon: Icons.trending_down,
              isSelected: _selectedGoalType == GoalType.loseWeight,
              onTap: () {
                setState(() => _selectedGoalType = GoalType.loseWeight);
                _calculateGoals(profile);
              },
            ),
            const SizedBox(height: 12),
            
            _GoalTypeCard(
              title: 'Mantener peso',
              subtitle: 'Balance calórico',
              icon: Icons.balance,
              isSelected: _selectedGoalType == GoalType.maintainWeight,
              onTap: () {
                setState(() => _selectedGoalType = GoalType.maintainWeight);
                _calculateGoals(profile);
              },
            ),
            const SizedBox(height: 12),
            
            _GoalTypeCard(
              title: 'Ganar masa muscular',
              subtitle: 'Superávit calórico del 10%',
              icon: Icons.trending_up,
              isSelected: _selectedGoalType == GoalType.gainMuscle,
              onTap: () {
                setState(() => _selectedGoalType = GoalType.gainMuscle);
                _calculateGoals(profile);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatedGoalsSection(BuildContext context, DeviceType deviceType) {
    if (_calculatedCalories == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Objetivos Recomendados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Basado en tu perfil y objetivo seleccionado',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            
            _MacroItem(
              label: 'Calorías diarias',
              value: '${_calculatedCalories!.toStringAsFixed(0)} kcal',
              icon: Icons.local_fire_department,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _MacroItem(
                    label: 'Proteínas',
                    value: '${_calculatedProtein!.toStringAsFixed(0)}g',
                    icon: Icons.egg,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MacroItem(
                    label: 'Carbohidratos',
                    value: '${_calculatedCarbs!.toStringAsFixed(0)}g',
                    icon: Icons.grain,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MacroItem(
                    label: 'Grasas',
                    value: '${_calculatedFats!.toStringAsFixed(0)}g',
                    icon: Icons.water_drop,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomGoalsSection(BuildContext context, DeviceType deviceType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Objetivos Personalizados',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _useCustomGoals,
                  onChanged: (value) {
                    setState(() => _useCustomGoals = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Define tus propios objetivos nutricionales',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            
            if (_useCustomGoals) ...[
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _customCaloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calorías diarias',
                  suffixText: 'kcal',
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  final calories = double.tryParse(value);
                  if (calories == null || calories < 1000 || calories > 5000) {
                    return 'Ingresa un valor entre 1000 y 5000';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _customProteinController,
                      decoration: const InputDecoration(
                        labelText: 'Proteínas',
                        suffixText: 'g',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final protein = double.tryParse(value);
                        if (protein == null || protein < 0 || protein > 500) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _customCarbsController,
                      decoration: const InputDecoration(
                        labelText: 'Carbohidratos',
                        suffixText: 'g',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final carbs = double.tryParse(value);
                        if (carbs == null || carbs < 0 || carbs > 800) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _customFatsController,
                      decoration: const InputDecoration(
                        labelText: 'Grasas',
                        suffixText: 'g',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final fats = double.tryParse(value);
                        if (fats == null || fats < 0 || fats > 300) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDistributionInfo(BuildContext context, DeviceType deviceType) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Los objetivos se aplicarán a partir del día siguiente',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, UserProfile profile, DeviceType deviceType) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        final isLoading = state is UserProfileSaving;
        
        return SizedBox(
          width: deviceType == DeviceType.mobile ? double.infinity : 400,
          child: FilledButton(
            onPressed: isLoading ? null : () => _saveGoals(profile),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar Objetivos'),
          ),
        );
      },
    );
  }
}

class _GoalTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
