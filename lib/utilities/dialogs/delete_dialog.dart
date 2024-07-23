import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogue.dart';

Future<bool> showDeleteDialog(BuildContext context){

  return showGenericDialogue(context: context, 
  title:'Delete', 
  content:'Are you sure you want to delete this note', 
  optionBuilder: ()=>{
    'Cancel':false,
    'Yes':true,
  },).then((value)=> value ?? false);
}