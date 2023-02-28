import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Classes/log.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';
class TroublesSettingsPage extends StatefulWidget {
  TroublesSettingsPage();

  @override
  _TroublesSettingsPageState createState() => _TroublesSettingsPageState();
}
class _TroublesSettingsPageState extends State<TroublesSettingsPage> {
  List<SettingParameter> troubles_settings = [
    SettingParameter("Device low battery",GlobalParameters.selected_low_battery_percent,Colors.white,false),
  ];
  @override
  Widget build(BuildContext context) {
    troubles_settings = [
      SettingParameter("Device low battery",GlobalParameters.selected_low_battery_percent,Colors.white,false),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Trouble settings"),
      ),
      body: Column(
        children: <Widget>[
          SettingSection(options: troubles_settings)
        ],
      ),
    );
  }

}
class DeviceLowBattery extends StatefulWidget {
  DeviceLowBattery();

  @override
  _DeviceLowBatteryState createState() => _DeviceLowBatteryState();
}
class _DeviceLowBatteryState extends State<DeviceLowBattery> {
  @override
  List<SelectOptions> _options = [
    SelectOptions("10%",false),
    SelectOptions("20%",false),
    SelectOptions("30%",false),
    SelectOptions("40%",false),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device low battery"),
      ),
      body: SelectFromOptions(
        explanation: "Choose what is the percent that you will be noticed that device battery is low",
        default_val: GlobalParameters.selected_low_battery_percent,//"Happy beep",//GlobalParameters.selected_chime_option,
        options: _options,
        returned_val: (String val) {
          GlobalParameters.selected_low_battery_percent = val;
          String str_low_battery_precentege = GlobalParameters.selected_low_battery_percent.replaceAll("%","");
          int low_battery_precentege = int.parse(str_low_battery_precentege);

          GlobalParameters.troubles.removeWhere((item) => item.event == "low battery");

          for (int i = 0;i < Device.DevicesList.length;i ++)
          {
            if (Device.DevicesList[i].capabilities.contains("battery"))
            {
              if (Device.DevicesList[i].status.main.battery.battery.value <= low_battery_precentege)
              {
                //TODO: send notification
                setState(() {
                  GlobalParameters.troubles.add(TroubleCell("Low battery to ${Device.DevicesList[i].label}",Icon(Icons.battery_alert,color: Colors.redAccent),"low battery"));
                });
                DateTime now = new DateTime.now();
                String formattedDate = DateFormat('yyyy.MM.dd , HH:mm:ss ').format(now);
                var my_log_key = UniqueKey();
                LogEvent event = new LogEvent(formattedDate, "Low battery to ${Device.DevicesList[i].label}", my_log_key, false,"");
                LogEvent.LogEvents.add(event);

              }
            }

          }
//          for (int i = 0;i< GlobalParameters.troubles.length;i ++)
////            {
              if (GlobalParameters.troubles.length == 0)
              {
                setState(() {
                  GlobalParameters.shortcuts.clear();
                });
              }
              else
                {
                  GlobalParameters.shortcuts.add(MainShourtcut(GlobalParameters.troubles.length.toString(),Icon(Icons.warning,color: Colors.orange,size: 35),"trouble"));
                }
////            }

        },
      ),
    );
  }
}


class SettingsTrouble extends StatefulWidget {
  SettingsTrouble();

  @override
  _SettingsTroubleState createState() => _SettingsTroubleState();
}

class _SettingsTroubleState extends State<SettingsTrouble> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Troubles"),
      ),
      body: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: GlobalParameters.troubles.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCard(context, index))),
    );
  }
  Widget buildCard(BuildContext context, int index) {
    return Card(
        child: ListTile(
          leading: GlobalParameters.troubles[index].icon,
          title: Text(GlobalParameters.troubles[index].name),
        ),
    );
  }
}