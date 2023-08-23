import 'package:hive/hive.dart';

part 'note_adapter.g.dart';

@HiveType(typeId: 1)
class Notes {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? content;

  Notes({this.title, this.content});
}
