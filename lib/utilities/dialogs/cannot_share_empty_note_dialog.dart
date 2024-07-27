

import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogue.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context)
{
  return showGenericDialogue<void>(context: context, 
  title:'Sharing', 
  content:'You cannot share empty note', 
  optionBuilder: () => {
    'OK':null,
  });
}