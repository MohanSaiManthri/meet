import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/login/domain/usecases/login_usecases.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final EmailPasswordUsecase emailPasswordUsecase;
  LoginBloc({@required this.emailPasswordUsecase}) : super(LoginInitial());
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is RequestFirebaseToHandleEmailSignIn) {
      yield Authenticating();
      final failureOrTrivia =
          await emailPasswordUsecase.call(EmailParams(event.email, event.password));
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<LoginState> _eitherLoadedOrErrorState(
    Either<Failure, bool> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => AuthenticationFailed(message: _mapFailureToMessage(failure)),
      (bool trivia) => AuthenticatedSuccessfully(doesSuccessfullyAuthenticated: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.errorMessage;
      case AuthenticationFailure:
        return failure.errorMessage;
      case SocketFailure:
        return SOCKET_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}

// ignore: constant_identifier_names
const SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
const SERVER_FAILURE_INVALID_CREDENTIALS_MESSAGE = 'Invalid Credentials';
// ignore: constant_identifier_names
const SOCKET_FAILURE_MESSAGE = 'Please check your internet connection or try again later';
