
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

class AuthService implements AuthProvider
{
  final AuthProvider provider;
  const AuthService(this.provider);
 
  @override
  AuthUser? get currentUser => provider.currentUser;
 
  @override
  Future<AuthUser> logIn({required String email, 
  required String password}) => provider.logIn(email: email, password: password);
 
  @override
  Future<void> logout() => provider.logout();
 
  @override
  Future<void> sendEmailverification() => provider.sendEmailverification();
  
  @override
  Future<AuthUser> createUser({required String email,
   required String password}) => provider.createUser(email: email, password: password);
 }
