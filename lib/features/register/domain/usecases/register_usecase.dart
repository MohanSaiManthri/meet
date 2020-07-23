import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meet/core/error/failures.dart';
import 'package:meet/core/usecases/usecases.dart';
import 'package:meet/features/register/domain/entities/register_entity.dart';
import 'package:meet/features/register/domain/repositories/register_repo.dart';

// ! Register using Email and Password
class RegisterUsecase extends UseCase<bool, Params> {
  final RegisterRepository registerRepository;

  RegisterUsecase({@required this.registerRepository});
  @override
  Future<Either<Failure, bool>> call(Params params) =>
      registerRepository.requestFirebaseToHandleRegistration(RegisterEntity(
          userDOB: params.dob,
          userEmail: params.email,
          userName: params.name,
          userPassword: params.password,
          userPhoto: params.photoUrl));
}

class Params extends Equatable {
  final String email;
  final String password;
  final String name;
  final String dob;
  final String photoUrl;

  const Params(
      {@required this.email,
      @required this.password,
      @required this.name,
      @required this.dob,
      this.photoUrl});
  @override
  List<Object> get props => [email, password, name, dob, photoUrl];
}
