import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/src/widgets/item_novel_vertical.dart';

class ChartFollowWidget extends StatefulWidget {
  const ChartFollowWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartFollowWidgetState();
}

class _ChartFollowWidgetState extends State<ChartFollowWidget> {
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
                    'Chart Novel Followed',
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
            future: _novelService.getTopNovelsFollower(),
            builder: (context, projectSnap) {
              List<NovelModel> novels = projectSnap.data ?? [];
              if (projectSnap.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: novels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemNovelVertical(
                        number: index + 1,
                        novel: novels[index],
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
