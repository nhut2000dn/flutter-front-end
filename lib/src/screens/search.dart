import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_novel/config/util.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/services/novel_service.dart';
import 'package:my_novel/src/widgets/item_novel_vertical.dart';
import 'package:my_novel/src/widgets/widget_functions.dart';
import 'dart:async';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  late NovelService _novelService;
  Timer? _debounce;
  late List<NovelModel> novels = [];
  late TextEditingController _searchTextController;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () async {
      var novelss = await _novelService.search(query);
      setState(() {
        if (query != '') {
          novels = novelss;
        } else {
          novels = [];
        }
      });
      debugPrint(query);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _debounce?.cancel();
    _novelService = NovelService();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      _onSearchChanged(_searchTextController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: iconArrowBackBlack,
                  ),
                ),
                addHorizontalSpace(10),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _searchTextController,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(1),
                          child: Icon(Icons.search, color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.black38),
                        hintText: "Search"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: novels.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNovelVertical(
                  number: index + 1,
                  novel: novels[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
