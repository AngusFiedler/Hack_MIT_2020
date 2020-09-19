import 'package:flutter/cupertino.dart';

class Task extends ChangeNotifier {
  final String name;
  int completed = 0;
  String icon;
  int frequency;

  Task(this.name, this.completed, this.icon, this.frequency);

  // Backup - use if it's not serializing the obj
  // Task.fromJson(Map<String, dynamic> json) : name = json['name'];
  // Map<String, dynamic> toJson() => {'name': name};
}

class TaskCollection {
  DateTime createdDate;

  List<Task> tasks; // == null?????

  TaskCollection(DateTime createdDate, List<Task> tasks)
      : createdDate = null,
        tasks = new List<Task>();

  factory TaskCollection.fromJson(Map<String, dynamic> json) {
    return new TaskCollection(json['name'] ?? "", json['tasks'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"createdDate": this.createdDate, "tasks": this.tasks};
  }
}
