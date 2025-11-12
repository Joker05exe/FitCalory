import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/responsive_builder.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/user_profile.dart';
import '../../bloc/user_profile/user_profile_barrel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  
  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  Gender? _selectedGender;
  ActivityLevel? _selectedActivityLevel;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(const LoadUserProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _loadProfileData(UserProfile profile) {
    _nameController.text = profile.name;
    _ageController.text = profile.age.toString();
    _weightController.text = profile.weight.toString();
    _heightController.text = profile.height.toString();
    _selectedGender = profile.gender;
    _selectedActivityLevel = profile.activityLevel;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges(UserProfile currentProfile) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProfile = UserProfile(
        id: currentProfile.id,
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _selectedGender ?? currentProfile.gender,
        activityLevel: _selectedActivityLevel ?? currentProfile.activityLevel,
        goalType: currentProfile.goalType,
        createdAt: currentProfile.createdAt,
        updatedAt: DateTime.now(),
      );

      context.read<UserProfileBloc>().add(UpdateUserProfileEvent(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoaded) {
                return IconButton(
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  onPressed: _toggleEdit,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileSaved) {
            setState(() => _isEditing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil actualizado correctamente')),
            );
            context.read<UserProfileBloc>().add(const LoadUserProfile());
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
            if (_nameController.text.isEmpty) {
              _loadProfileData(state.profile);
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
                      child: Column(
                        children: [
                          _buildProfileHeader(context, state.profile, deviceType),
                          const SizedBox(height: 24),
                          _buildProfileForm(context, state.profile, deviceType),
                          const SizedBox(height: 24),
                          _buildGoalsCard(context, state.profile, deviceType),
                          if (_isEditing) ...[
                            const SizedBox(height: 24),
                            _buildSaveButton(context, state.profile, deviceType),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is UserProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<UserProfileBloc>().add(const LoadUserProfile());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No hay perfil disponible'));
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile, DeviceType deviceType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: deviceType == DeviceType.mobile ? 40 : 50,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: deviceType == DeviceType.mobile ? 40 : 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getGoalTypeText(profile.goalType),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, UserProfile profile, DeviceType deviceType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Personal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Edad',
                        prefixIcon: Icon(Icons.cake),
                        suffixText: 'años',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 13 || age > 120) {
                          return 'Edad inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<Gender>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Género',
                        prefixIcon: Icon(Icons.wc),
                      ),
                      items: Gender.values.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          enabled: _isEditing,
                          child: Text(_getGenderText(gender)),
                        );
                      }).toList(),
                      onChanged: _isEditing
                          ? (value) => setState(() => _selectedGender = value)
                          : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Peso',
                        prefixIcon: Icon(Icons.monitor_weight),
                        suffixText: 'kg',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final weight = double.tryParse(value);
                        if (weight == null || weight < 30 || weight > 300) {
                          return 'Peso inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Altura',
                        prefixIcon: Icon(Icons.height),
                        suffixText: 'cm',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final height = double.tryParse(value);
                        if (height == null || height < 100 || height > 250) {
                          return 'Altura inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              DropdownButtonFormField<ActivityLevel>(
                value: _selectedActivityLevel,
                decoration: const InputDecoration(
                  labelText: 'Nivel de Actividad',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                items: ActivityLevel.values.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    enabled: _isEditing,
                    child: Text(_getActivityLevelText(level)),
                  );
                }).toList(),
                onChanged: _isEditing
                    ? (value) => setState(() => _selectedActivityLevel = value)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsCard(BuildContext context, UserProfile profile, DeviceType deviceType) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouter.goalsSettings);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.flag,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objetivos Nutricionales',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Configura tus metas de calorías y macros',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
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
            onPressed: isLoading ? null : () => _saveChanges(profile),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar Cambios'),
          ),
        );
      },
    );
  }

  String _getGenderText(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Masculino';
      case Gender.female:
        return 'Femenino';
      case Gender.other:
        return 'Otro';
    }
  }

  String _getActivityLevelText(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentario';
      case ActivityLevel.light:
        return 'Ligero';
      case ActivityLevel.moderate:
        return 'Moderado';
      case ActivityLevel.active:
        return 'Activo';
      case ActivityLevel.veryActive:
        return 'Muy Activo';
    }
  }

  String _getGoalTypeText(GoalType goalType) {
    switch (goalType) {
      case GoalType.loseWeight:
        return 'Perder peso';
      case GoalType.maintainWeight:
        return 'Mantener peso';
      case GoalType.gainMuscle:
        return 'Ganar masa muscular';
    }
  }
}
