class ServerException implements Exception {
  final String error;
  ServerException(this.error);
}

class TokenException implements Exception {}

class UnknownExcpetion implements Exception {}

class AuthenticationException implements Exception {
  final String error;
  AuthenticationException(this.error);
}
