
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent{
 const AuthEvent();
}

class AuthEventIntialize extends AuthEvent
{
  const AuthEventIntialize();
}

class AuthEventLogIn extends AuthEvent
{
  final String email;
  final String password;
  const AuthEventLogIn(this.email,this.password);
}

class AuthEventLogOut extends AuthEvent
{
  const AuthEventLogOut();
}
class AuthEventRegister extends AuthEvent
{
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}
class AuthEventSendEmailVerification extends AuthEvent
{
  const AuthEventSendEmailVerification();
}
class AuthEventShouldRegsiter extends AuthEvent
{
  const AuthEventShouldRegsiter();
}
class AuthEventForgotPassword extends AuthEvent
{
  final String? email;
  const AuthEventForgotPassword({this.email});
}
