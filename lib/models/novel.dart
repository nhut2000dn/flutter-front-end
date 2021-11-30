class NovelModel {
  late String id;
  late String name;
  late String image;
  late String description;
  late bool status;
  late int chapter;
  late int reader;
  late int follower;
  late int yearRelease;
  late String authorId;
  NovelModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.status,
    required this.chapter,
    required this.reader,
    required this.follower,
    required this.yearRelease,
    required this.authorId,
  });
}
