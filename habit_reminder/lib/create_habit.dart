import 'package:flutter/material.dart';
import 'package:habit_reminder/task.dart';

class HabitCreator extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final habitTextController = TextEditingController();
  final frequencyTextController = TextEditingController();

  Function addCallback;

  HabitCreator(Function callback) {
    addCallback = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Habit"),
      ),
      body: Center(
          child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: habitTextController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.assignment),
                    hintText: 'Enter Habit Here',
                    labelText: 'New Habit',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a habit!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: frequencyTextController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    hintText: 'Frequency (days)',
                    labelText: 'Frequency',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a frequency!';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                onSave(context, habitTextController.text,
                    frequencyTextController.text);
              }
            },
            child: Text(
              'Save Habit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      )),
    );
  }

  void onSave(BuildContext context, habitName, habitFrequency) {
    this.addCallback(habitName, int.parse(habitFrequency));
    print(habitName);
    print(habitFrequency);
    Navigator.pop(context);
  }
}
