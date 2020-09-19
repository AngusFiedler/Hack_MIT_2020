import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flip_card/flip_card.dart';

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
  void _fetch_tasks() {
    // TODO: fetch from localstorage
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Card generation

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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Creates widget's dynamically
  List<Widget> _create_cards() {
    List listings = List<Widget>();
    int i = 0;
    for (i = 0; i < 5; i++) {
      listings.add(
        FlipCard(
          direction: FlipDirection.HORIZONTAL, // default
          front: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.school),
            color: Colors.green,
          ),
        //   ),
          back: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.school),
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
