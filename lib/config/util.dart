import 'package:flutter/material.dart';

TextStyle titleAppBar = const TextStyle(
    fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white);

TextStyle headline1 = const TextStyle(
    fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black);

TextStyle headline2 = const TextStyle(
    fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);

TextStyle headlineNovelDetail = const TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);

TextStyle nameNovel = const TextStyle(
    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0);

TextStyle nameNovelDetail = const TextStyle(
    color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22.0);

TextStyle nameAuthor = const TextStyle(
    color: Colors.white, fontWeight: FontWeight.w300, fontSize: 17.0);

TextStyle nameGenre = const TextStyle(
    color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0);

TextStyle numberChapter = TextStyle(
    color: Colors.grey.shade900, fontWeight: FontWeight.w400, fontSize: 15.0);

TextStyle updateToChapter = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 14.0);

TextStyle numberListChapter = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w400, fontSize: 16.0);

TextStyle dateRelease = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w300, fontSize: 15.0);

TextStyle status = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w500, fontSize: 16.0);

TextStyle viewNumber = const TextStyle(color: Colors.red, fontSize: 16.3);

TextStyle viewFollower = const TextStyle(color: Colors.red, fontSize: 16.3);

TextStyle verticalLine = const TextStyle(
    color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold);

Icon iconView = const Icon(
  Icons.remove_red_eye,
  size: 14,
  color: Colors.red,
);

Icon iconHeart = const Icon(
  Icons.favorite,
  size: 14,
  color: Colors.red,
);

TextStyle numberViewNovelDetail =
    const TextStyle(fontSize: 17.0, color: Colors.white);

TextStyle numberFollowerNovelDetail =
    const TextStyle(fontSize: 17.0, color: Colors.white);

Icon iconViewNovelDetail =
    const Icon(Icons.remove_red_eye, size: 17.0, color: Colors.white);

Icon iconHeartNovelDetail =
    const Icon(Icons.favorite, size: 17.0, color: Colors.white);

Icon iconHeartButton =
    const Icon(Icons.favorite, size: 25.0, color: Colors.white);

Icon iconHeartRedButton =
    const Icon(Icons.favorite, size: 25.0, color: Colors.red);

Icon iconArrowBack = const Icon(
  Icons.arrow_back_ios,
  size: 25,
  color: Colors.white,
);

Icon iconArrowBackBlack = const Icon(
  Icons.arrow_back_ios_rounded,
  size: 20,
  color: Colors.black,
);

Border borderTopBottom = Border(
  top: BorderSide(width: 0.5, color: Colors.grey[400]!),
  bottom: BorderSide(width: 0.5, color: Colors.grey[400]!),
);

Border borderTopBottom2 = const Border(
  top: BorderSide(width: 0.6, color: Colors.black45),
  bottom: BorderSide(width: 0.6, color: Colors.black45),
);

BoxDecoration boxDecorationGenre = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.grey.shade400),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade400,
      spreadRadius: 1,
      blurRadius: 2,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
);
