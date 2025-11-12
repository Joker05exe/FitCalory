import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/injection_container.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Spanish locale
  await initializeDateFormatting('es_ES', null);

  // Initialize dependency injection (includes Hive initialization)
  await initializeDependencies();

  runApp(const CalorieTrackerApp());
}
