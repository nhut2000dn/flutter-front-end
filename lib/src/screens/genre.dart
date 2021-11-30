import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/services/novel_genre_service.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';

class GenreWidget extends StatefulWidget {
  late final String genreId;
  final RouteArgument routeArgument;
  GenreWidget({Key? key, required this.routeArgument}) : super(key: key) {
    genreId = routeArgument.id as String;
  }

  @override
  State<StatefulWidget> createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget>
    with SingleTickerProviderStateMixin {
  NovelGenreService genreNovelService = NovelGenreService();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f8bf3),
        title: Text(
          'Genres',
          textAlign: TextAlign.center,
          style: titleAppBar,
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<NovelModel>>(
            future: genreNovelService.getNovels(widget.genreId),
            builder: (context, projectSnap) {
              List<NovelModel> novels = projectSnap.data ?? [];
              if (projectSnap.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: novels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/NovelDetail',
                            arguments: RouteArgument(
                                id: novels[index].id,
                                argumentsList: [novels[index]]),
                          );
                        },
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(border: borderTopBottom),
                          padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: CachedNetworkImageProvider(
                                          novels[index].image),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 5.0, 8.0, 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      novels[index].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: nameNovel,
                                    ),
                                    Text(
                                      "Chapter: ${novels[index].chapter}",
                                      style: numberChapter,
                                    ),
                                    Text(
                                      "Status: ${novels[index].status ? 'Completed' : 'Incomplete'}",
                                      style: numberChapter,
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Row(
                                      children: [
                                        iconHeart,
                                        addHorizontalSpace(5),
                                        Text(
                                          "${novels[index].follower}",
                                          style: viewFollower,
                                        ),
                                        addHorizontalSpace(15),
                                        iconView,
                                        addHorizontalSpace(5),
                                        Text(
                                          "${novels[index].reader}",
                                          style: viewNumber,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {}
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _listNovel.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.of(context).pushNamed(
//                       '/DetailNovel',
//                     );
//                   },
//                   child: Container(
//                     height: 130,
//                     decoration: BoxDecoration(border: borderTopBottom),
//                     padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         FadeInImage.assetNetwork(
//                           placeholder: 'assets/images/loading.gif',
//                           fit: BoxFit.cover,
//                           image:
//                               _listNovel[index].image,
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _listNovel[index].name,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 softWrap: false,
//                                 style: nameNovel,
//                               ),
//                               Text(
//                                 "Chapter: ${_listNovel[index].chapter}",
//                                 style: numberChapter,
//                               ),
//                               Text(
//                                 "Status: Complete",
//                                 style: numberChapter,
//                               ),
//                               Expanded(
//                                 child: Container(),
//                               ),
//                               Row(
//                                 children: [
//                                   iconHeart,
//                                   addHorizontalSpace(5),
//                                   Text(
//                                     _listNovel[index].reader.toString(),
//                                     style: viewFollower,
//                                   ),
//                                   addHorizontalSpace(15),
//                                   iconView,
//                                   addHorizontalSpace(5),
//                                   Text(
//                                      _listNovel[index].follower.toString(),
//                                     style: viewNumber,
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }