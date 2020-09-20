import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Task extends ChangeNotifier {
  final String name;
  int completed = 0;
  String icon;
  int frequency;

  Task(this.name, this.completed, this.icon, this.frequency);

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        completed = json['completed'],
        frequency = json['frequency'],
        icon = json['icon'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'completed': completed,
        'frequency': frequency,
        'icon': icon
      };
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
    DateTime _createdDate = DateTime.parse(json['createdDate']);
    return new TaskCollection(_createdDate, tasks);
  }

  Map<String, dynamic> toJson() {
    return {
      "createdDate": this.createdDate.toIso8601String(),
      "tasks": this.tasks
    };
  }
}
