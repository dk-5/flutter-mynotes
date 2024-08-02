import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialogue.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLogout) {
          if (state.exception is UserNotFoundAuthException) {
                    await showErrorDialog(context, 'User not found');
                  } else if (state.exception is WrongPasswordAuthException) {
                    devtools.log('working login view');
                    await showErrorDialog(context, 'Wrong credentials');
                  } else if(state.exception is GenericAuthException){
                    await showErrorDialog(context, 'Authentication Error');
                  }
                }
      
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              const Text('Please login to your account in order to interact with and create notes'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your Email'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(email, password),
                              );
                        },
                        child: const Text('Login')),
                        TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventShouldRegsiter());
                  },
                  child: const Text('Not registered yet?Register Here!'),
                ),
                TextButton(onPressed:()
                {
                   context.read<AuthBloc>().add(const AuthEventForgotPassword());
                }, child:const Text('Forgot Password? Click Here to Reset'))
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
