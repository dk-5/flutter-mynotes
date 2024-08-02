import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialogue.dart';
import 'package:mynotes/utilities/dialogs/password_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateForgotPassword)
        {
          if(state.hasSentEmail)
          {
            _controller.clear();
            await showPasswordResetSentDialog(context);

          }
          if(state.exception != null)
          {
            await showErrorDialog(context,'Email Not send');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              const Text('If you forgot your password,enter your email and we will send you reset email'),
              TextField(
                controller:_controller,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'Enter your email here'),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () async {
                          final email = _controller.text;
                          context
                              .read<AuthBloc>()
                              .add(AuthEventForgotPassword(email: email));
                        },
                        child: const Text('Send Reset Email')),
                
                        TextButton(onPressed:(){
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                }, child:const Text('Back to login page'))
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
