import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_novel/services/profile_service.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/states/authentication_state.dart';

import 'blocs/authentication_bloc.dart';
import 'blocs/login_bloc.dart';
import 'events/authentication_event.dart';
import 'models/route_argument.dart';
import 'src/screens/novel_detail.dart';
import 'src/screens/edit_profile.dart';
import 'src/screens/genre.dart';
import 'src/screens/login.dart';
import 'src/screens/novel_new.dart';
import 'src/screens/read_novel.dart';
import 'src/screens/register.dart';
import 'src/screens/search.dart';
import 'src/screens/tabs.dart';
import 'src/screens/chart_follow.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final UserService _userService = UserService();
    final ProfileService _profileService = ProfileService();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TabsWidget(indexTab: 0));
      case '/Login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(userService: _userService),
            child: LoginWidget(
              userRepository: _userService,
            ), //LoginPage,
          ),
        );
      case '/Register':
        return MaterialPageRoute(
            builder: (_) => RegisterWidget(userService: _userService));
      case '/NovelDetail':
        return MaterialPageRoute(
            builder: (_) =>
                NovelDetailWidget(routeArgument: args as RouteArgument));
      case '/ReadNovel':
        return MaterialPageRoute(
            builder: (_) =>
                ReadNovelWidget(routeArgument: args as RouteArgument));
      case '/Genre':
        return MaterialPageRoute(
            builder: (_) => GenreWidget(routeArgument: args as RouteArgument));
      case '/Search':
        return MaterialPageRoute(builder: (_) => const SearchWidget());
      case '/NovelNew':
        return MaterialPageRoute(builder: (_) => const NovelNewWidget());
      case '/ChartFollow':
        return MaterialPageRoute(builder: (_) => const ChartFollowWidget());
      case '/EditProfile':
        return MaterialPageRoute(builder: (_) => const EditProfileWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
