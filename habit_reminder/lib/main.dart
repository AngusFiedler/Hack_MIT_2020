import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flip_card.dart';
import 'task.dart';
import 'create_habit.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Habits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(title: 'Daily Habits'),
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
  TaskCollection collection = new TaskCollection(null, null);

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

  void addCard(String name, int interval) {
    Task task = new Task(name, 0, "", interval);
    print(collection.tasks);
    collection.tasks.add(task);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Card generation
    List<Widget> cards = new List<Widget>();

    // this.collection.tasks.forEach((task) => {
    //       cards.add(Container(
    //           padding: const EdgeInsets.all(8),
    //           child: const Text("Insert card text here"),
    //           color: Colors.deepOrange))
    //     });

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
          children: _create_cards()),
      // FAB for adding new card;
      // TODO: Create card method
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitCreator(this.addCard),
              ));
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Creates widget's dynamically
  List<Widget> _create_cards() {
    List listings = List<Widget>();
    int i = 0;
    for (i = 0; i < 10; i++) {
      listings.add(
        FlipCard(
          onFront: false,
          direction: FlipDirection.HORIZONTAL, // default
          front: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Task Complete!',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Icon(
                  Icons.school,
                  color: Colors.white,
                ),
                Text('Do my homework',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
            color: Colors.green,
          ),
          //   ),
          back: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                ),
                Text('Do my homework',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
            color: Colors.red,
          ),
        ),

        // Container(
        //     padding: const EdgeInsets.all(8),
        //     child: const Icon(Icons.school),
        //     color: Colors.green,
        //   ),
      );
    }
    return listings;
  }
}
