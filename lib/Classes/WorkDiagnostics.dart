import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/DevicesWidget.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';

class WorkDiagnostics extends StatefulWidget {
  WorkDiagnostics();

  @override
  _WorkDiagnosticsState createState() => _WorkDiagnosticsState();
}

class _WorkDiagnosticsState extends State<WorkDiagnostics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Diagnostics"),
      ),
      //body: ,
    );
  }

}