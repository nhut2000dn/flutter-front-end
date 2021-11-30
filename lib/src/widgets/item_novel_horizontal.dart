import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';

class ItemNovelHorizontal extends StatelessWidget {
  final NovelModel novel;
  const ItemNovelHorizontal({
    Key? key,
    required this.novel,
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
        margin: const EdgeInsets.only(right: 1, left: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.3, color: Colors.greenAccent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: (novel.image != '')
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
            ),
            SizedBox(
              width: 142,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 3, 0, 3),
                child: Text(
                  novel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: nameNovel,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Center(child: iconHeart),
                        ),
                        TextSpan(
                          style: const TextStyle(
                              color: Colors.red, fontSize: 16.3),
                          text: " ${novel.follower}",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Center(child: iconView),
                        ),
                        TextSpan(
                          style: const TextStyle(
                              color: Colors.red, fontSize: 16.3),
                          text: " ${novel.reader}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
