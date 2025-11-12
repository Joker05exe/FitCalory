/// Base exception class
class AppException implements Exception {
  final String message;
  final String? technicalDetails;

  const AppException({
    required this.message,
    this.technicalDetails,
  });

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.technicalDetails,
  });
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.technicalDetails,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.technicalDetails,
  });
}

class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.technicalDetails,
  });
}

class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.technicalDetails,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.technicalDetails,
  });
}

class ServiceException extends AppException {
  const ServiceException({
    required super.message,
    super.technicalDetails,
  });
}
