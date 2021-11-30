import 'package:my_novel/events/login_event.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/states/login_state.dart';
import 'package:my_novel/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService? _userService;
  //constructor
  LoginBloc({@required UserService? userService})
      : assert(userService != null),
        _userService = userService,
        super(LoginState.initial());
  //Give 2 adjacent events a "debounce time"
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> loginEvents,
    TransitionFunction<LoginEvent, LoginState> transitionFunction,
  ) {
    final debounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChanged ||
          loginEvent is LoginEventPasswordChanged);
    }).debounceTime(
        const Duration(milliseconds: 300)); //minimum 300ms for each event
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged &&
          loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state; //for easier to read code purpose !
    if (loginEvent is LoginEventEmailChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(loginEvent.email));
    } else if (loginEvent is LoginEventPasswordChanged) {
      yield loginState.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(loginEvent.password));
    } else if (loginEvent is LoginEventWithGooglePressed) {
      try {
        // await _userService!.signInWithGoogle();
        yield LoginState.success();
      } catch (exception) {
        yield LoginState.failure();
      }
    } else if (loginEvent is LoginEventWithEmailAndPasswordPressed) {
      try {
        await _userService!
            .signInWithEmailAndPassword(loginEvent.email, loginEvent.password);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
