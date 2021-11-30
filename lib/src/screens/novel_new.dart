import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/services/novel_genre_service.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';

class NovelNewWidget extends StatefulWidget {
  const NovelNewWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NovelNewWidgetState();
}

class _NovelNewWidgetState extends State<NovelNewWidget>
    with SingleTickerProviderStateMixin {
  late NovelService _novelService;
  @override
  void initState() {
    super.initState();
    _novelService = NovelService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(37),
        child: Container(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(border: borderTopBottom2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: iconArrowBackBlack,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Novel New',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<NovelModel>>(
            future: _novelService.getNovelsNew(),
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
                                      "Chapter: 227",
                                      style: numberChapter,
                                    ),
                                    Text(
                                      "Status: Complete",
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
                                          "111",
                                          style: viewFollower,
                                        ),
                                        addHorizontalSpace(15),
                                        iconView,
                                        addHorizontalSpace(5),
                                        Text(
                                          "336",
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
