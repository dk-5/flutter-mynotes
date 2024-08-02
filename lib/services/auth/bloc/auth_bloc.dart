

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc(AuthProvider provider):super(const AuthStateUnintialized(isLoading:true)){

     on<AuthEventShouldRegsiter>((event, emit) {
      emit(const AuthStateRegister(
        exception: null,
        isLoading: false,
      ));
    });

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
        emit(const AuthStateEmailVerification(isLoading:false));
      } on Exception catch(e){
        emit(AuthStateRegister(exception:e,isLoading:false));
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
      emit(const AuthStateEmailVerification(isLoading:false));
    }
    else 
    {
      emit(AuthStateLoggedIn(user:user,isLoading:false));
    }
    });
    on<AuthEventLogIn>((event,emit)async{
      emit(const AuthStateLogout(exception:null, 
      isLoading:true,
      loadingText:'Please wait till I log you in',
      ));
      final email=event.email;
      final password=event.password;
      try 
      {
        final user=await provider.logIn(email: email, password: password);
        if(!user.isEmailVerified)
        {
          emit(const AuthStateLogout(exception:null, 
          isLoading:false));
          emit(const AuthStateEmailVerification(isLoading:false));
        }
        else 
        {
          emit(const AuthStateLogout(exception:null, 
          isLoading:false));
          emit(AuthStateLoggedIn(user:user,isLoading:false));
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
   
   on<AuthEventForgotPassword>((event,emit) async {
    final email=event.email;
     emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
        
      ));
      if(email==null)
      {
       return;
      }
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));
       bool hasSentEmail;
      Exception? exception;
    try 
    {
      await provider.sendPasswordResetFunction(email:email);
      hasSentEmail=true;
      exception=null;

     } on Exception catch(e)
    {
     hasSentEmail=false;
     exception=e;
    }
    emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: hasSentEmail,
        isLoading: false,
      ));
  
   });
  }
  
}