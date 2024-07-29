import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState{
  const AuthState();
}

class AuthStateLoading extends AuthState 
{
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState
{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}


class AuthStateEmailVerification extends AuthState{
  const AuthStateEmailVerification();
}

class AuthStateLogout extends AuthState
{
  final Exception? exception;
  const AuthStateLogout(this.exception);
}

class AuthStateLogoutException extends AuthState
{
 final Exception exception;
  const AuthStateLogoutException(this.exception);
}