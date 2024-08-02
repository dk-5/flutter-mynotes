import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState{
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText='Please wait a moment '});
}

class AuthStateUnintialized extends AuthState
{
  const AuthStateUnintialized({required bool isLoading}) : super(isLoading:isLoading);
}

class AuthStateRegister extends AuthState
{
  final Exception? exception;

  const AuthStateRegister({required this.exception,required bool isLoading}):super(isLoading:isLoading);

}
class AuthStateLoggedIn extends AuthState
{
  final AuthUser user;
  const AuthStateLoggedIn({required this.user,required bool isLoading}):super(isLoading:isLoading);
}


class AuthStateEmailVerification extends AuthState{
  const AuthStateEmailVerification({required bool isLoading}):super(isLoading:isLoading);
}

class AuthStateLogout extends AuthState with EquatableMixin
{
  final Exception? exception;
  const AuthStateLogout({required this.exception, 
  required bool isLoading,
   String? loadingText,
  }):super(isLoading:isLoading,loadingText:loadingText);
  
  @override
  List<Object?> get props => [exception,isLoading];
}
class AuthStateForgotPassword extends AuthState
{
 final Exception? exception;
 final bool hasSentEmail;

  const AuthStateForgotPassword({required bool isLoading,required this.exception, 
  required this.hasSentEmail}):super(isLoading:isLoading);
  
}