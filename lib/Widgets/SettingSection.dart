import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/ArmOptions.dart';
import 'package:tcp_alarm_system/Classes/DeviceOptions.dart';
import 'package:tcp_alarm_system/Classes/DevicesCommands.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Classes/SettingsDelays.dart';
import 'package:tcp_alarm_system/Classes/SettingsPrivacy.dart';
import 'package:tcp_alarm_system/Classes/SettingsSounds.dart';
import 'package:tcp_alarm_system/Classes/SettingsTrouble.dart';
import 'package:tcp_alarm_system/Widgets/BypassSetting.dart';
import 'package:tcp_alarm_system/Widgets/RandomLight.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';
import '../Globals/GlobalParameters.dart';
class SettingSection extends StatefulWidget {

  final List<SettingParameter> options;
  //SelectFromOptions(this.options);
  SettingSection({
    this.options,
  });
  @override
  _SettingSection createState() => _SettingSection();
}
class _SettingSection extends State<SettingSection> {
  Color more_lights_color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.options.length,
        itemBuilder: (BuildContext context, int index) =>
        buildCard(context, index)));
  }
  Widget buildCard(BuildContext context, int index)
  {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTapDown: (val){
            setState(() {
              widget.options[index].current_color = Colors.grey[200];
            });

          },
          onTapUp: (val){
            widget.options[index].current_color = Colors.white;
            switch(widget.options[index].text)
            {
              case "Arm options":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        show_more_lights(Device.lights_card_info_list)),
                  );
                }
                break;
              case "Randomly light":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                       RandomLightWidget()), //randomly_light()
                  );
                }
                break;
              case "Bypass":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        BypassWidget()), //randomly_light()
                  );
                }
                break;
              case "Sounds":
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      SettingsSounds()), //randomly_light()
                );
              }
              break;
              case "Chime":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ChimeOptions()), //randomly_light()
                  );
                }
                break;
              case "Delays":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SettingsDelays()), //randomly_light()
                  );
                }
                break;
              case "Exit delay time":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ExitDelayTime()), //randomly_light()
                  );
                }
                break;
              case "Entry delay time":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        EntryDelayTime()), //randomly_light()
                  );
                }
                break;
              case "Siren time":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SirenTime()), //randomly_light()
                  );
                }
                break;
              case "Privacy":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SettingsPrivacy()), //randomly_light()
                  );
                }
                break;
              case "System code":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SettingsCode()), //randomly_light()
                  );
                }
                break;
              case "Device low battery":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        DeviceLowBattery()), //randomly_light()
                  );
                }
                break;
              case "Trouble":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SettingsTrouble()), //randomly_light()
                  );
                }
                break;
              case "Trouble settings":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        TroublesSettingsPage()),
                  );
                }
                break;
              case "Device/Zone options":
                {
                  GlobalParameters.pir_devices.clear();
                  GlobalParameters.contact_devices.clear();
                  for (int i = 0;i < Device.DevicesList.length;i ++)
                  {
                    switch(Device.DevicesList[i].detector_section)
                    {
                      case "motion":
                        {
                          GlobalParameters.pir_devices.add(Device.DevicesList[i]);
                        }
                        break;
                      case "contact":
                        {
                          GlobalParameters.contact_devices.add(Device.DevicesList[i]);
                        }
                        break;
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        DeviceOptions()),
                  );
                }
                break;
              case "Zone type":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ZoneType()),
                  );
                }
                break;
              case "Device chime":
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        DeviceChime()),
                  );
                }
                break;
            }
          },
          child: Container(
            color: widget.options[index].current_color,
              child: ListTile(
                  leading: widget.options[index].show_icon == true ? widget.options[index].icon : null,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.options[index].text),
                      Text(widget.options[index].selected,style: TextStyle(
                        color: Colors.grey[600]
                      ),),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next,size: 30,),
//                  onTap: (){
//                    GestureDetector(
//                      onTapDown: (val){
//                        widget.options[index].current_color = Colors.grey;
//                      },
//                      onTapUp: (val){
//                        if (widget.options[index].text == "Arm options") {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) =>
//                                show_more_lights(Device.lights_card_info_list)),
//                          );
//                        }
//                      },
//                    );
//
////              setState(() {
////                widget.options.forEach((option) {
////                  if (option.text != widget.options[index].text)
////                  {
////                    option.is_selected = false;
////                  }
////                  else
////                  {
////                    option.is_selected = true;
////                    widget.returned_val(option.text);
////                  }
////                } );
////                //          _show_more_lightsState.random_time = "30 minutes";
////                //          GlobalParameters.light_selected_30_min = true;
////                //          GlobalParameters.light_selected_1_hour = false;
////                //          GlobalParameters.light_selected_2_hours = false;
////              });
//
//                  },
                ),

          ),
        ),

