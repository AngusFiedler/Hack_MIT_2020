import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Reminder',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(title: 'Habit Reminder'),
    );
  }
}

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TaskCollection collection;

  void _fetch_tasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map json = jsonDecode(pref.getString('tasks'));
    collection = TaskCollection.fromJson(json);
  }

  void _save_tasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String json = jsonEncode(collection);
    pref.setString('tasks', json);
  }

  void refreshState() async {
    this._fetch_tasks();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Card generation
    List<Widget> cards = new List<Widget>();

    this.collection.tasks.forEach((task) => {
          cards.add(Container(
              padding: const EdgeInsets.all(8),
              child: const Text("Insert card text here"),
              color: Colors.deepOrange))
        });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: cards,
      ),
      // FAB for adding new card;
      // TODO: Create card method
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
