// ignore_for_file: deprecated_member_use

import 'package:my_novel/blocs/login_bloc.dart';
import 'package:my_novel/events/login_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      child: RaisedButton.icon(
        onPressed: () {
          BlocProvider.of<LoginBloc>(context)
              .add(LoginEventWithGooglePressed());
          //now test in real device !
        },
        icon: const Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
          size: 17,
        ),
        label: const Text(
          'Signin with Google',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        color: Colors.redAccent,
      ),
    );
  }
}
