import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/services/profile_service.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/services/users_novels_service.dart';
import 'package:my_novel/states/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService? _userService;
  final ProfileService? _profileService;
  final UsersNovelsService? _usersNovelsService;
  //constructor
  AuthenticationBloc(
      {@required UserService? userRepository,
      @required ProfileService? profileService,
      @required UsersNovelsService? usersNovelsService})
      : assert(userRepository != null, profileService != null),
        _userService = userRepository,
        _profileService = profileService,
        _usersNovelsService = usersNovelsService,
        super(AuthenticationStateInitial()); //initial state

  @override
  Stream<AuthenticationState> mapEventToState(
      // ignore: avoid_renaming_method_parameters
      AuthenticationEvent authenticationEvent) async* {
    if (authenticationEvent is AuthenticationEventStarted) {
      final isSignedIn = await _userService!.isSignedIn();
      if (isSignedIn) {
        final profile = await _profileService!.getProfile();
        String userId = await _userService!.getUserId();
        List<NovelModel> novelsFollowed = [];
        novelsFollowed = (await UsersNovelsService().getNovels(userId)) ?? [];
        yield AuthenticationStateSuccess(
            profile: profile, novelsFollowed: novelsFollowed);
      } else {
        yield AuthenticationStateFailure();
      }
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      final profile = await _profileService!.getProfile();
      String userId = await _userService!.getUserId();
      List<NovelModel> novelsFollowed = [];
      novelsFollowed = (await UsersNovelsService().getNovels(userId)) ?? [];
      yield AuthenticationStateSuccess(
          profile: profile, novelsFollowed: novelsFollowed);
    } else if (authenticationEvent is AuthenticationEventFetchData) {
      final profile = await _profileService!.getProfile();
      String userId = await _userService!.getUserId();
      List<NovelModel> novelsFollowed = [];
      novelsFollowed = (await UsersNovelsService().getNovels(userId)) ?? [];
      yield AuthenticationStateSuccess(
          profile: profile, novelsFollowed: novelsFollowed);
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      _userService!.signOut();
      yield AuthenticationStateFailure();
    }
  }
}
