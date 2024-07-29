import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState{
  const AuthState();
}

class AuthStateUnintialized extends AuthState
{
  const AuthStateUnintialized();
}

class AuthStateRegister extends AuthState
{
  final Exception? exception;

  const AuthStateRegister(this.exception);

}
class AuthStateLoggedIn extends AuthState
{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}


class AuthStateEmailVerification extends AuthState{
  const AuthStateEmailVerification();
}

class AuthStateLogout extends AuthState with EquatableMixin
{
  final Exception? exception;
  final bool isLoading;
  const AuthStateLogout({required this.exception, required this.isLoading});
  
  @override
  List<Object?> get props => [exception,isLoading];
}
