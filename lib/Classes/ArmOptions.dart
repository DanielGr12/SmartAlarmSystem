import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp_alarm_system/Classes/DevicesCommands.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Classes/log.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';

class show_more_lights extends StatefulWidget {

  List<AllLights> lights_cards_info = new List<AllLights>();

  show_more_lights(this.lights_cards_info);

  @override
  _show_more_lightsState createState() => _show_more_lightsState();
}
class _show_more_lightsState extends State<show_more_lights> {
  TimeOfDay selectedStartTime;
  TimeOfDay selectedEndTime;
  TimeOfDay selectedTime = TimeOfDay.now();
  String str_selectedStartTime = "";
  String str_selectedEndTime = "";
  static List<RandomLight> TurnOnLightList = new List<RandomLight>();
  static String random_time = "1 hour";
  Color more_lights_color = Colors.black;

  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  static String bypass_mode = "";
  final Color back_color = _colorFromHex("f7f7f7");

  List<SettingParameter> arm_options = [
    SettingParameter("Bypass",bypass_mode,Colors.white,false),
    SettingParameter("Randomly light","",Colors.white,false),
    SettingParameter("Device low battery",GlobalParameters.selected_low_battery_percent,Colors.white,false),
  ];
  @override
  Widget build(BuildContext context) {
    if (GlobalParameters.bypass_or_not == true)
    {
      setState(() {
        bypass_mode = "Enable";
      });
    }
    else
    {
      setState(() {
        bypass_mode = "Disable";
      });
    }
    arm_options = [
      SettingParameter("Bypass",bypass_mode,Colors.white,false),
      SettingParameter("Randomly light","",Colors.white,false),
      SettingParameter("Device low battery",GlobalParameters.selected_low_battery_percent,Colors.white,false),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Arm options"),
      ),
      body: Column(
        children: <Widget>[
          SettingSection(options: arm_options)
        ],
      ),
    );
//    return Scaffold(
//        backgroundColor: back_color,
//        appBar: AppBar(
//          title: Text("Random light options"),
//        ),
//        body:
//        Column(
//          children: <Widget>[
//            Card(
//              child: SwitchListTile(
//                title: const Text('Random light',
//                    style: TextStyle(
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.bold,
//                    )
//                ),
//                subtitle: const Text('turn on light every selected time',
//                    style: TextStyle(
//                      fontSize: 15.0,
//                    )
//                ),
//                value: GlobalParameters.TurnOnLightSelectedLocation_or_not,
//                onChanged: (value) {
//                  setState(() {
//                    if (value == false)
//                    {
//                      more_lights_color = Colors.black;
//                    }
//                    else if (value == true)
//                    {
//                      more_lights_color = Colors.blueAccent;
//                    }
//                    GlobalParameters.TurnOnLightSelectedLocation_or_not = value;
////            _controller = ScrollController();
////            _controller.animateTo(pixelsToMove,
////                curve: Curves.linear, duration: Duration (milliseconds: 500));
////            _controller.animateTo(_controller.offset + itemSize,
////                curve: Curves.linear, duration: Duration(milliseconds: 500));
//                  });
//                },
//                dense: true,
//                selected: GlobalParameters.TurnOnLightSelectedLocation_or_not,
//                activeTrackColor: Colors.blue[200],
//                activeColor: Colors.blueAccent,
//                inactiveThumbColor: Colors.white,
//                inactiveTrackColor: Colors.black,
//
//                //                  secondary: const Icon(Icons.lightbulb_outline),
//              ),
//            ),
////          Card(
////            child: ListTile(
////                title: Row(
////                  mainAxisAlignment: MainAxisAlignment.start,
////                  children: <Widget>[
////                    Text("Lights options"),
////                    Spacer(),
////                    Text(_show_more_lightsState.random_time),
////
////                  ],
////                ),
////                trailing: IconButton(
////                  icon: Row(
////                    mainAxisAlignment: MainAxisAlignment.start,
////                    children: <Widget>[
////                      Icon(Icons.navigate_next),
////                    ],
////                  ),
////                  onPressed: () {
////                    if (GlobalParameters.TurnOnLightSelectedLocation_or_not == true)
////                    {
////                      Navigator.push(
////                        context,
////                        MaterialPageRoute(builder: (context) =>
////                            show_more_lights(Device.lights_card_info_list)),
////                      );
////                    }
////                  },
////                )
////
////
////
////            ),
////          )
//            GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? Card(
//                child: ListTile(
//                    title: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Text("Lights options"),
//                        Spacer(),
//                        Text(GlobalParameters.selected_range_time),
//
//                      ],
//                    ),
//                    trailing: IconButton(
//                      icon: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Icon(Icons.navigate_next),
//                        ],
//                      ),
//                      onPressed: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => choose_light_random_time()),
//                        );
//                      },
//                    )
//
//
//
//                )
//            ): SizedBox.shrink(),
////          Card(
////            child: Row(
////              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////              children: <Widget>[
////                IconButton(
////                  icon: Icon(Icons.keyboard_arrow_down),
////                  onPressed: (){
////                    setState(() {
////                      if (random_time == "2 hours")
////                      {
////                        random_time = "1 hour";
////                      }
////                      else if (random_time == "1 hour")
////                      {
////                        random_time = "30 minutes";
////                      }
////                    });
////
////                  },
////                ),
////
////                Text(random_time,style: TextStyle(
////                  fontSize: 20,
////                ),),
////                IconButton(
////                  icon: Icon(Icons.keyboard_arrow_up),
////                  onPressed: (){
////                    setState(() {
////                      if (random_time == "1 hour")
////                      {
////                        random_time = "2 hours";
////                      }
////                      else if (random_time == "30 minutes")
////                      {
////                        random_time = "1 hour";
////                      }
////                    });
////                  },
////                ),
////              ],
////            ),
////          ),
//            GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? Container(
//              child: ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  itemCount: Device.lights_card_info_list.length,
//                  itemBuilder: (BuildContext context, int index) =>
//                      buildCard(context, index)),
//            ): SizedBox.shrink(),
//          ],
//        )
//    );
//      Container(
//      child: ListView.builder(
//          scrollDirection: Axis.vertical,
//          shrinkWrap: true,
//          itemCount: Device.lights_card_info_list.length,
//          itemBuilder: (BuildContext context, int index) =>
//              buildCard(context, index)),
//    );

