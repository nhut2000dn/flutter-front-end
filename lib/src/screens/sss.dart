// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_quill/models/documents/nodes/container.dart';
// import 'package:my_novel/blocs/authentication_bloc.dart';
// import 'package:my_novel/blocs/login_bloc.dart';
// import 'package:my_novel/events/authentication_event.dart';
// import 'package:my_novel/models/genre.dart';
// import 'package:my_novel/models/novel.dart';
// import 'package:my_novel/models/profile.dart';
// import 'package:my_novel/services/genre_service.dart';
// import 'package:my_novel/services/novel_service.dart';
// import 'package:my_novel/services/profile_service.dart';
// import 'package:my_novel/services/user_service.dart';
// import 'package:my_novel/services/users_novels_service.dart';
// import 'package:my_novel/src/screens/chart.dart';
// import 'package:my_novel/states/authentication_state.dart';

// import 'genres.dart';
// import 'home.dart';
// import 'profile.dart';

// class TabsWidget extends StatefulWidget {
//   final int indexTab;

//   const TabsWidget({
//     Key? key,
//     required this.indexTab,
//   }) : super(key: key);

//   @override
//   _TabsWidgetState createState() => _TabsWidgetState();
// }

// class _TabsWidgetState extends State<TabsWidget> {
//   late final PageController _pageController = PageController();
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
//   final GenreService _genreService = GenreService();
//   final NovelService _novelService = NovelService();
//   final UserService _userService = UserService();
//   final ProfileService _profileService = ProfileService();
//   final UsersNovelsService _usersNovelsService = UsersNovelsService();
//   late List<Genre> genres = [];
//   late List<Novel> top10Novels = [];
//   late List<Novel> novelsNew = [];
//   late List<Novel> topNovelsFollower = [];
//   late List<Novel> novelsFollowed = [];
//   late Profile profile = Profile(email: '', avatar: '');

//   setData() async {
//     var holderGenres = await _genreService.getGenress();
//     var holderTop10Novels = await _novelService.getTop10Novels();
//     var holderNovelsNew = await _novelService.get5NovelsNew();
//     var holderTopNovelsFollower = await _novelService.getTop5NovelsFollower();
//     setState(() {
//       genres = holderGenres;
//       top10Novels = holderTop10Novels;
//       novelsNew = holderNovelsNew;
//       topNovelsFollower = holderTopNovelsFollower;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     setData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: widget.indexTab,
//         height: 60.0,
//         items: const <Widget>[
//           Icon(
//             Icons.home,
//             size: 30,
//             color: Color(0xFFf9fafe),
//           ),
//           Icon(
//             Icons.bar_chart,
//             size: 30,
//             color: Color(0xFFf9fafe),
//           ),
//           Icon(
//             Icons.article_rounded,
//             size: 30,
//             color: Color(0xFFf9fafe),
//           ),
//           Icon(
//             Icons.person,
//             size: 30,
//             color: Color(0xFFf9fafe),
//           ),
//         ],
//         color: const Color(0xFF004b4b),
//         buttonBackgroundColor: const Color(0xFF004b4b),
//         backgroundColor: const Color(0xFFEFEFEF),
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 600),
//         onTap: (index) {
//           setState(() {
//             _pageController.jumpToPage(index);
//           });
//         },
//         letIndexChange: (index) => true,
//       ),
//       body: PageView(
//         controller: _pageController,
//         children: <Widget>[
//           HomeWidget(
//             novelsNew: novelsNew,
//             topNovelsFollower: topNovelsFollower,
//           ),
//           ChartWidget(top10Novels: top10Novels),
//           GenresWidget(genres: genres),
//           BlocBuilder<AuthenticationBloc, AuthenticationState>(
//             builder: (context, authenticationState) {
//               if (authenticationState is AuthenticationStateSuccess) {
//                 return ProfileWidget(
//                   profile: authenticationState.profile!,
//                   novelsFollowed: authenticationState.novelsFollowed!,
//                 );
//               } else if (authenticationState is AuthenticationStateFailure) {
//                 return Center(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamed('/Login');
//                     },
//                     child: const Text('Login'),
//                   ),
//                 );
//               }
//               return const Center();
//             },
//           ),
//         ],
//         onPageChanged: (int index) {
//           setState(() {
//             _pageController.jumpToPage(index);
//           });
//         },
//       ),
//     );
//   }
// }

                  // return InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pushNamed(
                  //       '/DetailNovel',
                  //     );
                  //   },
                  //   child: FadeInImage.assetNetwork(
                  //     placeholder: 'assets/images/loading.gif',
                  //     fit: BoxFit.cover,
                  //     image:
                  //         'https://firebasestorage.googleapis.com/v0/b/fluttermynovel.appspot.com/o/slideshows%2Fthe-second-return-of-gluttonl.PNG?alt=media&token=ce7477e7-3723-4704-8e8b-17d41d22241a',
                  //   ),
                  // );

                  // children: [
                  //   for (int i = 0; i < slideshows.length; i++)
                  //     InkWell(
                  //       onTap: () {
                  //         Navigator.of(context).pushNamed(
                  //           '/DetailNovel',
                  //         );
                  //       },
                  //       child: FadeInImage.assetNetwork(
                  //         placeholder: 'assets/images/loading.gif',
                  //         fit: BoxFit.cover,
                  //         image:
                  //             'https://firebasestorage.googleapis.com/v0/b/fluttermynovel.appspot.com/o/slideshows%2Fsolo-leveling.jpeg?alt=media&token=7764e675-f930-4891-806b-5017632de86a',
                  //       ),
                  //     ),
                  // ]),


// .then((documentSnapshot) {
//       return NovelModel(
//           id: documentSnapshot.id,
//           name: documentSnapshot['name'],
//           image: documentSnapshot['image'],
//           description: documentSnapshot['description'],
//           status: documentSnapshot['status'],
//           chapter: documentSnapshot['chapter'],
//           reader: documentSnapshot['reader'],
//           follower: documentSnapshot['follower'],
//           yearRelease: documentSnapshot['yearRelease'],
//           authorId: documentSnapshot['authorId']);
//     });