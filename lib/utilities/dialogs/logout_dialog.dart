
import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogue.dart';

Future<bool> showLogoutDialog(BuildContext context){

  return showGenericDialogue(context: context, 
  title:'Log Out', 
  content:'Are you sure you want to logout', 
  optionBuilder: ()=>{
    'Cancel':false,
    'Logout':true,
  },).then((value)=> value ?? false);
}