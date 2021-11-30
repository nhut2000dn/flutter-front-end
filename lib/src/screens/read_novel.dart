import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/chapter.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';

class ReadNovelWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  late final Chapter chapter;
  late final String novelId;
  ReadNovelWidget({Key? key, required this.routeArgument}) : super(key: key) {
    chapter = routeArgument.argumentsList![0] as Chapter;
    novelId = routeArgument.id!;
  }

  @override
  State<StatefulWidget> createState() => _ReadNovelWidgetState();
}

class _ReadNovelWidgetState extends State<ReadNovelWidget> {
  final NovelService _novelService = NovelService();
  @override
  void initState() {
    super.initState();
    _novelService.updateView(widget.novelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: Container(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFc1bebc),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: iconArrowBackBlack,
                    ),
                  ),
                ),
                addHorizontalSpace(10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Chapter  ${widget.chapter.numberChapter}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chapter.title,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    addVerticalSpace(10),
                    Html(
                      data: widget.chapter.content,
                    ),
                    // const Text(
                    //   'As Chamber was the one to TL this there are few difference.\n \n MC name is a bit different, the “disaster” as my friend TLed it is called the Great Cataclysm (probably use that one after this chapter)That’s all enjoy reading:)After sleeping as much as he needed, when he woke up and came to the kitchen, the meal (breakfast by feeling) prepared by the angel was producing steam on the table.\n \nThe angel herself wasn’t there, but he wasn’t surprised since she said that meeting her at all was a strange thing in itself and there won’t be many times to meet her in the future.\n \n“It’s delicious.”',
                    //   style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.black),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
