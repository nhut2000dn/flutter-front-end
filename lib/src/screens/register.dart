//something like "LoginPage" !

import 'package:my_novel/blocs/authentication_bloc.dart';
import 'package:my_novel/blocs/register_bloc.dart';
import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/events/register_event.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/src/buttons/register_button.dart';
import 'package:my_novel/states/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterWidget extends StatefulWidget {
  final UserService _userService;
  const RegisterWidget({Key? key, required UserService userService})
      : _userService = userService,
        super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  UserService get _userService => widget._userService;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isValidEmailAndPassword && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userService),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, registerState) {
              if (registerState.isFailure) {
                debugPrint('Registration Failed');
              } else if (registerState.isSubmitting) {
                debugPrint('Registration in progress...');
              } else if (registerState.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationEventLoggedIn());
              }
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (_) {
                          return !registerState.isValidEmail
                              ? 'Invalid Email'
                              : null;
                        },
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        autocorrect: false,
                        validator: (_) {
                          return !registerState.isValidPassword
                              ? 'Invalid Password'
                              : null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      RegisterButton(onPressed: () {
                        if (isRegisterButtonEnabled(registerState)) {
                          _registerBloc.add(
                            RegisterEventPressed(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
