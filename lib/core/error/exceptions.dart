/// Base class for all application-specific exceptions.
sealed class AppException implements Exception {}

/// Exception thrown when a network error occurs.
final class NetworkException implements AppException {}

/// Exception thrown when a server error occurs.
final class ServerException implements AppException {}

/// Exception thrown when a cache error occurs.
final class CacheException implements AppException {}
