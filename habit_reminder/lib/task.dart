import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Task extends ChangeNotifier {
  final String name;
  int completed = 0;
  String icon;
  int frequency;

  Task(this.name, this.completed, this.icon, this.frequency);

  // Backup - use if it's not serializing the obj
  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        completed = json['completed'],
        frequency = json['frequency'];
  Map<String, dynamic> toJson() =>
      {'name': name, 'completed': completed, 'frequency': frequency};
}

class TaskCollection {
  DateTime createdDate;

  List<Task> tasks; // == null?????

  TaskCollection(DateTime createdDate, List<Task> _tasks)
      : createdDate = new DateTime.now(),
        tasks = _tasks;

  factory TaskCollection.fromJson(Map<String, dynamic> json) {
    List<Task> tasks =
        (json['tasks']).map<Task>((i) => Task.fromJson(i)).toList();
    return new TaskCollection(json['createdDate'] ?? new DateTime.now(), tasks);
  }

  Map<String, dynamic> toJson() {
    return {"createdDate": this.createdDate, "tasks": this.tasks};
  }
}
