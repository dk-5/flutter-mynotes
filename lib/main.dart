import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
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
        future:Firebase.initializeApp(options: 
              DefaultFirebaseOptions.currentPlatform,),
        builder: (context, snapshot) {
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
            final user= FirebaseAuth.instance.currentUser;
            if(user !=null)
            {
              if(user.emailVerified)
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

enum MenuAction {logout}
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected:(value) async{
           switch(value)
           {
            case MenuAction.logout:
            final shouldlogout= await showLogoutDialog(context);
            if(shouldlogout)
            {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(loginroute,(_)=>false);
            }
           }
            
          },itemBuilder :(context){
            return const [PopupMenuItem<MenuAction>(value:MenuAction.logout,child:Text('Logout'))];
            
          })
        ],
      ),
      body:const Text('Hello world')
    );
  }
}

Future<bool>showLogoutDialog(BuildContext context){
  return showDialog<bool>(context: context, builder:(context){
   return AlertDialog(title:const Text('Logout'),
   content:const Text('Are you sure you want to logout'),
   actions: [
    TextButton(onPressed: (){
      Navigator.of(context).pop(false);
    }, child:const Text('Cancel')),
    TextButton(onPressed: (){
      Navigator.of(context).pop(true);
    }, child: const Text('Logout'))
   ],
   );
  }).then((value)=>value ?? false);
}
