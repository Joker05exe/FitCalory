import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/responsive_builder.dart';
import '../../../domain/entities/enums.dart';
import '../../bloc/user_profile/user_profile_barrel.dart';

class UserProfileSetupScreen extends StatefulWidget {
  const UserProfileSetupScreen({super.key});

  @override
  State<UserProfileSetupScreen> createState() => _UserProfileSetupScreenState();
}

class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form data
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  Gender _selectedGender = Gender.male;
  ActivityLevel _selectedActivityLevel = ActivityLevel.moderate;
  GoalType _selectedGoalType = GoalType.maintainWeight;

  // Form keys for validation
  final _nameFormKey = GlobalKey<FormState>();
  final _physicalDataFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Validate current step before proceeding
      bool isValid = true;
      
      if (_currentStep == 0) {
        isValid = _nameFormKey.currentState?.validate() ?? false;
      } else if (_currentStep == 1) {
        isValid = _physicalDataFormKey.currentState?.validate() ?? false;
      }
      
      if (isValid) {
        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeSetup() {
    // Validate all data
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Dispatch event to save profile
    context.read<UserProfileBloc>().add(
      SaveUserProfileEvent(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _selectedGender,
        activityLevel: _selectedActivityLevel,
        goalType: _selectedGoalType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileSaved) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: ResponsiveBuilder(
          builder: (context, deviceType) {
            return SafeArea(
              child: Column(
                children: [
                  // Progress indicator
                  _buildProgressIndicator(context, deviceType),
                  
                  // Content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildNameStep(context, deviceType),
                        _buildPhysicalDataStep(context, deviceType),
                        _buildGenderStep(context, deviceType),
                        _buildActivityLevelStep(context, deviceType),
                        _buildGoalTypeStep(context, deviceType),
                      ],
                    ),
                  ),
                  
                  // Navigation buttons
                  _buildNavigationButtons(context, deviceType),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, DeviceType deviceType) {
    return Container(
      padding: EdgeInsets.all(deviceType == DeviceType.mobile ? 16 : 24),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousStep,
                ),
              Expanded(
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Paso ${_currentStep + 1} de $_totalSteps',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep(BuildContext context, DeviceType deviceType) {
    return _StepContainer(
      deviceType: deviceType,
      title: '¿Cómo te llamas?',
      subtitle: 'Personalicemos tu experiencia',
      child: Form(
        key: _nameFormKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ingresa tu nombre',
            prefixIcon: Icon(Icons.person),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa tu nombre';
            }
            if (value.trim().length < 2) {
              return 'El nombre debe tener al menos 2 caracteres';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPhysicalDataStep(BuildContext context, DeviceType deviceType) {
    return _StepContainer(
      deviceType: deviceType,
      title: 'Datos físicos',
      subtitle: 'Necesitamos esta información para calcular tus objetivos',
      child: Form(
        key: _physicalDataFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Edad',
                hintText: 'Años',
                prefixIcon: Icon(Icons.cake),
                suffixText: 'años',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu edad';
                }
                final age = int.tryParse(value);
                if (age == null || age < 13 || age > 120) {
                  return 'Ingresa una edad válida (13-120)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Peso',
                hintText: 'Kilogramos',
                prefixIcon: Icon(Icons.monitor_weight),
                suffixText: 'kg',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu peso';
                }
                final weight = double.tryParse(value);
                if (weight == null || weight < 30 || weight > 300) {
                  return 'Ingresa un peso válido (30-300 kg)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Altura',
                hintText: 'Centímetros',
                prefixIcon: Icon(Icons.height),
                suffixText: 'cm',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu altura';
                }
                final height = double.tryParse(value);
                if (height == null || height < 100 || height > 250) {
                  return 'Ingresa una altura válida (100-250 cm)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderStep(BuildContext context, DeviceType deviceType) {
    return _StepContainer(
      deviceType: deviceType,
      title: 'Género',
      subtitle: 'Esto nos ayuda a calcular tus necesidades calóricas',
      child: Column(
        children: [
          _SelectionCard(
            title: 'Masculino',
            icon: Icons.male,
            isSelected: _selectedGender == Gender.male,
            onTap: () => setState(() => _selectedGender = Gender.male),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Femenino',
            icon: Icons.female,
            isSelected: _selectedGender == Gender.female,
            onTap: () => setState(() => _selectedGender = Gender.female),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelStep(BuildContext context, DeviceType deviceType) {
    return _StepContainer(
      deviceType: deviceType,
      title: 'Nivel de actividad',
      subtitle: 'Selecciona el que mejor te describa',
      child: Column(
        children: [
          _SelectionCard(
            title: 'Sedentario',
            subtitle: 'Poco o ningún ejercicio',
            icon: Icons.weekend,
            isSelected: _selectedActivityLevel == ActivityLevel.sedentary,
            onTap: () => setState(() => _selectedActivityLevel = ActivityLevel.sedentary),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Ligero',
            subtitle: 'Ejercicio 1-3 días/semana',
            icon: Icons.directions_walk,
            isSelected: _selectedActivityLevel == ActivityLevel.light,
            onTap: () => setState(() => _selectedActivityLevel = ActivityLevel.light),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Moderado',
            subtitle: 'Ejercicio 3-5 días/semana',
            icon: Icons.directions_run,
            isSelected: _selectedActivityLevel == ActivityLevel.moderate,
            onTap: () => setState(() => _selectedActivityLevel = ActivityLevel.moderate),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Activo',
            subtitle: 'Ejercicio 6-7 días/semana',
            icon: Icons.fitness_center,
            isSelected: _selectedActivityLevel == ActivityLevel.active,
            onTap: () => setState(() => _selectedActivityLevel = ActivityLevel.active),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Muy activo',
            subtitle: 'Ejercicio intenso diario',
            icon: Icons.sports_gymnastics,
            isSelected: _selectedActivityLevel == ActivityLevel.veryActive,
            onTap: () => setState(() => _selectedActivityLevel = ActivityLevel.veryActive),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTypeStep(BuildContext context, DeviceType deviceType) {
    return _StepContainer(
      deviceType: deviceType,
      title: '¿Cuál es tu objetivo?',
      subtitle: 'Ajustaremos tus calorías según tu meta',
      child: Column(
        children: [
          _SelectionCard(
            title: 'Perder peso',
            subtitle: 'Déficit calórico',
            icon: Icons.trending_down,
            isSelected: _selectedGoalType == GoalType.loseWeight,
            onTap: () => setState(() => _selectedGoalType = GoalType.loseWeight),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Mantener peso',
            subtitle: 'Balance calórico',
            icon: Icons.balance,
            isSelected: _selectedGoalType == GoalType.maintainWeight,
            onTap: () => setState(() => _selectedGoalType = GoalType.maintainWeight),
          ),
          const SizedBox(height: 12),
          _SelectionCard(
            title: 'Ganar masa muscular',
            subtitle: 'Superávit calórico',
            icon: Icons.trending_up,
            isSelected: _selectedGoalType == GoalType.gainMuscle,
            onTap: () => setState(() => _selectedGoalType = GoalType.gainMuscle),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, DeviceType deviceType) {
    return Container(
      padding: EdgeInsets.all(deviceType == DeviceType.mobile ? 16 : 24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Atrás'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                final isLoading = state is UserProfileLoading;
                
                return FilledButton(
                  onPressed: isLoading
                      ? null
                      : (_currentStep == _totalSteps - 1 ? _completeSetup : _nextStep),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_currentStep == _totalSteps - 1 ? 'Completar' : 'Siguiente'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepContainer extends StatelessWidget {
  final DeviceType deviceType;
  final String title;
  final String subtitle;
  final Widget child;

  const _StepContainer({
    required this.deviceType,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: deviceType == DeviceType.mobile ? 24 : 48,
        vertical: 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: deviceType == DeviceType.mobile ? double.infinity : 600,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
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
