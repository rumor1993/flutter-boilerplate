# Flutter Boilerplate

A comprehensive Flutter boilerplate with authentication, routing, state management, and API integration to jumpstart your Flutter development.

## 🚀 Features

- **State Management**: Riverpod for reactive state management
- **Routing**: Go Router for declarative navigation
- **Authentication**: Complete auth system with Google Sign-In
- **API Integration**: Dio for HTTP client with interceptors
- **Secure Storage**: Flutter Secure Storage for sensitive data
- **Code Generation**: Freezed for immutable models and JSON serialization
- **Material Design**: Clean UI with consistent theming
- **Responsive Design**: Adaptable layouts for different screen sizes

## 📁 Project Structure

```
lib/
├── common/                 # Shared utilities and components
│   ├── component/         # Reusable UI components
│   │   ├── custom_image_view.dart
│   │   └── custom_text_form_field.dart
│   ├── const/            # App constants
│   │   ├── colors.dart   # Color palette
│   │   ├── data.dart     # API endpoints and configurations
│   │   └── oauth_type.dart
│   ├── dio/              # HTTP client configuration
│   │   └── dio.dart
│   ├── layout/           # Layout components
│   │   └── default_layout.dart
│   ├── provider/         # Global providers
│   │   └── go_router.dart
│   ├── secoure_storage/ # Secure storage utilities
│   │   └── secoure_storage.dart
│   └── view/            # Common screens
│       ├── placeholder_screen.dart
│       ├── root_tab.dart
│       ├── splash_screen.dart
│       └── update_pending_screen.dart
├── home/                # Home module
│   └── view/
│       └── home_screen.dart
├── user/               # User authentication module
│   ├── model/         # User data models
│   ├── provider/      # User state providers
│   ├── repository/    # User data repositories
│   └── view/         # User screens (login, profile)
└── main.dart         # App entry point
```

## 🛠 Core Technologies

- **Flutter SDK**: ^3.7.0
- **Riverpod**: State management with code generation
- **Go Router**: Declarative routing
- **Dio**: HTTP client for API calls
- **Freezed**: Code generation for data classes
- **Flutter Secure Storage**: Secure local storage
- **Google Sign-In**: OAuth authentication
- **Material Symbols Icons**: Modern icon set

## 🚦 Getting Started

### Prerequisites

- Flutter SDK ^3.7.0
- Dart SDK ^3.7.0

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd flutter_boilerplate
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for Freezed models and Riverpod providers):
```bash
dart run build_runner build
```

4. Run the app:
```bash
flutter run
```

## 🔧 Development

### Code Generation

This project uses code generation for:
- **Freezed**: Immutable data classes with JSON serialization
- **Riverpod**: Type-safe providers

Run code generation when you modify models or providers:
```bash
# Watch for changes and rebuild automatically
dart run build_runner watch

# One-time build
dart run build_runner build

# Clean and rebuild
dart run build_runner build --delete-conflicting-outputs
```

### Adding New Features

1. **Create a new module** (e.g., `products/`):
   ```
   lib/products/
   ├── model/
   ├── provider/
   ├── repository/
   └── view/
   ```

2. **Add routes** in `common/provider/go_router.dart`

3. **Update navigation** in `common/view/root_tab.dart`

## 🎨 Theming

The app uses a consistent Material Design theme defined in `main.dart`:
- Primary color: Blue
- Background: Light gray (#F8F8F8)
- Clean white app bars and cards
- Consistent typography with Google Fonts

Colors are defined in `lib/common/const/colors.dart`.

## 🔐 Authentication

The boilerplate includes a complete authentication system:

- **Google Sign-In** integration
- **JWT token** handling with refresh
- **Secure storage** for tokens
- **Auto-logout** on token expiration
- **Route protection** based on auth state

### Setting up Authentication

1. Configure Google Sign-In:
   - Add your OAuth client ID in `user/repository/auth_repository.dart`
   - Configure platform-specific settings

2. Update API endpoints in `common/const/data.dart`

## 📱 API Integration

The boilerplate uses Dio for HTTP requests with:
- **Base URL configuration**
- **Automatic token attachment**
- **Response interceptors**
- **Error handling**

API configuration is in `lib/common/dio/dio.dart`.

## 🧪 Testing

Run tests with:
```bash
flutter test
```

The project includes widget tests in the `test/` directory.

## 📦 Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- The open-source community for the fantastic packages

---

**Happy coding!** 🚀

For questions or support, please open an issue in the repository.