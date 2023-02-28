import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/DevicesWidget.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';

class DeviceOptions extends StatefulWidget {
  DeviceOptions();

  @override
  _DeviceOptionsState createState() => _DeviceOptionsState();
}

class _DeviceOptionsState extends State<DeviceOptions> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Devices categories"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              color: Colors.white70,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: GlobalParameters.devices_sections.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildCard(context, index))),
        ],
      ),
    );
  }
  Widget buildCard(BuildContext context, int index)
  {
    return Card(
      child: ListTile(
        leading: GlobalParameters.devices_sections[index].icon,//Icon(Icons.business)
        title: Text(GlobalParameters.devices_sections[index].section_name),
        trailing: Icon(Icons.navigate_next),
        onTap: (){
          switch(GlobalParameters.devices_sections[index].section_name)
          {
            case "Contact detectors":
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                    DeviceSection(GlobalParameters.contact_devices,"Contact detectors"),
                ));
              }
              break;
            case "Motion detectors":
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        DeviceSection(GlobalParameters.pir_devices,"Motion detectors"),
                    ));
              }
              break;
          }

        },
      ),
    );
  }
}
class DeviceSection extends StatefulWidget {
  List<Device> devices_list;
  String appbar;
  DeviceSection(this.devices_list,this.appbar);

  @override
  _DeviceSectionState createState() => _DeviceSectionState();
}

class _DeviceSectionState extends State<DeviceSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appbar),
      ),
      body: Container(
          color: Colors.white70,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.devices_list.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCard(context, index))),
    );
  }
  Widget buildCard(BuildContext context, int index)
  {
    return Card(
      child: ListTile(
        title: Text(widget.devices_list[index].label),
        trailing: Icon(Icons.navigate_next),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  DevicePressed(widget.devices_list[index]),
              ));
          GlobalParameters.selected_section_device = widget.devices_list[index];
        },
      ),
    );
  }
}
class DevicePressed extends StatefulWidget {
  Device device;
  DevicePressed(this.device);

  @override
  _DevicePressedState createState() => _DevicePressedState();
}

class _DevicePressedState extends State<DevicePressed> {
  List<SettingParameter> device_settings_parameters = [
    SettingParameter("Zone type","",Colors.white,true,Icon(Icons.place,color: Colors.blueAccent)),
    SettingParameter("Device chime","",Colors.white,true,Icon(Icons.volume_up,color: Colors.blueAccent)),
  ];
  @override
  Widget build(BuildContext context) {
    List<SettingParameter> device_settings_parameters = [
      SettingParameter("Zone type",widget.device.type,Colors.white,true,Icon(Icons.place,color: Colors.blueAccent)),
      SettingParameter("Device chime",widget.device.detector_chime,Colors.white,true,Icon(Icons.volume_up,color: Colors.blueAccent)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.label),
      ),
      body: Container(
        color: back_color,
        child: SingleChildScrollView(
          reverse: false,
          child: Container(
            color: back_color,//Colors.grey[100],
            padding: EdgeInsets.only(top:10),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:10),
                ),
                SettingSection(options: device_settings_parameters),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
class DeviceChime extends StatefulWidget {
  DeviceChime();

  @override
  _DeviceChimeState createState() => _DeviceChimeState();
}

class _DeviceChimeState extends State<DeviceChime> {
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
          title: Text("Device chime"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.white,
                child: SwitchListTile(
                  title: const Text('Device chime',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  subtitle: const Text(
                      'Do a sound when the deivce does an event',
                      style: TextStyle(
                        fontSize: 15.0,
                      )
                  ),
                  value: GlobalParameters.selected_section_device.is_chime_enabled,
                  onChanged: (value) {
                    setState(() {
                      if (value == false)
                        GlobalParameters.selected_section_device.detector_chime = "Disabled";
                      GlobalParameters.selected_section_device.is_chime_enabled = value;
                    });
                  },
                  dense: true,
                  selected: GlobalParameters.selected_section_device.is_chime_enabled,
                  activeTrackColor: Colors.blue[200],
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.black,
                ),
              ),
              GlobalParameters.selected_section_device.is_chime_enabled == true ? Container(
                color: Colors.white,
                child: SelectFromOptions(
                  explanation: "Choose which sound the system will make when you do an event on this device",
                  default_val: GlobalParameters.selected_section_device.detector_chime,//"Happy beep",//GlobalParameters.selected_chime_option,
                  options: _options,
                  returned_val: (String val) {
                    GlobalParameters.selected_section_device.detector_chime = val;
                  },
                ),
              ) : SizedBox.shrink(),
            ],
          ),


        ));
  }

}
class ZoneType extends StatefulWidget {
  ZoneType();

  @override
  _ZoneTypeState createState() => _ZoneTypeState();
}

class _ZoneTypeState extends State<ZoneType> {
  List<SelectOptions> _options = [
    SelectOptions("Perimeter",false),
    SelectOptions("Interior",false),
    SelectOptions("Delay",false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zone type"),
      ),
      body: SelectFromOptions(
        explanation: "Select which zone you want the detector to be in \n\n"
            "1. Perimeter - The detectors that surround the house and in arm home mode they are the only detectors that will be armed \n\n"
            "2. Interior - The detectors that in the house and not surround it\n\n"
            "3. Delay - The detectors that also in arm home and arm away will be armed",
        default_val: GlobalParameters.selected_section_device.type,//"Happy beep",//GlobalParameters.selected_chime_option,
        options: _options,
        returned_val: (String val) {
          for(int i = 0;i < Device.DevicesList.length;i ++)
          {
            if (Device.DevicesList[i].deviceId == GlobalParameters.selected_section_device.deviceId)
            {
              Device.DevicesList[i].type = val;
            }
          }
        },
      ),
    );
  }


}