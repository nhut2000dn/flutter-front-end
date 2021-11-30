// ignore_for_file: unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  const RegisterButton({Key? key, required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        color: Colors.green,
        child: const Text(
          'Register',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        onPressed: () {
          _onPressed();
          //Navigate back
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
