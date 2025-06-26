# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter Boilerplate project - a production-ready template for Flutter applications with authentication, state management, routing, and API integration. The project uses Flutter SDK ^3.7.0 and follows clean architecture principles.

## Common Development Commands

### Development
- `flutter run` - Run the app in development mode with hot reload
- `flutter run --debug` - Run in debug mode
- `flutter run --release` - Run in release mode

### Testing
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file

### Code Quality
- `flutter analyze` - Run static analysis (uses analysis_options.yaml configuration)
- `dart format .` - Format all Dart code
- `dart format --set-exit-if-changed .` - Format and exit with error if changes needed

### Build
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build for iOS (macOS only)
- `flutter clean` - Clean build artifacts
- `flutter pub get` - Get dependencies
- `flutter pub upgrade` - Upgrade dependencies

## Project Structure

- `lib/main.dart` - Application entry point with default counter app
- `test/` - Widget and unit tests
- `android/` - Android-specific platform code
- `ios/` - iOS-specific platform code
- `pubspec.yaml` - Project configuration and dependencies
- `analysis_options.yaml` - Dart analyzer configuration using flutter_lints

## Key Dependencies

### Core
- `flutter_riverpod: ^2.6.1` - State management
- `riverpod_annotation: ^2.6.1` - Code generation for Riverpod
- `go_router: ^14.8.1` - Declarative routing
- `dio: ^5.8.0+1` - HTTP client
- `flutter_secure_storage: ^9.2.4` - Secure token storage

### Authentication
- `google_sign_in: ^6.2.2` - Google OAuth integration

### Data & Serialization  
- `json_annotation: ^4.9.0` - JSON serialization annotations
- `freezed_annotation: ^2.4.4` - Immutable data classes

### UI/UX
- `google_fonts: ^6.2.1` - Custom fonts
- `material_symbols_icons: ^4.2815.1` - Material symbols
- `photo_view: ^0.15.0` - Image viewing
- `model_viewer_plus: ^1.9.3` - 3D model viewing

### Development Tools
- `build_runner: ^2.4.15` - Code generation
- `riverpod_generator: ^2.6.4` - Riverpod code generation
- `json_serializable: ^6.9.4` - JSON serialization
- `freezed: ^2.5.8` - Immutable classes generation
- `riverpod_lint: ^2.6.4` - Riverpod linting rules

## Architecture Overview

This boilerplate follows clean architecture principles with clear separation of concerns:

### State Management
- **Riverpod** for reactive state management
- **Code generation** for providers and models
- **AsyncValue** for handling loading states and errors

### Authentication Flow
- **Google Sign-In** integration
- **JWT token management** with automatic refresh
- **Secure storage** for tokens
- **Route protection** based on authentication state

### API Integration
- **Dio** HTTP client with interceptors
- **Automatic token injection** for authenticated requests
- **Token refresh** handling
- **Request/response logging** in debug mode

### Routing
- **GoRouter** for declarative, type-safe routing
- **Route guards** for authentication
- **Deep linking** support
- **Navigation state management**

### Project Structure
```
lib/
├── common/           # Shared utilities and components
│   ├── component/   # Reusable UI components
│   ├── config/      # App configuration
│   ├── const/       # Constants (colors, data keys)
│   ├── dio/         # HTTP client setup
│   ├── layout/      # Layout widgets
│   ├── provider/    # Global providers (routing)
│   ├── secoure_storage/ # Secure storage utilities
│   ├── utils/       # Utility functions
│   └── view/        # Common screens
├── home/            # Home feature
├── user/            # Authentication feature
│   ├── model/       # User data models
│   ├── provider/    # User-related providers
│   ├── repository/  # API repositories
│   └── view/        # Authentication screens
└── main.dart        # App entry point
```

## Environment Configuration

1. Copy `.env.example` to `.env`
2. Configure API endpoints and OAuth credentials
3. Update `lib/common/config/app_config.dart` as needed
4. Use `--dart-define` for production builds

## Getting Started

1. **Clone and setup:**
   ```bash
   flutter pub get
   dart run build_runner build
   ```

2. **Configure environment:**
   - Copy `.env.example` to `.env`
   - Set up Google Sign-In credentials
   - Configure API base URL

3. **Development:**
   ```bash
   flutter run --dart-define-from-file=.env
   ```

The project is production-ready with authentication, API integration, and modern Flutter best practices.