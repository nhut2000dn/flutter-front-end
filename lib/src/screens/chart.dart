import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/src/widgets/item_novel_vertical.dart';

class ChartWidget extends StatelessWidget {
  final List<NovelModel> top10Novels;
  const ChartWidget({
    Key? key,
    required this.top10Novels,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f8bf3),
        title: Text(
          'Top Novels',
          textAlign: TextAlign.center,
          style: titleAppBar,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: top10Novels.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNovelVertical(
                  number: index + 1,
                  novel: top10Novels[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
