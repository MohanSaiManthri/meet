import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  const Failure({@required this.errorMessage});

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String error;

  const ServerFailure({@required this.error});
  @override
  String get errorMessage => error;
}

class AuthenticationFailure extends Failure {
  final String error;

  const AuthenticationFailure({@required this.error});
  @override
  String get errorMessage => error;
}

class EventCreationFailure extends Failure {
  final String error;

  const EventCreationFailure({@required this.error});
  @override
  String get errorMessage => error;
}

class EventFetchFailure extends Failure {
  final String error;

  const EventFetchFailure({@required this.error});
  @override
  String get errorMessage => error;
}

class MarkingUserToAttentEventFailure extends Failure {
  final String error;

  const MarkingUserToAttentEventFailure({@required this.error});
  @override
  String get errorMessage => error;
}

class UnkownFailure extends Failure {}

class SocketFailure extends Failure {}

class FirebaseTokenFailure extends Failure {}
