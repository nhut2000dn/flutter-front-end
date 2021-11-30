class RouteArgument {
  String? id;
  List<dynamic>? argumentsList;

  RouteArgument({this.id, this.argumentsList});

  @override
  String toString() {
    return '{id: $id, heroTag:${argumentsList.toString()}}';
  }
}
