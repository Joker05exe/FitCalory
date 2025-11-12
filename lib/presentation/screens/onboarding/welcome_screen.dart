import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/responsive_builder.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: deviceType == DeviceType.mobile ? 24.0 : 48.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // App Icon/Logo
                  Icon(
                    Icons.restaurant_menu,
                    size: deviceType == DeviceType.mobile ? 80 : 120,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    'Calorie Tracker',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: deviceType == DeviceType.mobile ? 32 : 48,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  Text(
                    'Tu compañero personal para una vida saludable',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: deviceType == DeviceType.mobile ? 16 : 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Features
                  _FeatureItem(
                    icon: Icons.search,
                    title: 'Búsqueda de alimentos',
                    description: 'Base de datos completa con miles de alimentos',
                    deviceType: deviceType,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _FeatureItem(
                    icon: Icons.qr_code_scanner,
                    title: 'Escaneo de códigos QR',
                    description: 'Registra alimentos instantáneamente',
                    deviceType: deviceType,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _FeatureItem(
                    icon: Icons.camera_alt,
                    title: 'Análisis con IA',
                    description: 'Identifica alimentos desde fotos',
                    deviceType: deviceType,
                  ),
                  
                  const Spacer(),
                  
                  // Get Started Button
                  SizedBox(
                    width: deviceType == DeviceType.mobile ? double.infinity : 400,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.onboarding);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Comenzar',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final DeviceType deviceType;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: deviceType == DeviceType.mobile ? 24 : 32,
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
                  fontSize: deviceType == DeviceType.mobile ? 16 : 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: deviceType == DeviceType.mobile ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
