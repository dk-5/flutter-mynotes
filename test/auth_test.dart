import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main(){

}
class NotIntialized implements Exception{}
class MockAuthProvider implements AuthProvider {
  var _isIntialized=false;


  @override
  Future<AuthUser> createUser({required String email, required String password})async{
    if(!_isIntialized) throw NotIntialized();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);

  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailverification() {
    // TODO: implement sendEmailverification
    throw UnimplementedError();
  }

}