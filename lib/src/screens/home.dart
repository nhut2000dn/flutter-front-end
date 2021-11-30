import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/models/slideshow.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/src/widgets/item_novel_horizontal.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';

class HomeWidget extends StatelessWidget {
  final List<NovelModel> novelsNew;
  final List<NovelModel> topNovelsFollower;
  final List<SlideshowModel> slideshows;
  const HomeWidget({
    Key? key,
    required this.novelsNew,
    required this.topNovelsFollower,
    required this.slideshows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double padding = 15;
    const sidePadding = EdgeInsets.symmetric(horizontal: padding);
    NovelService _novelService = NovelService();
    slideshows.sort((a, b) {
      return a.index!.compareTo(b.index!);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f8bf3),
        title: Text(
          'My Novel',
          textAlign: TextAlign.center,
          style: titleAppBar,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/Search',
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  initialPage: 0,
                  indicatorColor: Colors.blue,
                  indicatorBackgroundColor: Colors.grey,
                  onPageChanged: (value) {
                    // debugPrint('Page changed: $value');
                  },
                  autoPlayInterval: 3000,
                  isLoop: true,
                  children: slideshows.map((slideshow) {
                    return InkWell(
                      onTap: () async {
                        NovelModel novel = await _novelService
                            .getNovelById(slideshow.novelId!);
                        debugPrint(novel.id.toString());
                        Navigator.of(context).pushNamed(
                          '/NovelDetail',
                          arguments: RouteArgument(
                              id: novel.id, argumentsList: [novel]),
                        );
                      },
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        fit: BoxFit.cover,
                        image: slideshow.image!,
                      ),
                    );
                  }).toList()),
              addVerticalSpace(padding),
              Padding(
                padding: sidePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text: '| ',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: 'Novel New',
                            style: headline1,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/NovelNew',
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15),
                              text: "Xem thêm ",
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(padding),
              Container(
                padding: const EdgeInsets.only(left: 1, right: 1),
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: novelsNew.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ItemNovelHorizontal(
                    novel: novelsNew[index],
                  ),
                ),
              ),
              Container(
                height: 10,
                color: Colors.grey,
              ),
              addVerticalSpace(padding),
              Padding(
                padding: sidePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text: '| ',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: 'Top Follow',
                            style: headline1,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/ChartFollow',
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15),
                              text: "Xem thêm ",
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Center(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(padding),
              Container(
                padding: const EdgeInsets.only(left: 1, right: 1),
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: topNovelsFollower.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ItemNovelHorizontal(
                    novel: topNovelsFollower[index],
                  ),
                ),
              ),
              addVerticalSpace(padding)
            ],
          ),
        ),
      ),
    );
  }
}
