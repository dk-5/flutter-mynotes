import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(title:const Text('Verify Email'),),
      body: Column(children: [
        const Text("We have sent you the email.Please check it"),
        const Text("If you did not receive the email then click on the button below"),
        TextButton(onPressed:() {
          context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
        }, child:const Text('Send Verification email')),
        TextButton(onPressed:() {
         context.read<AuthBloc>().add(const AuthEventLogOut());
        }, child:const Text('Restart'))
      ],),
    );
  }
}