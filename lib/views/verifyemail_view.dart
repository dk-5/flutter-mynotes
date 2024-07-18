import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
        TextButton(onPressed:() async {
          await AuthService.firebase().sendEmailverification();
        }, child:const Text('Send Verification email')),
        TextButton(onPressed:() async {
         await  AuthService.firebase().logout();
          Navigator.of(context).pushNamedAndRemoveUntil(registerroute,(route)=>false);
        }, child:const Text('Restart'))
      ],),
    );
  }
}