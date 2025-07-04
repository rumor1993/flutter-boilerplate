class AppConfig {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  // Google Sign-In Configuration
  static const String googleClientIdIOS = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_IOS',
    defaultValue: '',
  );

  static const String googleClientIdAndroid = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_ANDROID',
    defaultValue: '',
  );

  static const String googleClientIdWeb = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_WEB',
    defaultValue: '',
  );

  // App Configuration
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Flutter Boilerplate',
  );

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  // Development Configuration
  static const bool debugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: true,
  );

  static const String logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'debug',
  );

  // Optional: Database Configuration
  static const String databaseUrl = String.fromEnvironment(
    'DATABASE_URL',
    defaultValue: '',
  );

  // Optional: Firebase Configuration
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  // Optional: Sentry Configuration
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  // Helper methods
  static bool get isProduction => !debugMode;

  static bool get isDevelopment => debugMode;

  static bool get hasGoogleSignIn =>
      googleClientIdIOS.isNotEmpty ||
      googleClientIdAndroid.isNotEmpty ||
      googleClientIdWeb.isNotEmpty;

  static bool get hasDatabase => databaseUrl.isNotEmpty;

  static bool get hasFirebase =>
      firebaseProjectId.isNotEmpty && firebaseApiKey.isNotEmpty;

  static bool get hasSentry => sentryDsn.isNotEmpty;
}
