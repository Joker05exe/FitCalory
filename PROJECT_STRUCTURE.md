# Project Structure

This document describes the folder structure and organization of the Calorie Tracker application.

## Overview

The project follows **Clean Architecture** principles with three main layers:

1. **Presentation Layer** - UI and state management
2. **Domain Layer** - Business logic and entities
3. **Data Layer** - Data sources and repositories

## Directory Structure

```
calorie_tracker/
│
├── .kiro/                          # Kiro specs and configuration
│   └── specs/
│       └── calorie-tracker-app/
│           ├── requirements.md     # Feature requirements
│           ├── design.md          # Technical design
│           └── tasks.md           # Implementation tasks
│
├── android/                        # Android-specific configuration
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── kotlin/
│   │   └── build.gradle
│   ├── build.gradle
│   └── settings.gradle
│
├── linux/                          # Linux desktop configuration
│   ├── CMakeLists.txt
│   ├── main.cc
│   ├── my_application.h
│   └── my_application.cc
│
├── windows/                        # Windows desktop configuration
│   ├── CMakeLists.txt
│   └── runner/
│       └── main.cpp
│
├── lib/                           # Main application code
│   ├── main.dart                 # Application entry point
│   │
│   ├── core/                     # Core utilities and shared code
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── di/
│   │   │   └── injection_container.dart
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── routes/
│   │   │   └── app_router.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       └── responsive_builder.dart
│   │
│   ├── data/                     # Data layer
│   │   ├── datasources/
│   │   │   ├── local/           # Local data sources (Hive, SQLite)
│   │   │   └── remote/          # Remote data sources (APIs)
│   │   ├── models/              # Data models with serialization
│   │   └── repositories/        # Repository implementations
│   │
│   ├── domain/                   # Domain layer (business logic)
│   │   ├── entities/            # Business entities
│   │   ├── repositories/        # Repository interfaces
│   │   └── usecases/           # Business use cases
│   │
│   └── presentation/            # Presentation layer
│       ├── app.dart            # Main app widget
│       ├── bloc/               # BLoC state management
│       ├── screens/            # Screen widgets
│       └── widgets/            # Reusable UI components
│
├── test/                         # Unit and widget tests
│   └── widget_test.dart
│
├── integration_test/             # Integration tests (to be added)
│
├── assets/                       # Static assets (to be added)
│   ├── images/
│   └── data/
│
├── analysis_options.yaml         # Dart analyzer configuration
├── pubspec.yaml                  # Dependencies and project metadata
├── README.md                     # Project documentation
├── PROJECT_STRUCTURE.md          # This file
└── .gitignore                    # Git ignore rules
```

## Layer Responsibilities

### Core Layer (`lib/core/`)

Contains shared utilities, constants, and configurations used across all layers:

- **constants/** - Application-wide constants (API URLs, breakpoints, etc.)
- **di/** - Dependency injection setup
- **error/** - Error handling (exceptions and failures)
- **routes/** - Navigation and routing configuration
- **theme/** - App theming and styling
- **utils/** - Utility functions and helpers (responsive builder, validators, etc.)

### Data Layer (`lib/data/`)

Handles data operations and external communications:

- **datasources/local/** - Local storage implementations (Hive, SQLite)
- **datasources/remote/** - API clients and remote data sources
- **models/** - Data models with JSON serialization (extends domain entities)
- **repositories/** - Concrete implementations of repository interfaces

### Domain Layer (`lib/domain/`)

Contains pure business logic, independent of frameworks:

- **entities/** - Core business objects (UserProfile, Food, FoodEntry, etc.)
- **repositories/** - Abstract repository interfaces
- **usecases/** - Business use cases (GetUserProfile, LogFood, etc.)

### Presentation Layer (`lib/presentation/`)

Handles UI and user interactions:

- **bloc/** - BLoC state management (events, states, blocs)
- **screens/** - Full-screen widgets (Dashboard, Profile, etc.)
- **widgets/** - Reusable UI components (CalorieCard, MacroChart, etc.)

## Naming Conventions

### Files
- Use snake_case: `user_profile_bloc.dart`
- Suffix with type: `_bloc.dart`, `_screen.dart`, `_widget.dart`, `_model.dart`

### Classes
- Use PascalCase: `UserProfileBloc`, `DashboardScreen`
- Suffix with type: `Bloc`, `Screen`, `Widget`, `Model`, `Repository`

### Variables and Functions
- Use camelCase: `getUserProfile()`, `calorieGoal`

### Constants
- Use lowerCamelCase for const variables: `apiBaseUrl`
- Use SCREAMING_SNAKE_CASE for static const: `MAX_RETRY_COUNT`

## Development Workflow

1. **Define entities** in `domain/entities/`
2. **Create repository interfaces** in `domain/repositories/`
3. **Implement use cases** in `domain/usecases/`
4. **Create data models** in `data/models/`
5. **Implement data sources** in `data/datasources/`
6. **Implement repositories** in `data/repositories/`
7. **Create BLoCs** in `presentation/bloc/`
8. **Build UI** in `presentation/screens/` and `presentation/widgets/`

## Testing Structure

```
test/
├── core/
│   └── utils/
├── data/
│   ├── models/
│   └── repositories/
├── domain/
│   └── usecases/
└── presentation/
    ├── bloc/
    └── widgets/
```

## Next Steps

Refer to `.kiro/specs/calorie-tracker-app/tasks.md` for the implementation plan and task list.
