import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';

class SettingsDelays extends StatefulWidget {



  SettingsDelays();

  @override
  _SettingsDelaysState createState() => _SettingsDelaysState();
}

class _SettingsDelaysState extends State<SettingsDelays> {
  List<SettingParameter> delays_settings_parameters = [
    SettingParameter("Exit delay time",GlobalParameters.exitSelectedLocation,Colors.white,false),
    SettingParameter("Entry delay time",GlobalParameters.entrySelectedLocation,Colors.white,false),
    SettingParameter("Siren time",GlobalParameters.sirenSelectedLocation,Colors.white,false),
  ];
  @override
  Widget build(BuildContext context) {
    delays_settings_parameters = [
      SettingParameter("Exit delay time",GlobalParameters.exitSelectedLocation,Colors.white,false),
      SettingParameter("Entry delay time",GlobalParameters.entrySelectedLocation,Colors.white,false),
      SettingParameter("Siren time",GlobalParameters.sirenSelectedLocation,Colors.white,false),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Delays"),
      ),
      body: SettingSection(options: delays_settings_parameters),
    );
  }
}
class ExitDelayTime extends StatefulWidget {
  ExitDelayTime();

  @override
  _ExitDelayTimeState createState() => _ExitDelayTimeState();
}

class _ExitDelayTimeState extends State<ExitDelayTime> {
  List<SelectOptions> _options = [
    SelectOptions("5 Seconds",false),
    SelectOptions("15 Seconds",false),
    SelectOptions("30 Seconds",false),
    SelectOptions("45 Seconds",false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exit delay time"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: SwitchListTile(
              title: const Text('Exit delay time',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              subtitle: const Text(
                  'Wait selected time before the system is armed away',
                  style: TextStyle(
                    fontSize: 15.0,
                  )
              ),
              value: GlobalParameters.is_exit_delay_time,
              onChanged: (value) {
                setState(() {
                  if (value == false)
                    GlobalParameters.exitSelectedLocation = "Disabled";
                  GlobalParameters.is_exit_delay_time = value;
                });
              },
              dense: true,
              selected: GlobalParameters.is_exit_delay_time,
              activeTrackColor: Colors.blue[200],
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.black,
            ),
          ),
          GlobalParameters.is_exit_delay_time == true ? Container(
            color: Colors.white,
            child: SelectFromOptions(
              explanation: "Choose the time the system will wait before the system arms away",
              default_val: GlobalParameters.exitSelectedLocation,//"Happy beep",//GlobalParameters.selected_chime_option,
              options: _options,
              returned_val: (String val) {
                setState(() {
                  GlobalParameters.exitSelectedLocation = val;
                });

              },
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
class EntryDelayTime extends StatefulWidget {
  EntryDelayTime();

  @override
  _EntryDelayTimeState createState() => _EntryDelayTimeState();
}

class _EntryDelayTimeState extends State<EntryDelayTime> {
  List<SelectOptions> _options = [
    SelectOptions("5 Seconds",false),
    SelectOptions("15 Seconds",false),
    SelectOptions("30 Seconds",false),
    SelectOptions("45 Seconds",false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry delay time"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: SwitchListTile(
              title: const Text('Entry delay time',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              subtitle: const Text(
                  'Wait selected time before the alarm start',
                  style: TextStyle(
                    fontSize: 15.0,
                  )
              ),
              value: GlobalParameters.is_entry_delay_time,
              onChanged: (value) {
                setState(() {
                  if (value == false)
                    GlobalParameters.entrySelectedLocation = "Disabled";
                  GlobalParameters.is_entry_delay_time = value;
                });
              },
              dense: true,
              selected: GlobalParameters.is_entry_delay_time,
              activeTrackColor: Colors.blue[200],
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.black,
            ),
          ),
          GlobalParameters.is_entry_delay_time == true ? Container(
            color: Colors.white,
            child: SelectFromOptions(
              explanation: "Choose the time the system will wait before the system arms away",
              default_val: GlobalParameters.entrySelectedLocation,//"Happy beep",//GlobalParameters.selected_chime_option,
              options: _options,
              returned_val: (String val) {
                setState(() {
                  GlobalParameters.entrySelectedLocation = val;
                });

              },
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
class SirenTime extends StatefulWidget {
  SirenTime();

  @override
  _SirenTimeState createState() => _SirenTimeState();
}

class _SirenTimeState extends State<SirenTime> {
  List<SelectOptions> _options = [
    SelectOptions("15 Seconds",false),
    SelectOptions("30 Seconds",false),
    SelectOptions("1 Minute",false),
    SelectOptions("8 Minutes",false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siren time"),
      ),
      body: Column(
        children: <Widget>[

          Container(
            color: Colors.white,
            child: SelectFromOptions(
              explanation: "Select the time that the system will do an alarm",
              default_val: GlobalParameters.sirenSelectedLocation,//"Happy beep",//GlobalParameters.selected_chime_option,
              options: _options,
              returned_val: (String val) {
                setState(() {
                  GlobalParameters.sirenSelectedLocation = val;
                });

              },
            ),
          ),
        ],
      ),
    );
  }

}