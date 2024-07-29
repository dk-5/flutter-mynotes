

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc(AuthProvider provider):super(const AuthStateUnintialized()){

    on<AuthEventSendEmailVerification>((event,emit)async{
    await provider.sendEmailverification();

    });

    on<AuthEventRegister>((event, emit)async{
      final email=event.email;
      final password=event.password;
      try 
      {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailverification();
        emit(const AuthStateEmailVerification());
      } on Exception catch(e){
        emit(AuthStateRegister(e));
      }
    },);
    on<AuthEventIntialize>((event,emit) async{
    await provider.initialize();
    final user= provider.currentUser;
    if(user==null)
    {
      emit(const AuthStateLogout(exception:null, 
      isLoading:false));
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
    on<AuthEventLogIn>((event,emit)async{
      emit(const AuthStateLogout(exception:null, 
      isLoading:true));
      final email=event.email;
      final password=event.password;
      try 
      {
        final user=await provider.logIn(email: email, password: password);
        if(!user.isEmailVerified)
        {
          emit(const AuthStateLogout(exception:null, 
          isLoading:false));
          emit(const AuthStateEmailVerification());
        }
        else 
        {
          emit(const AuthStateLogout(exception:null, 
          isLoading:false));
          emit(AuthStateLoggedIn(user));
        }


      }on Exception catch(e)
      {
        emit(AuthStateLogout(exception:e, isLoading:false));
      }
    },
    );
    on<AuthEventLogOut>((event, emit) async {
      try 
      {
       await provider.logout();
       emit(const AuthStateLogout(exception:null, isLoading:false));
      }on Exception catch(e)
      {
        emit(AuthStateLogout(exception:e, isLoading:false));
      }
    },
    );

  }
  
}