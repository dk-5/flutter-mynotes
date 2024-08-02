import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth,FirebaseAuthException;
import 'package:mynotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider{
 
 @override
 AuthUser? get currentUser{
final user=FirebaseAuth.instance.currentUser;
if(user!=null)
{
  return AuthUser.fromFirebase(user);
}
else 
{
  return null;
}
 }
@override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  })
  async {
    try 
    {
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     final user=currentUser;
     if(user!=null)
     {
       return user;
     }
     else 
     {
      throw UserNotLoggedInAuthException();
     }
   } on FirebaseAuthException catch(e)
   {
    if(e.code=='user-not-found')
                  {
                    throw UserNotFoundAuthException();
                  }
                  else if(e.code=='invalid-credential')
                  {
                    throw WrongPasswordAuthException();
                  }
                  else 
                  {
                    throw GenericAuthException();
                  }
    
    }
    catch(_){
     throw GenericAuthException();
    }
  }
@override
  Future<AuthUser> createUser({
  required String email,
    required String password,
  })
  async {
      try 
    {
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
     final user=currentUser;
     if(user!=null)
     {
       return user;
     }
     else 
     {
      throw UserNotLoggedInAuthException();
     }
   } on FirebaseAuthException catch(e)
   {
    if(e.code=='weak-password')
                {
                 throw WeakPasswordAuthException();
                }
                else if(e.code == 'email-already-in-use')
                {
                  throw EmailAlreadyInUserAuthException();
                }
                else if(e.code=='invalid-email')
                {
                  throw InvalidEmailAuthException();
                }
                else 
                {
                  throw GenericAuthException();
                }
   }
    catch(_){
     throw GenericAuthException();
    }
    
    }
@override
  Future<void> logout()
  async {
  final user = FirebaseAuth.instance.currentUser;
   if(user != null)
   {
    await FirebaseAuth.instance.signOut();
   }
   else 
   {
    throw UserNotLoggedInAuthException();
   }
  }

@override
  Future<void> sendEmailverification() async {
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null)
    {
      await user.sendEmailVerification();
    }
    else 
    {
      throw UserNotLoggedInAuthException();
    }
    }
    
@override
Future<void> initialize() async {
        await Firebase.initializeApp(options: 
              DefaultFirebaseOptions.currentPlatform,);
      }


@override
Future<void> sendPasswordResetFunction({required String email})async{
  try 
  {
  await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
   
  } on FirebaseAuthException catch(e)
  {
    switch(e.code)
    {
      case 'firebase_auth/invalid-email':
      throw InvalidEmailAuthException();

      case 'firebase_auth/user-not-found':
      throw UserNotFoundAuthException();

      default:
      throw GenericAuthException();
    }
  } catch (e)
  {
    throw GenericAuthException();
  }
}   

}