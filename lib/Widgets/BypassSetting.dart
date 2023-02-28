import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DevicesCommands.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';

class BypassWidget extends StatefulWidget {
  BypassWidget();

  @override
  _BypassWidgetState createState() => _BypassWidgetState();
}
class _BypassWidgetState extends State<BypassWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bypass"),
      ),
      body: Card(
        color: Colors.white,
        child: SwitchListTile(
          title: const Text('By pass',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )
          ),
          subtitle: const Text('pass detectors that not ready when you arm',
              style: TextStyle(
                fontSize: 15.0,
              )
          ),
          value: GlobalParameters.bypass_or_not,
          onChanged: (value) {
            setState(() {
              GlobalParameters.bypass_or_not = value;
            });
          },
          dense: true,
          selected: GlobalParameters.bypass_or_not,
          activeTrackColor: Colors.blue[200],
          activeColor: Colors.blue,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.black,

          //                  secondary: const Icon(Icons.lightbulb_outline),
        ),
      ),
    );
  }

}