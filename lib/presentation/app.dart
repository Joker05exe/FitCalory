import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart';
import '../core/routes/app_router.dart';
import '../core/theme/app_theme.dart';
import 'bloc/analytics/analytics_bloc.dart';
import 'bloc/dashboard/dashboard_bloc.dart';
import 'bloc/food_log/food_log_bloc.dart';
import 'bloc/food_search/food_search_bloc.dart';
import 'bloc/user_profile/user_profile_bloc.dart';

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserProfileBloc>(
          create: (_) => sl<UserProfileBloc>(),
        ),
        BlocProvider<FoodSearchBloc>(
          create: (_) => sl<FoodSearchBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => sl<DashboardBloc>(),
        ),
        BlocProvider<FoodLogBloc>(
          create: (_) => sl<FoodLogBloc>(),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (_) => sl<AnalyticsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Calorie Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}
