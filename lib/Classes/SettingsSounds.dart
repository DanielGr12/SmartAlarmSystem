import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';

class SettingsSounds extends StatefulWidget {



  SettingsSounds();

  @override
  _SettingsSoundsState createState() => _SettingsSoundsState();
}

class _SettingsSoundsState extends State<SettingsSounds> {
  List<SettingParameter> sounds_settings_parameters = [
    SettingParameter("Chime",GlobalParameters.chimeSelectedLocation,Colors.white,false),
  ];
  @override
  Widget build(BuildContext context) {
    sounds_settings_parameters = [
      SettingParameter("Chime",GlobalParameters.chimeSelectedLocation,Colors.white,false),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Sounds"),
      ),
      body: SettingSection(options: sounds_settings_parameters),
    );
  }

}
class ChimeOptions extends StatefulWidget {
  ChimeOptions();

  @override
  _ChimeOptionsState createState() => _ChimeOptionsState();
}
class _ChimeOptionsState extends State<ChimeOptions> {
  List<SelectOptions> _options = [
    SelectOptions("Happy beep",false),
    SelectOptions("Ding dong",false),
    SelectOptions('"Door opened"',false),
  ];
//  List<SettingParameter> sounds_settings_parameters = [
//    SettingParameter("Chime",GlobalParameters.chimeSelectedLocation,Colors.white),
//  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back_color,
      appBar: AppBar(
        title: Text("Chime"),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.white,
                child: SwitchListTile(
                  title: const Text('Chime',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  subtitle: const Text(
                      'Do a sound when the door you open the door',
                      style: TextStyle(
                        fontSize: 15.0,
                      )
                  ),
                  value: GlobalParameters.is_chime_enabled,
                  onChanged: (value) {
                    setState(() {
                      if (value == false)
                        GlobalParameters.chimeSelectedLocation = "Disabled";
                      GlobalParameters.is_chime_enabled = value;
                    });
                  },
                  dense: true,
                  selected: GlobalParameters.is_chime_enabled,
                  activeTrackColor: Colors.blue[200],
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.black,
                ),
              ),
              GlobalParameters.is_chime_enabled == true ? Container(
                  color: Colors.white,
                  child: SelectFromOptions(
                    explanation: "Choose which sound the system will make when you open the door",
                    default_val: GlobalParameters.chimeSelectedLocation,//"Happy beep",//GlobalParameters.selected_chime_option,
                    options: _options,
                    returned_val: (String val) {
                      GlobalParameters.chimeSelectedLocation = val;
                    },
                  ),
                ) : SizedBox.shrink(),
            ],
          ),


    ));
  }

}