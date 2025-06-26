import 'dart:developer' as developer;
import 'package:meal/common/config/app_config.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class Logger {
  static const String _name = 'FlutterBoilerplate';
  
  static LogLevel get _currentLevel {
    switch (AppConfig.logLevel.toLowerCase()) {
      case 'error':
        return LogLevel.error;
      case 'warning':
        return LogLevel.warning;
      case 'info':
        return LogLevel.info;
      case 'debug':
      default:
        return LogLevel.debug;
    }
  }
  
  static bool _shouldLog(LogLevel level) {
    if (!AppConfig.debugMode) return false;
    return level.index >= _currentLevel.index;
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.debug)) {
      developer.log(
        '[DEBUG] $message',
        name: _name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.info)) {
      developer.log(
        '[INFO] $message',
        name: _name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.warning)) {
      developer.log(
        '[WARNING] $message',
        name: _name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.error)) {
      developer.log(
        '[ERROR] $message',
        name: _name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void network(String method, String url, {Object? data, Object? response}) {
    if (_shouldLog(LogLevel.debug)) {
      developer.log(
        '[NETWORK] $method $url',
        name: _name,
      );
      if (data != null) {
        developer.log('[REQUEST] $data', name: _name);
      }
      if (response != null) {
        developer.log('[RESPONSE] $response', name: _name);
      }
    }
  }
}