    return null;
  }
  Widget buildCard(BuildContext context, int index)
  {

    return Card(
      color: Device.lights_card_info_list[index].active_or_not_color,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
//                  ListTile(
//                    title: Text(
//                      pair.asPascalCase,
//                      style: _biggerFont,
//                    ),
//                    trailing: Icon(
//                      alreadySaved ? Icons.favorite : Icons.favorite_border,
//                      color: alreadySaved ? Colors.red : null,
//                    ),
//                    onTap: () {      // Add 9 lines from here...
//                      setState(() {
//                        if (alreadySaved) {
//                          _saved.remove(pair);
//                        } else {
//                          _saved.add(pair);
//                        }
//                      });
//                    },               // ... to here.
//                  ),
              IconButton(
                icon: Device.lights_card_info_list[index].icon,//is_added == false ? Icon(Icons.add) : Icon(Icons.verified_user),
                color: Device.lights_card_info_list[index].icon_color,
                onPressed: (){
                  setState(() {
                    if (Device.lights_card_info_list[index].checkbox_val == true)
                    {
                      Device.lights_card_info_list[index].checkbox_val = false;
                      Device.lights_card_info_list[index].icon = Icon(Icons.verified_user);
                      Device.lights_card_info_list[index].icon_color = Colors.green;
                      Device.lights_card_info_list[index].active_or_not_color = Colors.green[200];
//                            icon_color = Colors.green;
//                            icon = Icon(Icons.verified_user);
                    }
                    else if (Device.lights_card_info_list[index].checkbox_val == false)
                    {
                      Device.lights_card_info_list[index].checkbox_val = true;
                      Device.lights_card_info_list[index].icon = Icon(Icons.add_circle);
                      Device.lights_card_info_list[index].icon_color = Colors.white;
                      Device.lights_card_info_list[index].active_or_not_color = Colors.white70;
//                          icon_color =
//                          icon = ;
                    }

                  });

                },
              ),
//                  Checkbox(
//                    tristate: true,
//
//                        value: isChecked,//lights_list[index].checkbox_val,//itemRow.checkbox_val,
//                    onChanged: (bool val){
//                          setState(() {
//                            isChecked = val;
//                            //State.//isChecked = val;
//                            //lights_list[index].checkbox_val = val;
//                          });
//
//
//                        },
//                      ),

              Text(Device.lights_card_info_list[index].name)




            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                color: Colors.green,
                disabledColor: Colors.green,
                textColor: Colors.white,
                child: Text("Start time",style: TextStyle(color: Colors.white),),
                onPressed: (){

                  _selectTime(context,"start",index);
                },
              ),
              Center(
                child: Device.lights_card_info_list[index].str_selectedStartTime != "" ? Text(Device.lights_card_info_list[index].str_selectedStartTime) : Text("select start time"),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                color: Colors.redAccent,
                disabledColor: Colors.redAccent,
                textColor: Colors.white,
                child: Text("End time",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  _selectTime(context,"end",index);
                },
              ),
//                  RaisedButton(
//                    child: Text("End time"),
//                  ),
              Center(
                child: Device.lights_card_info_list[index].str_selectedEndTime != "" ? Text(Device.lights_card_info_list[index].str_selectedEndTime) : Text("select end time"),
              )
            ],
          )




        ],
      ),
    );
    //   return null;
  }
  static void light_or_turn_off_timer() {
    TimeOfDay current_time = TimeOfDay.now();
    TurnOnLightList.clear();
    for (int i = 0; i < Device.lights_card_info_list.length;i ++)
    {
      if (Device.lights_card_info_list[i].checkbox_val == true)
      {
        List<String> splitted_start_time = Device.lights_card_info_list[i].str_selectedStartTime.split(':');
        TimeOfDay start_time = new TimeOfDay(hour: int.parse(splitted_start_time[0]), minute: int.parse(splitted_start_time[1]));
        List<String> splitted_end_time = Device.lights_card_info_list[i].str_selectedEndTime.split(':');
        TimeOfDay end_time = new TimeOfDay(hour: int.parse(splitted_end_time[0]), minute: int.parse(splitted_end_time[1]));

        TurnOnLightList.add(RandomLight(Device.lights_card_info_list[i].name,start_time,end_time,Device.lights_card_info_list[i].id));
      }
    }
    //TimeOfDay t;
//    for (int i = 0;i < TurnOnLightList.length;i ++)
////    {

//      DateTime start = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].start_time.hour, TurnOnLightList[i].start_time.minute);
//      DateTime end = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].end_time.hour, TurnOnLightList[i].end_time.minute);

    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = new DateTime.now();

      for (int i = 0;i < TurnOnLightList.length;i ++)
      {

        //DateTime now = new DateTime.now();
        DateTime start = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].start_time.hour, TurnOnLightList[i].start_time.minute);
        DateTime end = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].end_time.hour, TurnOnLightList[i].end_time.minute);
        if (now.hour >= start.hour)// && (now.hour <= end.hour) && (now.minute >= start.minute))
            {
          if (now.hour <= end.hour)
          {
            if (now.minute >= start.minute)
            {
              if ((now.hour == start.hour) && (now.minute == start.minute))
              {
                if (TurnOnLightList[i].turn_on_first_time == true)
                {
                  print("turn on the light");
                  DevicesCommands.switch_light_command(TurnOnLightList[i].device_id, "on");
                  TurnOnLightList[i].turn_on_first_time = false;
                }

              }
              if ((now.hour == end.hour) && (now.minute == end.minute))
              {
                if (TurnOnLightList[i].turn_off_first_time == true)
                {
                  print("turn off the light");
                  DevicesCommands.switch_light_command(TurnOnLightList[i].device_id, "off");
                  TurnOnLightList[i].turn_off_first_time = false;
                }


                //timer.cancel();
              }
            }
          }
          //if ()

//            else
//            {
//              print(DateTime.now());
//            }
          //if ((now.minute >= start.minute) && (now.minute <= end.minute))

        }
      }


    });
    //}

  }
  Future<String> _selectTime(BuildContext context, String action,int index) async {
//    TimeOfDay selectedTime;
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );});

    if (picked_s != null && picked_s != selectedTime )
      setState(() {
        if (action == "start")
        {
          selectedStartTime = picked_s;
          //str_selected_start_time = "${selectedStartTime.hour}:${selectedStartTime.minute}";
          str_selectedStartTime = "${selectedStartTime.hour}:${selectedStartTime.minute}";
          Device.lights_card_info_list[index].str_selectedStartTime = str_selectedStartTime;
          //return str_selectedStartTime;
        }

        else if (action == "end")
        {
          selectedEndTime = picked_s;
          //TurnOnLightList.add(RandomLight(GlobalParameters.SelectedLightBulb,selectedStartTime,selectedEndTime,true,str_selectedStartTime,str_selectedEndTime));
          str_selectedEndTime = "${selectedEndTime.hour}:${selectedEndTime.minute}";
          Device.lights_card_info_list[index].str_selectedEndTime = str_selectedEndTime;
          //str_selected_end_time = "${selectedEndTime.hour}:${selectedEndTime.minute}";
          light_or_turn_off_timer();
          //return str_selectedEndTime;
          //            var map = {time_to_enter: }
//            GlobalParameters.TurnOnLightList.update(time_to_enter, selectedStartTime , selectedStartTime);
//            GlobalParameters.TurnOnLightList[time_to_enter] = ;
//            selectedEndTime = picked_s;
//            if (selectedStartTime != null)
//            {
//              double _doubleyourTime = selectedStartTime.hour.toDouble() +
//                  (selectedStartTime.minute.toDouble() / 60);
//              double _doubleNowTime = selectedEndTime.hour.toDouble() +
//                  (selectedEndTime.minute.toDouble() / 60);
//              Timer.periodic(Duration(seconds: 5), (timer) {
          print(DateTime.now());
//              });

        }
        selectedTime = picked_s;
        //return "";

      });
  }
}

