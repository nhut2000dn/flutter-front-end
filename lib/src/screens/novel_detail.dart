import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_novel/blocs/authentication_bloc.dart';

import 'package:my_novel/config/util.dart';
import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/models/author.dart';
import 'package:my_novel/models/chapter.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/services/author_service.dart';
import 'package:my_novel/services/chapter_service.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/services/users_novels_service.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';
import 'package:my_novel/states/authentication_state.dart';

// ignore: must_be_immutable
class NovelDetailWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  late NovelModel novel;
  NovelDetailWidget({Key? key, required this.routeArgument}) : super(key: key) {
    novel = routeArgument.argumentsList![0] as NovelModel;
  }

  @override
  State<StatefulWidget> createState() => _NovelDetailWidgetState();
}

class _NovelDetailWidgetState extends State<NovelDetailWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ChapterService _chapterService = ChapterService();
  final UsersNovelsService _usersNovelsService = UsersNovelsService();
  final NovelService _novelsService = NovelService();
  final AuthorService _authorService = AuthorService();
  final UserService _userService = UserService();
  late Author? author;
  late int numberChapter = 0;
  late bool isFollowed = false;
  late String userId;
  late bool _isLoading = true;

  setData() async {
    setState(() {
      author = Author(
          id: 'id',
          name: 'Loading',
          image: 'image',
          description: 'description');
    });

    Author placeholderAuthor =
        await _authorService.getAuthor(widget.novel.authorId);

    setState(() {
      author = Author(
          id: 'id',
          name: placeholderAuthor.name,
          image: 'image',
          description: 'description');
    });

    setState(() {
      _isLoading = false;
    });
  }

  checkFollowed() async {
    String placeholderUserId = await _userService.getUserId();
    if (await _usersNovelsService.checkIsFollowed(
        placeholderUserId, widget.novel.id)) {
      setState(() {
        isFollowed = true;
        userId = placeholderUserId;
      });
    }
    setState(() {
      userId = placeholderUserId;
    });
  }

  followNovel() async {
    setState(() {
      _isLoading = true;
    });
    String status = await _usersNovelsService.createUserNovel(
      userId,
      widget.novel.id,
    );

    debugPrint(status.toString());

    if (status == 'created') {
      Fluttertoast.showToast(
        msg: "Follow Succesfull",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      bool checkUpadte =
          await _novelsService.updateFollowerIncrement(widget.novel.id);
      if (checkUpadte) {
        setState(() {
          widget.novel.follower = widget.novel.follower + 1;
          isFollowed = true;
        });
      }
    } else if (status == 'deleted') {
      Fluttertoast.showToast(
        msg: "UnFollow Succesfull",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      bool checkUpadte =
          await _novelsService.updateFollowerDecrement(widget.novel.id);
      if (checkUpadte) {
        setState(() {
          widget.novel.follower = widget.novel.follower - 1;
          isFollowed = false;
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: "Fail",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    setState(() {
      _isLoading = false;
    });

    BlocProvider.of<AuthenticationBloc>(context).add(
      AuthenticationEventFetchData(),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    setData();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: _isLoading
                ? 0.5
                : 1, // You can reduce this when loading to give different effect
            child: AbsorbPointer(
              absorbing: _isLoading,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          widget.novel.image != ''
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: CachedNetworkImageProvider(
                                          widget.novel.image),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: AssetImage(
                                          'assets/images/no_image.jpg'),
                                    ),
                                  ),
                                ),
                          Positioned(
                            left: 10,
                            top: 40,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: iconArrowBack,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 40,
                            child: BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(
                              builder: (context, authenticationState) {
                                if (authenticationState
                                    is AuthenticationStateSuccess) {
                                  checkFollowed();
                                  return InkWell(
                                    onTap: () {
                                      followNovel();
                                    },
                                    child: isFollowed
                                        ? iconHeartRedButton
                                        : iconHeartButton,
                                  );
                                } else if (authenticationState
                                    is AuthenticationStateFailure) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/Login');
                                      },
                                      child: const Text('Login'),
                                    ),
                                  );
                                }
                                return Center();
                              },
                            ),
                          ),
                          Positioned(
                            left: 13,
                            bottom: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.novel.name, style: nameNovelDetail),
                                addVerticalSpace(3),
                                Text(author!.name, style: nameAuthor),
                                addVerticalSpace(3),
                                Row(
                                  children: [
                                    iconHeartNovelDetail,
                                    addHorizontalSpace(5),
                                    Text(
                                      widget.novel.follower.toString(),
                                      style: numberViewNovelDetail,
                                    ),
                                    addHorizontalSpace(15),
                                    iconViewNovelDetail,
                                    addHorizontalSpace(5),
                                    Text(
                                      widget.novel.reader.toString(),
                                      style: numberFollowerNovelDetail,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Text(
                            'Decription',
                            style: nameNovel,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Chapter',
                            style: nameNovel,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '|',
                                        style: verticalLine,
                                      ),
                                      addHorizontalSpace(5),
                                      Text(
                                        'Status novel',
                                        style: headlineNovelDetail,
                                      ),
                                    ],
                                  ),
                                  addVerticalSpace(3),
                                  Text(
                                    widget.novel.status
                                        ? 'Completed'
                                        : 'Uncompleted',
                                    style: status,
                                  ),
                                  addVerticalSpace(25),
                                  Row(
                                    children: [
                                      Text(
                                        '|',
                                        style: verticalLine,
                                      ),
                                      addHorizontalSpace(5),
                                      Text(
                                        'Description',
                                        style: headlineNovelDetail,
                                      ),
                                    ],
                                  ),
                                  addVerticalSpace(3),
                                  Text(
                                    widget.novel.description,
                                    style: status,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder<List<Chapter>>(
                            future:
                                _chapterService.getChapters(widget.novel.id),
                            builder: (context, projectSnap) {
                              List<Chapter> chapters = projectSnap.data ?? [];
                              if (projectSnap.hasData) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: borderTopBottom),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Update to chap ${chapters.isNotEmpty ? chapters[0].numberChapter : '0'}',
                                            style: updateToChapter,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: chapters.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              '/ReadNovel',
                                              arguments: RouteArgument(
                                                  id: chapters[index].novelId,
                                                  argumentsList: [
                                                    chapters[index]
                                                  ]),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: borderTopBottom),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  chapters[index].title,
                                                  style: numberListChapter,
                                                ),
                                                addVerticalSpace(4),
                                                Text(
                                                  chapters[index]
                                                      .dayRelease
                                                      .toString(),
                                                  style: dateRelease,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Opacity(
            opacity: _isLoading ? 1.0 : 0,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
