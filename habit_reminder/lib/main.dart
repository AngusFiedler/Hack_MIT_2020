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

// typedef FlipCallBack = void Function(int index);

class _DashboardState extends State<Dashboard> {
  TaskCollection collection = new TaskCollection(null, null);
  List listings = List<Widget>();

  void fetchTasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString('tasks'));
    if (pref.getString('tasks') != null) {
      Map json = jsonDecode(pref.getString('tasks'));
      this.collection = TaskCollection.fromJson(json);
      setState(() {
        listings = createCards();
      });
    }
  }

  void saveTasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String json = jsonEncode(collection);
    pref.setString('tasks', json);
  }

  void refreshState() async {
    this.fetchTasks();
  }

  void addCard(String name, int interval) {
    Task task = new Task(name, 0, "", interval);
    this.collection.tasks.add(task);
    this.saveTasks();
    this.refreshState();
  }

  void deleteCard(int index){
    this.collection.tasks.removeAt(index);
    this.saveTasks();
    this.refreshState();
  }

  void setTaskComplete(int index, bool success) {
    if (success) {
      this.collection.tasks[index].completed = 1;
    } else {
      this.collection.tasks[index].completed = 0;
    }

    this.saveTasks();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: createCards()),
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

  Column createCardColumn(String topCard, String task) {
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
  List<Widget> createCards() {
    if (collection.tasks == null) {
      return List<Widget>();
    }
    List listings = List<Widget>();
    for (int i = 0; i < collection.tasks.length; i++) {
      bool checkFront = false;
      if (collection.tasks[i].completed >= 1) {checkFront = true;}
      listings.add(
        FlipCard(
          onTap: setTaskComplete,
          onHold: deleteCard,
          cardIndex: i,
          onFront: checkFront,
          direction: FlipDirection.HORIZONTAL, // default
          back: Container(
            padding: const EdgeInsets.all(8),
            child: createCardColumn("Task Complete", collection.tasks[i].name),
            color: Colors.lightGreen[500],
          ),
          //   ),
          front: Container(
            padding: const EdgeInsets.all(8),
            child: createCardColumn("Incomplete", collection.tasks[i].name),
            color: Colors.deepOrange[500],
          ),
        ),
      );
    }
    return listings;
  }
}
