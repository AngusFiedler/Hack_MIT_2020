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
  List listings = List<Widget>();

  void _fetch_tasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString('tasks'));
    if (pref.getString('tasks') != null) {
      Map json = jsonDecode(pref.getString('tasks'));
      this.collection = TaskCollection.fromJson(json);
      setState(() {
        listings = _create_cards();
      });
    }
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
    this.collection.tasks.add(task);
    this.refreshState();
    this._save_tasks();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    print('onrefresh');
    this.refreshState();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print('onloading');
    await Future.delayed(Duration(milliseconds: 1000));
    print('onloading delayed');
    if (mounted) {
      setState(() {
        print('loading cats...');
      });
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = new List<Widget>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: _create_cards()),
      ),
      // FAB for adding new card;
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

  Column _create_card_column(String topCard, String task) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(topCard,
            style: TextStyle(
              color: Colors.white,
            )),
        Icon(
          Icons.school,
          color: Colors.white,
        ),
        Text(task,
            style: TextStyle(
              color: Colors.white,
            )),
      ],
    );
  }

  // Creates widget's dynamically
  List<Widget> _create_cards() {
    if (collection.tasks == null) {
      return List<Widget>();
    }
    List listings = List<Widget>();
    int i = 0;
    for (i = 0; i < collection.tasks.length; i++) {
      bool check_front = false;
      listings.add(
        FlipCard(
          onFront: check_front,
          direction: FlipDirection.HORIZONTAL, // default
          front: Container(
            padding: const EdgeInsets.all(8),
            child:
                _create_card_column("Task Complete", collection.tasks[i].name),
            color: Colors.green,
          ),
          //   ),
          back: Container(
            padding: const EdgeInsets.all(8),
            child: _create_card_column("Incomplete", collection.tasks[i].name),
            color: Colors.red,
          ),
        ),
      );
    }
    return listings;
  }
}
