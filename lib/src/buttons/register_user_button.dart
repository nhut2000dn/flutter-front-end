// ignore_for_file: unnecessary_new

import 'package:my_novel/blocs/register_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/src/screens/register.dart';

class RegisterUserButton extends StatelessWidget {
  final UserService _userService;

  const RegisterUserButton({Key? key, required UserService userRepository})
      : _userService = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      // ignore: deprecated_member_use
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        color: Colors.green,
        child: const Text(
          'Register a new Account',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return BlocProvider<RegisterBloc>(
                  create: (context) =>
                      RegisterBloc(userRepository: _userService),
                  child: RegisterWidget(userService: _userService));
            }),
          );
        },
      ),
    );
  }
}
