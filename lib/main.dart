import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verifyemail_view.dart';
// import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes:{
        loginroute:(context)=> const LoginView(),
        registerroute:(context)=>const RegisterView(),
        notesroute:(context)=> const NotesView(),
        verifyemailroute:(context)=>const VerifyEmailPage(),
        
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
            final user= AuthService.firebase().currentUser;
            if(user !=null)
            {
              if(user.isEmailVerified)
              {
                return const NotesView();
              }
              else 
              {
                return const VerifyEmailPage();
              }
            }
            else 
            {
             return const LoginView();
            }        
            default: return const CircularProgressIndicator();
          
          }
        },
        
      );
  }
}


