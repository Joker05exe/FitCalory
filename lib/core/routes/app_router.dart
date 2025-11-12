import 'package:flutter/material.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/welcome_screen.dart';
import '../../presentation/screens/onboarding/user_profile_setup_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/goals_settings_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/food/food_search_screen.dart';
import '../../presentation/screens/food/barcode_scanner_screen.dart';
import '../../presentation/screens/food/photo_analyzer_screen.dart';
import '../../presentation/screens/food/add_custom_food_screen.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String goalsSettings = '/goals-settings';
  static const String foodSearch = '/food-search';
  static const String barcodeScanner = '/barcode-scanner';
  static const String photoAnalyzer = '/photo-analyzer';
  static const String addCustomFood = '/add-custom-food';
  static const String history = '/history';
  static const String stats = '/stats';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      
      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const UserProfileSetupScreen(),
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      
      case goalsSettings:
        return MaterialPageRoute(
          builder: (_) => const GoalsSettingsScreen(),
        );
      
      case foodSearch:
        return MaterialPageRoute(
          builder: (_) => const FoodSearchScreen(),
        );
      
      case barcodeScanner:
        return MaterialPageRoute(
          builder: (_) => const BarcodeScannerScreen(),
        );
      
      case photoAnalyzer:
        return MaterialPageRoute(
          builder: (_) => const PhotoAnalyzerScreen(),
        );
      
      case addCustomFood:
        return MaterialPageRoute(
          builder: (_) => const AddCustomFoodScreen(),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