//        ListTile(
//          title: Text(widget.options[index].text),
//          trailing: trailing_val(index),
//          onTap: (){
//            setState(() {
//              widget.options.forEach((option) {
//                if (option.text != widget.options[index].text)
//                  {
//                    option.is_selected = false;
//                  }
//                else
//                  {
//                    option.is_selected = true;
//                    widget.returned_val(option.text);
//                  }
//              } );
////          _show_more_lightsState.random_time = "30 minutes";
////          GlobalParameters.light_selected_30_min = true;
////          GlobalParameters.light_selected_1_hour = false;
////          GlobalParameters.light_selected_2_hours = false;
//            });
//
//          },
//        ),
        Ink(
            color: Colors.white,
            child: Divider(
              color: Colors.grey,
              height: 3,
//              endIndent: 20,
//              indent: 20,
            )
        )
      ],
    );
//    return Card(
//      child: ListTile(
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(title,style: TextStyle(
//                fontSize: 19,
//                fontWeight: FontWeight.bold
//            ),),
//            Text(selected,style: TextStyle(color: Colors.grey),)
//          ],
//        ),
//        trailing: IconButton(
//          icon: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Icon(Icons.navigate_next),//,color: more_lights_color),
//            ],
//          ),
//          onPressed: () {
//            if (title == "Arm options")
//              {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) =>
//                      show_more_lights(Device.lights_card_info_list)),
//                );
//              }
//
//          },
//        ),
//      ),
//    );
  }


//  final String title;
//  final String selected;
//  //SelectFromOptions(this.options);
//  SettingSection({
//    this.title,
//    this.selected
//  });
  //@override
  //_SettingSectionState createState() => _SettingSectionState();
  Widget randomly_light()
  {
    return Scaffold(
        backgroundColor: back_color,
        appBar: AppBar(
          title: Text("Random light options"),
        ),
        body:
        Column(
          children: <Widget>[
            Card(
              child: SwitchListTile(
                title: const Text('Random light',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )
                ),
                subtitle: const Text('turn on light every selected time',
                    style: TextStyle(
                      fontSize: 15.0,
                    )
                ),
                value: GlobalParameters.TurnOnLightSelectedLocation_or_not,
                onChanged: (value) {
                  setState(() {
                    if (value == false)
                    {
                      more_lights_color = Colors.black;
                    }
                    else if (value == true)
                    {
                      more_lights_color = Colors.blueAccent;
                    }
                    GlobalParameters.TurnOnLightSelectedLocation_or_not = value;
//            _controller = ScrollController();
//            _controller.animateTo(pixelsToMove,
//                curve: Curves.linear, duration: Duration (milliseconds: 500));
//            _controller.animateTo(_controller.offset + itemSize,
//                curve: Curves.linear, duration: Duration(milliseconds: 500));
                  });
                },
                dense: true,
                selected: GlobalParameters.TurnOnLightSelectedLocation_or_not,
                activeTrackColor: Colors.blue[200],
                activeColor: Colors.blueAccent,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.black,

                //                  secondary: const Icon(Icons.lightbulb_outline),
              ),
            ),
//          Card(
//            child: ListTile(
//                title: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Text("Lights options"),
//                    Spacer(),
//                    Text(_show_more_lightsState.random_time),
//
//                  ],
//                ),
//                trailing: IconButton(
//                  icon: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Icon(Icons.navigate_next),
//                    ],
//                  ),
//                  onPressed: () {
//                    if (GlobalParameters.TurnOnLightSelectedLocation_or_not == true)
//                    {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) =>
//                            show_more_lights(Device.lights_card_info_list)),
//                      );
//                    }
//                  },
//                )
//
//
//
//            ),
//          )
            GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? Card(
                child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Lights options"),
                        Spacer(),
                        Text(GlobalParameters.selected_range_time),

                      ],
                    ),
                    trailing: IconButton(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.navigate_next),
                        ],
                      ),
                      onPressed: () {
//                        Navigator.push(
//                          context,
//                          //MaterialPageRoute(builder: (context) => choose_light_random_time()),
//                        );
                      },
                    )



                )
            ): SizedBox.shrink(),
//          Card(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.keyboard_arrow_down),
//                  onPressed: (){
//                    setState(() {
//                      if (random_time == "2 hours")
//                      {
//                        random_time = "1 hour";
//                      }
//                      else if (random_time == "1 hour")
//                      {
//                        random_time = "30 minutes";
//                      }
//                    });
//
//                  },
//                ),
//
//                Text(random_time,style: TextStyle(
//                  fontSize: 20,
//                ),),
//                IconButton(
//                  icon: Icon(Icons.keyboard_arrow_up),
//                  onPressed: (){
//                    setState(() {
//                      if (random_time == "1 hour")
//                      {
//                        random_time = "2 hours";
//                      }
//                      else if (random_time == "30 minutes")
//                      {
//                        random_time = "1 hour";
//                      }
//                    });
//                  },
//                ),
//              ],
//            ),
//          ),
            GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? RandomLightWidget() : SizedBox.shrink(),
