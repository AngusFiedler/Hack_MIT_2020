import 'package:flutter/material.dart';

class HabitCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Habit"),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Save Habit', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}