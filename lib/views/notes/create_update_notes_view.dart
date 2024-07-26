import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  DataBaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState(){
     _notesService=NotesService();
     _textController=TextEditingController();
   super.initState();
  }

  void _textControllerListener() async{
    final note =_note;
    if(note == null)
    {
      return;
    }
    else 
    {
      final text=_textController.text;
      await _notesService.updateNote(note: note, 
      text: text,);
    }

  }

  void _setUpTextControllerListener()
  {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }
  Future<DataBaseNote> createOrGetExistingNote(BuildContext context) async {

    final widgetNote=context.getArguments<DataBaseNote>();
    if(widgetNote != null)
    {
      _note=widgetNote;
      _textController.text=widgetNote.text;
      return widgetNote;
    }
    final existingNote=_note;
    if(existingNote!=null)
    {
     return existingNote;
    }
      final currentUser=AuthService.firebase().currentUser!;
      final email=currentUser.email;
      final owner=await _notesService.getUser(email: email);
      final newNote= await _notesService.createNote(owner: owner);
      _note=newNote;
      return newNote; 
       

    

  }
  void _deleteNoteiftextempty() {
    final note=_note;
    if(_textController.text.isEmpty && note != null)
    {
      
      _notesService.deleteNote(id:note.id);
    }

  }

  void _saveNoteIfTextisNotEmpty() async {
    final note =_note;
    final text=_textController.text;
    if(note != null && text.isNotEmpty)
    {
     await _notesService.updateNote(note: note, 
      text: text,);
    }

  }
  @override
  void dispose(){
   _deleteNoteiftextempty();
   _saveNoteIfTextisNotEmpty();
   _textController.dispose();
   super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('New notes'),
      ),
      body:FutureBuilder(
        future:createOrGetExistingNote(context),
        builder:(context,snapshot){
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
            _setUpTextControllerListener();
            return TextField(
              controller:_textController,
              keyboardType:TextInputType.multiline,
              maxLines:null,
              decoration:const InputDecoration(
                hintText: 'Start Typing here'
              ),
            );
            default:
            return const CircularProgressIndicator();


          }
        },
      )
    );
  }
}