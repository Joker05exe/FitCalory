# Presentation Layer - Screens

This directory contains all the UI screens for the Calorie Tracker app.

## Implemented Screens

### Onboarding
- **WelcomeScreen**: Initial welcome screen with app features
- **UserProfileSetupScreen**: Multi-step form for user profile creation
  - Step 1: Name input
  - Step 2: Physical data (age, weight, height)
  - Step 3: Gender selection
  - Step 4: Activity level selection
  - Step 5: Goal type selection

### Profile
- **ProfileScreen**: View and edit user profile information
- **GoalsSettingsScreen**: Configure nutritional goals and calorie targets

### Home
- **HomeScreen**: Main app screen with responsive navigation
  - Dashboard tab (placeholder)
  - Foods tab (placeholder)
  - History tab (placeholder)
  - Stats tab (placeholder)

## Responsive Design

All screens implement responsive design using:
- `ResponsiveBuilder`: Adapts layouts for mobile, tablet, and desktop
- `BreakpointBuilder`: Provides breakpoint utilities and helpers
- `ResponsiveScaffold`: Adaptive navigation (bottom bar on mobile, rail on tablet/desktop)
- `ResponsiveContainer`: Constrains content width on larger screens

### Breakpoints
- Mobile: < 600px
- Tablet: 600px - 900px
- Desktop: > 900px

## Navigation

All screens are registered in `lib/core/routes/app_router.dart` with the following routes:
- `/welcome` - Welcome screen
- `/onboarding` - User profile setup
- `/home` - Main home screen
- `/profile` - User profile
- `/goals-settings` - Goals configuration
