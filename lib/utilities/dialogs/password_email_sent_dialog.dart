

import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogue.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialogue<void>(
    context: context,
    title:'Forgot password',
    content: 'Email has been sent',
    optionBuilder: () => {
      'OK': null,
    },
  );
}