import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/features/register/domain/usecases/register_usecase.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterBloc({@required this.registerUsecase}) : super(RegisterInitial());
  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RequestFirebaseToHandleRegistration) {
      yield Registering();
      final _failureOrRegistered = await registerUsecase.call(Params(
          dob: event.dob,
          email: event.email,
          name: event.name,
          password: event.password,
          photoUrl: event.photoUrl));
      yield* _eitherLoadedOrErrorState(_failureOrRegistered);
    }
  }

  Stream<RegisterState> _eitherLoadedOrErrorState(
    Either<Failure, bool> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => RegistrationFailed(message: _mapFailureToMessage(failure)),
      (bool trivia) => RegistrationSuccessful(doesSuccessfullyRegistered: trivia),
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
