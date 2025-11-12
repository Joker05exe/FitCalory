import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? technicalDetails;

  const Failure({
    required this.message,
    this.technicalDetails,
  });

  @override
  List<Object?> get props => [message, technicalDetails];
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.technicalDetails,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.technicalDetails,
  });
}

// Local storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.technicalDetails,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.technicalDetails,
  });
}

// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.technicalDetails,
  });
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.technicalDetails,
  });
}

// Service failures
class ServiceFailure extends Failure {
  const ServiceFailure({
    required super.message,
    super.technicalDetails,
  });
}

// Sync failures
class SyncFailure extends Failure {
  const SyncFailure({
    required super.message,
    super.technicalDetails,
  });
}
