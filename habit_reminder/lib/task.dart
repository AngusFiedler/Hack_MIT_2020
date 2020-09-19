import 'package:flutter/cupertino.dart';

class Task extends ChangeNotifier {
  final String name;
  int completed = 0;
  String icon;

  Task(this.name, this.completed, this.icon);

  // Backup - use if it's not serializing the obj
  // Task.fromJson(Map<String, dynamic> json) : name = json['name'];
  // Map<String, dynamic> toJson() => {'name': name};
}

class TaskCollection {
  DateTime createdDate;

  List<Task> tasks;

  TaskCollection({this.createdDate, this.tasks});

  factory TaskCollection.fromJson(Map<String, dynamic> json) {
    return new TaskCollection(
        createdDate: json['name'] ?? "", tasks: json['tasks'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"createdDate": this.createdDate, "tasks": this.tasks};
  }
}