//class choose_light_random_time extends StatefulWidget {
//
//  //List<AllLights> lights_cards_info = new List<AllLights>();
//
//  choose_light_random_time();
//
//  @override
//  _choose_light_random_time_optionsState createState() => _choose_light_random_time_optionsState();
//}
//class _choose_light_random_time_optionsState extends State<choose_light_random_time> {
//
//  List<SelectOptions> _options = [
//    SelectOptions("30 minutes",false),
//    SelectOptions("1 hour",false),
//    SelectOptions("2 hours",false),
//  ];
//  //options.add(SelectOptions("30 minutes",false));
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: new AppBar(
//        title: Text("Select light time"),
//      ),
//      body: SelectFromOptions(
//        explanation: "select the time that every light bulb will stay on randomly several times between the times that you chose",
//        default_val: GlobalParameters.selected_range_time,
//        options: _options,
//        returned_val: (String val) {
//          GlobalParameters.selected_range_time = val;
//        },
//      ),//SelectFromOptions(_options),
////      body: Column(
////        children: <Widget>[
////          ListTile(
////            title: Text("30 minutes"),
////            trailing: GlobalParameters.light_selected_30_min == true ? Icon(Icons.check,color: Colors.blue[700]):null,
////            onTap: (){
////              setState(() {
////                _show_more_lightsState.random_time = "30 minutes";
////                GlobalParameters.light_selected_30_min = true;
////                GlobalParameters.light_selected_1_hour = false;
////                GlobalParameters.light_selected_2_hours = false;
////              });
////
////            },
////          ),
////          Divider(thickness: 1.5),
////          ListTile(
////            title: Text("1 hour"),
////            trailing: GlobalParameters.light_selected_1_hour == true ? Icon(Icons.check,color: Colors.blue[700]):null,
////            onTap: (){
////              setState(() {
////                _show_more_lightsState.random_time = "1 hour";
////                GlobalParameters.light_selected_1_hour = true;
////                GlobalParameters.light_selected_2_hours = false;
////                GlobalParameters.light_selected_30_min = false;
////              });
////
////            },
////          ),
////          Divider(thickness: 1.5),
////          ListTile(
////            title: Text("2 hours"),
////            trailing: GlobalParameters.light_selected_2_hours == true ? Icon(Icons.check,color: Colors.blue[700]):null,
////            onTap: (){
////              setState(() {
////                _show_more_lightsState.random_time = "2 hours";
////                GlobalParameters.light_selected_2_hours = true;
////                GlobalParameters.light_selected_1_hour = false;
////                GlobalParameters.light_selected_30_min = false;
////              });
////
////            },
////          ),
////        ],
////      ),
//      //body: ,
//    );
//  }
//
//}