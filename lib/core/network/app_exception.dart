class AppException implements Exception {
  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory AppException.fromStatusCode(int? code, [dynamic data]) {
    return switch (code) {
      400 => AppException(
        message: 'Bad request. Please check your input.',
        statusCode: code,
        data: data,
      ),
      401 => AppException(
        message: 'Unauthorized access.',
        statusCode: code,
        data: data,
      ),
      403 => AppException(
        message: "Forbidden. You don't have permission.",
        statusCode: code,
        data: data,
      ),
      404 => AppException(
        message: 'Resource not found.',
        statusCode: code,
        data: data,
      ),
      409 => AppException(
        message: 'Conflict. Resource already exists.',
        statusCode: code,
        data: data,
      ),
      422 => AppException(
        message: 'Validation failed. Check your input.',
        statusCode: code,
        data: data,
      ),
      500 => AppException(
        message: 'Server error. Please try again later.',
        statusCode: code,
        data: data,
      ),
      503 => AppException(
        message: 'Service unavailable. Please try again later.',
        statusCode: code,
        data: data,
      ),
      _ => AppException(
        message: 'Something went wrong. Please try again.',
        statusCode: code,
        data: data,
      ),
    };
  }

  factory AppException.noInternet() => const AppException(
    message: 'No internet connection. Please check your network.',
  );

  factory AppException.timeout() => const AppException(
    message: 'Request timed out. Please try again.',
  );

  factory AppException.unknown([dynamic error]) => AppException(
    message: error?.toString() ?? 'An unknown error occurred.',
  );

  final String message;
  final int? statusCode;
  final dynamic data;

  @override
  String toString() =>
      'AppException(statusCode: $statusCode, message: $message)';
}
