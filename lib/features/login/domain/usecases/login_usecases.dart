import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/core/usecases/usecases.dart';
import 'package:meet/features/login/domain/repositories/login_repository.dart';

// ! Email And Password
class EmailPasswordUsecase extends UseCase<bool, EmailParams> {
  final LoginRepository loginRepository;

  EmailPasswordUsecase({@required this.loginRepository});
  @override
  Future<Either<Failure, bool>> call(EmailParams params) =>
      loginRepository.requestFirebaseToHandleEmailSignIn(params.email, params.password);
}

class EmailParams extends Equatable {
  final String email;
  final String password;

  const EmailParams(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}
