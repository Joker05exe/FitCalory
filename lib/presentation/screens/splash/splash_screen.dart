import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/usecase.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  Future<void> _checkUserProfile() async {
    // Small delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Check if user profile exists
    final getUserProfile = sl<GetUserProfile>();
    final result = await getUserProfile(NoParams());

    if (!mounted) return;

    result.fold(
      // No profile found - go to welcome/onboarding
      (failure) => Navigator.pushReplacementNamed(context, AppRouter.welcome),
      // Profile exists - go to home
      (profile) => Navigator.pushReplacementNamed(context, AppRouter.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Calorie Tracker',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
