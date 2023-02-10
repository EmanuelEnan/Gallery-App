import 'package:hive/hive.dart';
part 'bookmarks.g.dart';

@HiveType(typeId: 0)
class Bookmarks extends HiveObject {
  @HiveField(0)
  String? photoUrl;

  Bookmarks({this.photoUrl});
}
