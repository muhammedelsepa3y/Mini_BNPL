import 'package:logger/logger.dart';

final appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

class AppLogger {
  static void info(String message, [dynamic extra]) =>
      appLogger.i(message, error: extra);

  static void debug(String message, [dynamic extra]) =>
      appLogger.d(message, error: extra);

  static void warning(String message, [dynamic extra]) =>
      appLogger.w(message, error: extra);

  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      appLogger.e(message, error: error, stackTrace: stackTrace);
}
