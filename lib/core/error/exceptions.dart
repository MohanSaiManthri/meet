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

class EventCreationException implements Exception {
  final String error;
  EventCreationException(this.error);
}

class EventFetchException implements Exception {
  final String error;
  EventFetchException(this.error);
}

class MarkingUserToAttentEventException implements Exception {
  final String error;
  MarkingUserToAttentEventException(this.error);
}
