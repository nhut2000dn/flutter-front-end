import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_novel/blocs/authentication_bloc.dart';
import 'package:my_novel/blocs/login_bloc.dart';
import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/models/genre.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/profile.dart';
import 'package:my_novel/models/slideshow.dart';
import 'package:my_novel/services/genre_service.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/services/profile_service.dart';
import 'package:my_novel/services/slideshow_service.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/services/users_novels_service.dart';
import 'package:my_novel/src/screens/chart.dart';
import 'package:my_novel/states/authentication_state.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'genres.dart';
import 'home.dart';
import 'profile.dart';

class TabsWidget extends StatefulWidget {
  final int indexTab;

  const TabsWidget({
    Key? key,
    required this.indexTab,
  }) : super(key: key);

  @override
  _TabsWidgetState createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> {
  late final PageController _pageController = PageController();
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GenreService _genreService = GenreService();
  final NovelService _novelService = NovelService();
  final UserService _userService = UserService();
  final SlideshowService _slideshowService = SlideshowService();
  final ProfileService _profileService = ProfileService();
  final UsersNovelsService _usersNovelsService = UsersNovelsService();
  late List<Genre> genres = [];
  late List<NovelModel> top10Novels = [];
  late List<NovelModel> novelsNew = [];
  late List<NovelModel> topNovelsFollower = [];
  late List<NovelModel> novelsFollowed = [];
  late List<SlideshowModel> slideshows = [
    SlideshowModel(
        id: '', image: 'https://i.imgur.com/tj3Dbsw.gif', novelId: '')
  ];
  late Profile profile = Profile(email: '', avatar: '');

  setData() async {
    var holderGenres = await _genreService.getGenress();
    var holderTop10Novels = await _novelService.getTop10Novels();
    var holderNovelsNew = await _novelService.get5NovelsNew();
    var holderTopNovelsFollower = await _novelService.getTop5NovelsFollower();
    var holderSlideshows = await _slideshowService.getSlideshows();
    setState(() {
      genres = holderGenres;
      top10Novels = holderTop10Novels;
      novelsNew = holderNovelsNew;
      topNovelsFollower = holderTopNovelsFollower;
      slideshows = holderSlideshows;
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2, color: Colors.grey[300]!),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[300]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.bar_chart_outlined,
                    text: 'Ranking',
                  ),
                  GButton(
                    icon: Icons.article_outlined,
                    text: 'Genres',
                  ),
                  GButton(
                    icon: Icons.person_outlined,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: 0,
                onTabChange: (index) {
                  setState(() {
                    _pageController.jumpToPage(index);
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomeWidget(
            novelsNew: novelsNew,
            topNovelsFollower: topNovelsFollower,
            slideshows: slideshows,
          ),
          ChartWidget(top10Novels: top10Novels),
          GenresWidget(genres: genres),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authenticationState) {
              if (authenticationState is AuthenticationStateSuccess) {
                return ProfileWidget(
                  profile: authenticationState.profile!,
                  novelsFollowed: authenticationState.novelsFollowed ?? [],
                );
              } else if (authenticationState is AuthenticationStateFailure) {
                return Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Login');
                    },
                    child: const Text('Login'),
                  ),
                );
              }
              return const Center();
            },
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
