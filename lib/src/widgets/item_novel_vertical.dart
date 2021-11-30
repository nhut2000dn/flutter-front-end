import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';

// ignore: must_be_immutable
class ItemNovelVertical extends StatelessWidget {
  NovelModel novel;
  int number;
  ItemNovelVertical({
    Key? key,
    required this.novel,
    required this.number,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/NovelDetail',
          arguments: RouteArgument(id: novel.id, argumentsList: [novel]),
        );
      },
      child: Container(
        height: 130,
        decoration: BoxDecoration(border: borderTopBottom),
        padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Text(
                number.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            (novel.image != '')
                ? AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image: CachedNetworkImageProvider(novel.image),
                        ),
                      ),
                    ),
                  )
                : AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image: AssetImage('assets/images/no_image.jpg'),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    novel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: nameNovel,
                  ),
                  Text(
                    "Chapter: ${novel.chapter}",
                    style: numberChapter,
                  ),
                  Text(
                    "Status: ${novel.status ? 'Completed' : 'Uncompleted'}",
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
                        novel.follower.toString(),
                        style: viewFollower,
                      ),
                      addHorizontalSpace(15),
                      iconView,
                      addHorizontalSpace(5),
                      Text(
                        novel.reader.toString(),
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
  }
}
