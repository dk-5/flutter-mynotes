import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enum/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  @override
  void initState(){
    _notesService=NotesService();
    super.initState();

  }

  @override 
  void dispose(){
    _notesService.close();
    super.dispose();
  }
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed:(){
                  Navigator.of(context).pushNamed(newNoteroute);
            },
            icon:const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(onSelected:(value) async{
           switch(value)
           {
            case MenuAction.logout:
            final shouldlogout= await showLogoutDialog(context);
            if(shouldlogout)
            {
              await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(loginroute,(_)=>false);
            }
           }
            
          },itemBuilder :(context){
            return const [PopupMenuItem<MenuAction>(value:MenuAction.logout,child:Text('Logout'))];
            
          })
        ],
      ),
      body:FutureBuilder(
        future:_notesService.getOrCreateUser(email: userEmail),
        builder:(context,snapshot){
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
            return StreamBuilder(
              stream: _notesService.allNotes,
              builder:(context,snapshot){
                switch(snapshot.connectionState)
                {
                  case ConnectionState.waiting:
                  return const Text('Welcome to notes');
                  default:
                  return CircularProgressIndicator();
                }
              }
            );
             
             default:
             return CircularProgressIndicator();

          }
        }
      )
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
