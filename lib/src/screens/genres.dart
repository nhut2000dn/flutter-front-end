import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_novel/models/genre.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/route_argument.dart';

class GenresWidget extends StatelessWidget {
  final List<Genre> genres;
  const GenresWidget({
    Key? key,
    required this.genres,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const double padding = 15;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              children: [
                ...genres.map(
                  (genre) => InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/Genre',
                        arguments:
                            RouteArgument(id: genre.id, argumentsList: []),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      // padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: boxDecorationGenre,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (genre.image != '')
                              ? AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter,
                                      image: CachedNetworkImageProvider(
                                          genre.image),
                                    ),
                                  )),
                                )
                              : AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter,
                                      image: AssetImage(
                                          'assets/images/no_image.jpg'),
                                    ),
                                  )),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              genre.name,
                              style: nameGenre,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
