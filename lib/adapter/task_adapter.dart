import 'package:hive/hive.dart';

part 'task_adapter.g.dart';

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? subTitle;
  @HiveField(2)
  String? description;
  @HiveField(3)
  List<String> tasks = [];
  @HiveField(4)
  List<DateTime> dates = [];

  Task(
      {this.title,
      this.subTitle,
      this.description,
      required this.tasks,
      required this.dates});
}
