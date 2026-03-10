import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static void debug(String message, {String tag = "DEBUG"}) {
    developer.log(
      message,
      name: tag,
    );
  }

  static void info(String message, {String tag = "INFO"}) {
    developer.log(
      message,
      name: tag,
    );
  }

  static void error(String message,
      {String tag = "ERROR", Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}