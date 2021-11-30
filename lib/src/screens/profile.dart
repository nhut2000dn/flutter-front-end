import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_novel/blocs/authentication_bloc.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/profile.dart';
import 'package:my_novel/models/route_argument.dart';
import 'package:my_novel/src/widgets/profile_box_widget.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';

// ignore: must_be_immutable
class ProfileWidget extends StatefulWidget {
  Profile profile;
  List<NovelModel> novelsFollowed = [];
  ProfileWidget({
    Key? key,
    required this.profile,
    required this.novelsFollowed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with AutomaticKeepAliveClientMixin<ProfileWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    const double padding = 25;
    const sidePadding = EdgeInsets.symmetric(horizontal: padding);
    // setData();
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            color: Colors.blue,
            child: Stack(children: [
              Positioned(
                right: 10,
                top: 10,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationEventLoggedOut(),
                    );
                  },
                  child: const Icon(Icons.logout),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileBoxWidget(
                    imagePath: ((widget.profile.avatar == '')
                        ? 'https://cdn.tricera.net/images/no-avatar.jpg'
                        : widget.profile.avatar!),
                    onClicked: () async {
                      Navigator.of(context).pushNamed(
                        '/EditProfile',
                      );
                    },
                  ),
                  addVerticalSpace(10),
                  Text(
                    widget.profile.email!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ]),
          ),
          addVerticalSpace(padding),
          Padding(
            padding: sidePadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Novel Marked',
                  style: headline1,
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      (widget.novelsFollowed.length).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          addVerticalSpace(5),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              itemCount: widget.novelsFollowed.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/NovelDetail',
                      arguments: RouteArgument(
                          id: widget.novelsFollowed[index].id,
                          argumentsList: [widget.novelsFollowed[index]]),
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
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.topCenter,
                                  image: CachedNetworkImageProvider(
                                      widget.novelsFollowed[index].image),
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
                              widget.novelsFollowed[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: nameNovel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.2),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
            ),
          )
        ],
      ),
    );
  }
}
