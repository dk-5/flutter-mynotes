import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogue.dart';

Future <void>showErrorDialog(
  BuildContext context,
   String text,
  
){
return showGenericDialogue(context: context, 
title:'An Error Occured', 
content:text, 
optionBuilder:()=>{
  'OK':null,
});

}