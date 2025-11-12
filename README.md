# Calorie Tracker App

A comprehensive calorie tracking application built with Flutter, featuring AI-powered food analysis, QR code scanning, and multi-platform support (Android & Desktop).

## Features

- 📊 **Personalized Nutrition Tracking**: Set custom calorie and macronutrient goals
- 🔍 **Smart Food Search**: Search from an extensive nutritional database
- 📷 **AI Image Analysis**: Identify foods and estimate portions from photos
- 📱 **QR Code Scanning**: Quickly log foods by scanning product barcodes
- 📈 **Progress Analytics**: Visualize your nutrition trends with charts and insights
- 🔄 **Offline Support**: Full functionality without internet connection
- 🔔 **Smart Notifications**: Meal reminders and goal alerts
- 💻 **Multi-Platform**: Works on Android phones and Desktop (Windows/Linux)

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                 # Core utilities, constants, and shared code
│   ├── constants/       # App-wide constants
│   ├── di/             # Dependency injection
│   ├── error/          # Error handling (failures & exceptions)
│   ├── routes/         # Navigation and routing
│   ├── theme/          # App theming
│   └── utils/          # Utility functions and helpers
├── data/                # Data layer
│   ├── datasources/    # Local and remote data sources
│   ├── models/         # Data models with JSON serialization
│   └── repositories/   # Repository implementations
├── domain/              # Domain layer (business logic)
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business use cases
└── presentation/        # Presentation layer
    ├── bloc/           # BLoC state management
    ├── screens/        # Screen widgets
    └── widgets/        # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- For Android: Android SDK (API 21+)
- For Desktop: Platform-specific build tools

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd calorie_tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation (for Hive adapters):
```bash
flutter pub run build_runner build
```

4. Run the app:
```bash
# For Android
flutter run

# For Linux Desktop
flutter run -d linux

# For Windows Desktop
flutter run -d windows
```

## Dependencies

### State Management
- `flutter_bloc` - BLoC pattern implementation
- `equatable` - Value equality for state management

### Local Storage
- `hive` & `hive_flutter` - Fast, lightweight NoSQL database
- `sqflite` - SQLite database for complex queries
- `flutter_secure_storage` - Secure storage for sensitive data

### Networking
- `dio` - HTTP client for API calls
- `connectivity_plus` - Network connectivity monitoring
- `openfoodfacts` - Open Food Facts API integration

### Camera & Scanning
- `camera` - Camera access for photo capture
- `mobile_scanner` - QR/Barcode scanning
- `image_picker` - Image selection from gallery

### UI & Visualization
- `fl_chart` - Beautiful charts and graphs
- `google_fonts` - Custom fonts
- `flutter_svg` - SVG rendering

### Notifications
- `flutter_local_notifications` - Local push notifications
- `timezone` - Timezone handling for scheduled notifications

## Configuration

### Android Permissions

The app requires the following permissions (already configured in `AndroidManifest.xml`):
- `CAMERA` - For QR scanning and food photo analysis
- `INTERNET` - For API calls and data sync
- `POST_NOTIFICATIONS` - For meal reminders and alerts

### API Keys

For AI image analysis, you'll need to configure API keys:

1. Create a `.env` file in the project root
2. Add your API keys:
```
GOOGLE_VISION_API_KEY=your_key_here
```

## Testing

Run tests with:
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Linux
```bash
flutter build linux --release
```

### Windows
```bash
flutter build windows --release
```

## Project Status

### ✅ Implemented Features

- **User Profile Management**
  - Complete onboarding flow with multi-step form
  - Automatic calorie calculation using Harris-Benedict formula
  - Goal setting (lose weight, maintain, gain muscle)
  - Profile editing and goal updates

- **Manual Food Search & Logging**
  - Local database with 20+ common foods
  - Real-time search with autocomplete
  - Portion size selector with multiple units
  - Automatic nutritional value calculation
  - Meal type categorization (breakfast, lunch, dinner, snack)

- **Interactive Dashboard**
  - Daily calorie summary (consumed vs goal)
  - Macronutrient distribution chart
  - Food entries list grouped by meal
  - Remaining calories indicator

- **History & Analytics**
  - Calendar view with daily summaries
  - Weekly and monthly trend charts
  - Detailed statistics (averages, goal adherence)
  - Automatic insight generation

- **Responsive Design**
  - Automatic adaptation for mobile, tablet, and desktop
  - Bottom navigation for mobile
  - Side navigation rail for desktop
  - Optimized layouts per screen size

- **Core Infrastructure**
  - Clean Architecture implementation
  - BLoC state management
  - Dependency injection with get_it
  - Local storage with Hive
  - Smart splash screen with routing

### 🚧 Pending Features

- QR Code scanning with Open Food Facts integration
- AI-powered image analysis
- Offline sync system
- Notifications and reminders
- Remote API (optional)
- Unit and integration tests

See the [tasks.md](.kiro/specs/calorie-tracker-app/tasks.md) file for detailed implementation progress.

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]
# FitCalory
# FitCalory
# FitCalory
# FitCalory
# FitCalory
