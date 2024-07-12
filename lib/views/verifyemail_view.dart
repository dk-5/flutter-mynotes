import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

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
          final user= FirebaseAuth.instance.currentUser;
           await user?.sendEmailVerification();
        }, child:const Text('Send Verification email')),
        TextButton(onPressed:(){
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(registerroute,(route)=>false);
        }, child:const Text('Restart'))
      ],),
    );
  }
}