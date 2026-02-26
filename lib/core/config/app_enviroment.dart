enum AppEnvironment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static const AppEnvironment _current = AppEnvironment.development;

  static AppEnvironment get current => _current;

  static bool get isDevelopment => _current == AppEnvironment.development;
  static bool get isStaging => _current == AppEnvironment.staging;
  static bool get isProduction => _current == AppEnvironment.production;
}