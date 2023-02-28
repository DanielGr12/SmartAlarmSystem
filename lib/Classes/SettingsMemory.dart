import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';

class AlarmMemory extends StatefulWidget {
  AlarmMemory();

  @override
  _AlarmMemoryState createState() => _AlarmMemoryState();
}

class _AlarmMemoryState extends State<AlarmMemory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Last alarm memory"),
      ),
      body: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: GlobalParameters.memory.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCard(context, index))),
    );
  }
  Widget buildCard(BuildContext context, int index) {
    return Card(
      child: ListTile(
        leading: GlobalParameters.memory[index].icon,
        title: Text(GlobalParameters.memory[index].detector_name),
      ),
    );
  }
  static void add_to_alarm_memory()
  {
    //TODO: when i finish the the smartthings integration add to the GlobalParameters.memory the event with the device label

  }
}