//            Container(
//              child: ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  itemCount: Device.lights_card_info_list.length,
//                  itemBuilder: (BuildContext context, int index) =>
//                      ArmOptions.buildCard(context, index)),
//            ): SizedBox.shrink(),
          ],
        )
    );
//      Container(
//      child: ListView.builder(
//          scrollDirection: Axis.vertical,
//          shrinkWrap: true,
//          itemCount: Device.lights_card_info_list.length,
//          itemBuilder: (BuildContext context, int index) =>
//              buildCard(context, index)),
//    );
  }
//  Widget buildLightCard(BuildContext context, int index)
//  {
//    return Card(
//      color: Device.lights_card_info_list[index].active_or_not_color,
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
////                  ListTile(
////                    title: Text(
////                      pair.asPascalCase,
////                      style: _biggerFont,
////                    ),
////                    trailing: Icon(
////                      alreadySaved ? Icons.favorite : Icons.favorite_border,
////                      color: alreadySaved ? Colors.red : null,
////                    ),
////                    onTap: () {      // Add 9 lines from here...
////                      setState(() {
////                        if (alreadySaved) {
////                          _saved.remove(pair);
////                        } else {
////                          _saved.add(pair);
////                        }
////                      });
////                    },               // ... to here.
////                  ),
//              IconButton(
//                icon: Device.lights_card_info_list[index].icon,//is_added == false ? Icon(Icons.add) : Icon(Icons.verified_user),
//                color: Device.lights_card_info_list[index].icon_color,
//                onPressed: (){
//                  setState(() {
//                    if (Device.lights_card_info_list[index].checkbox_val == true)
//                    {
//                      Device.lights_card_info_list[index].checkbox_val = false;
//                      Device.lights_card_info_list[index].icon = Icon(Icons.verified_user);
//                      Device.lights_card_info_list[index].icon_color = Colors.green;
//                      Device.lights_card_info_list[index].active_or_not_color = Colors.green[200];
////                            icon_color = Colors.green;
////                            icon = Icon(Icons.verified_user);
//                    }
//                    else if (Device.lights_card_info_list[index].checkbox_val == false)
//                    {
//                      Device.lights_card_info_list[index].checkbox_val = true;
//                      Device.lights_card_info_list[index].icon = Icon(Icons.add_circle);
//                      Device.lights_card_info_list[index].icon_color = Colors.white;
//                      Device.lights_card_info_list[index].active_or_not_color = Colors.white70;
////                          icon_color =
////                          icon = ;
//                    }
//
//                  });
//
//                },
//              ),
////                  Checkbox(
////                    tristate: true,
////
////                        value: isChecked,//lights_list[index].checkbox_val,//itemRow.checkbox_val,
////                    onChanged: (bool val){
////                          setState(() {
////                            isChecked = val;
////                            //State.//isChecked = val;
////                            //lights_list[index].checkbox_val = val;
////                          });
////
////
////                        },
////                      ),
//
//              Text(Device.lights_card_info_list[index].name)
//
//
//
//
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              FlatButton(
//                color: Colors.green,
//                disabledColor: Colors.green,
//                textColor: Colors.white,
//                child: Text("Start time",style: TextStyle(color: Colors.white),),
//                onPressed: (){
//
//                  _selectTime(context,"start",index);
//                },
//              ),
//              Center(
//                child: Device.lights_card_info_list[index].str_selectedStartTime != "" ? Text(Device.lights_card_info_list[index].str_selectedStartTime) : Text("select start time"),
//              )
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              FlatButton(
//                color: Colors.redAccent,
//                disabledColor: Colors.redAccent,
//                textColor: Colors.white,
//                child: Text("End time",style: TextStyle(color: Colors.white),),
//                onPressed: (){
//                  _selectTime(context,"end",index);
//                },
//              ),
////                  RaisedButton(
////                    child: Text("End time"),
////                  ),
//              Center(
//                child: Device.lights_card_info_list[index].str_selectedEndTime != "" ? Text(Device.lights_card_info_list[index].str_selectedEndTime) : Text("select end time"),
//              )
//            ],
//          )
//
//
//
//
//        ],
//      ),
//    );
//     //   return null;
//  }
}
//class _SettingSectionState extends State<SettingSection> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//
//    );
//  }
//
//}