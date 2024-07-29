

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc(AuthProvider provider):super(const AuthStateLoading()){
    on<AuthEventIntialize>((event,emit) async{
    await provider.initialize();
    final user= provider.currentUser;
    if(user==null)
    {
      emit(const AuthStateLogout(null));
    }
    else if(!user.isEmailVerified)
    {
      emit(const AuthStateEmailVerification());
    }
    else 
    {
      emit(AuthStateLoggedIn(user));
    }
    });
    on<AuthEventLogIn>((event, emit)async{
      final email=event.email;
      final password=event.password;
      try 
      {
        final user=await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));

      }on Exception catch(e)
      {
        emit(AuthStateLogout(e));
      }
    },
    );
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try 
      {
        await provider.logout();
        emit(const AuthStateLogout(null));
      } on Exception catch(e)
      {
       emit(AuthStateLogoutException(e));
      }

    },
    );

  }
  
}