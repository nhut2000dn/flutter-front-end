import 'package:my_novel/blocs/authentication_bloc.dart';
import 'package:my_novel/blocs/login_bloc.dart';
import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/events/login_event.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/src/buttons/google_login_button.dart';
import 'package:my_novel/src/buttons/login_button.dart';
import 'package:my_novel/src/buttons/register_user_button.dart';
import 'package:my_novel/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWidget extends StatefulWidget {
  final UserService _userService;
  //constructor
  const LoginWidget({Key? key, required UserService userRepository})
      : _userService = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwodController = TextEditingController();
  late LoginBloc _loginBloc;
  UserService get _userService => widget._userService;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      //when email is changed,this function is called !
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwodController.addListener(() {
      //when password is changed,this function is called !
      _loginBloc
          .add(LoginEventPasswordChanged(password: _passwodController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwodController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      loginState.isValidEmailAndPassword & isPopulated &&
      !loginState.isSubmitting;

  void _onBackPressed() {
    myCallback(() {
      Navigator.pop(context, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, loginState) {
            if (loginState.isFailure) {
              debugPrint('Login failed');
            } else if (loginState.isSubmitting) {
              debugPrint('Logging in');
            } else if (loginState.isSuccess) {
              //add event: AuthenticationEventLoggedIn ?
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationEventLoggedIn(),
              );
              myCallback(() {
                Navigator.pop(context, true);
              });
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: _emailController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (_) {
                        return loginState.isValidEmail
                            ? null
                            : 'Invalid email format';
                      },
                    ),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: _passwodController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'Enter password'),
                        obscureText: true,
                        autocorrect: false,
                        validator: (_) {
                          return loginState.isValidEmail
                              ? null
                              : 'Invalid password format';
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          LoginButton(
                            onPressed: isLoginButtonEnabled(loginState)
                                ? _onLoginEmailAndPassword
                                : _invalid, //check is enabled ?
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          // const GoogleLoginButton(),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          RegisterUserButton(
                            userRepository: _userService,
                          )
                        ],
                      ), // a login button here
                    ),
                    //Add "register" button here, to "navigate" to "Register Page"
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
        email: _emailController.text, password: _passwodController.text));
    //Failed because user does not exist
  }

  void _invalid() {
    //Failed because user does not exist
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      callback();
    });
  }
}
