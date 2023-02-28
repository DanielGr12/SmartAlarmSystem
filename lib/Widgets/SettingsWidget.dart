import 'dart:async';
import 'SettingSection.dart';
import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Widgets/DevicesWidget.dart';
import 'package:tcp_alarm_system/Widgets/SelectFromOptions.dart';
import 'ComboBoxParameter.dart';
import '../Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Classes/DevicesCommands.dart';

class SettingsWidget extends StatefulWidget
{
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}
Color _colorFromHex(String hexColor) {
final hexCode = hexColor.replaceAll('#', '');
return Color(int.parse('FF$hexCode', radix: 16));
}
Color back_color = _colorFromHex("f7f7f7");
class _SettingsWidgetState extends State<SettingsWidget> {
  List<String> _locations = [
    "Disable",
    '5 sec',
    '15 sec',
    '30 sec',
    '45 sec'
  ];
  List<String> _chime_options = [
    "Disable",
    'Ding dong',
    'Happy beep',
    'Door opened'
  ];
  List<String> _siren_options = [
    "15 sec",
    '30 sec',
    '1 min',
    '8 min'
  ];
  List<String> _light_options = [
    "every 5 min",
    'every 15 min',
    'every 30 min',
    'every 60 min'
  ];
  bool is_selected_light = false;
  bool is_selected_time = false;
  TimeOfDay selectedStartTime;
  TimeOfDay selectedEndTime;
  TimeOfDay selectedTime = TimeOfDay.now();
  static List<RandomLight> TurnOnLightList = new List<RandomLight>();
  static List<String> LightsId = Device.lights_id_list();
  String str_selectedStartTime = "";
  String str_selectedEndTime = "";
  Color more_lights_color = Colors.black;
  List<SettingParameter> settings_parameters = [
    SettingParameter("Sounds","",Colors.white,true,Icon(Icons.volume_up,color: Colors.blueAccent)),
    SettingParameter("Delays","",Colors.white,true,Icon(Icons.timer,color: Colors.blueAccent)),
    SettingParameter("Privacy","",Colors.white,true,Icon(Icons.person,color: Colors.blueAccent)),
    SettingParameter("Arm options","",Colors.white,true,Icon(Icons.lock,color: Colors.blueAccent)),
    SettingParameter("Device/Zone options","",Colors.white,true,Icon(Icons.settings,color: Colors.blueAccent)),
    SettingParameter("Trouble","",Colors.white,true,Icon(Icons.warning,color: Colors.redAccent)),
    SettingParameter("Trouble settings","",Colors.white,true,Icon(Icons.settings,color: Colors.redAccent)),
  ];
//  String _entrySelectedLocation;
//
//  String _exitSelectedLocation;
//  String _chimeSelectedLocation;

//  int current_delay_time = 0;

  //int secondsPassed = 0;

  //String splitted_time;
  //String user_default_code = "1111";
  //ScrollController _scrollController = new ScrollController();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {

    return
      Container(
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
                  padding: EdgeInsets.only(left:10),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Settings",style: TextStyle(
                          fontSize: 30
                      ),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:10),
                ),
                SettingSection(options: settings_parameters),
//              SettingSection.SettingSec(context, "Sounds", ""),
//              SettingSection.SettingSec(context, "Delays", ""),
//              SettingSection.SettingSec(context, "Privacy", ""),
//              SettingSection.SettingSec(context, "Arm options", ""),
//              section_title("Sounds"),
//
//              ComboBoxCard(_chime_options,"Chime",'Do a sound when contact open',"GlobalParameters.chimeSelectedLocation",Icon(Icons.audiotrack),"Disable"),

//              new Padding(padding: new EdgeInsets.all(10.00)),
//
//              section_title("Delays"),
//              ComboBoxCard(_locations,'Exit delay time','Time the system waits until arm',"GlobalParameters.exitSelectedLocation",Icon(Icons.timelapse),0),
//              //new Padding(padding: new EdgeInsets.all(5.00)),
//              ComboBoxCard(_locations,'Entry delay time','Time the system waits until the alarm',"GlobalParameters.entrySelectedLocation",Icon(Icons.timelapse),0),
//              //delays(_locations,'Exit delay time','Time the system waits until arm'),
//              ComboBoxCard(_siren_options,"Siren time",'Time the system does an alarm',"GlobalParameters.sirenSelectedLocation",Icon(Icons.timelapse),"15 sec"),
//
//              new Padding(padding: new EdgeInsets.all(10.00)),
//              section_title("Codes"),
//              default_code(),
//
//              section_title("Arm options"),
//              by_pass(),
                //randomly_light(),
                //lights_datatable(),
//              Card(
//                  color: Colors.white70,
//
//                  //color: Colors.transparent.value,
//                  child: Column(
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          Checkbox(
//                            value: true,//itemRow.checkbox_val,
//                            onChanged: (val){
//                              setState(() {
////                        itemRow.checkbox_val = val;
//                              });
//                            },
//                          ),
//                          Center(
//                            child: Text(""),
//                          ),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          RaisedButton(
//                            child: Text("Start time"),
//                          ),
//                          Center(
//                            child: Text("selected start time"),
//                          )
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          RaisedButton(
//                            child: Text("End time"),
//                          ),
//                          Center(
//                            child: Text("selected end time"),
//                          )
//                        ],
//                      )
//
//
//
//
//                    ],
//                  )),

//              select_light(),
//              select_light_time(),
                 //GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? ComboBoxCard(Device.lights_list(),"Which light",'Select the light that you want',"GlobalParameters.TurnOnLightSelectedLocation",Icon(Icons.lightbulb_outline),"Select"): SizedBox.shrink(),
////              if (GlobalParameters.TurnOnLightSelectedLocation_or_not == true)
//
//
//
////                List<String> = DevicesWidget.lights_list();
//              is_selected_light == true ? Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    RaisedButton(
//                      child: Text("Select start time"),
//                      onPressed: (){
//                        _selectTime(context,"start");
//                      },
//                    ),
//                    RaisedButton(
//                      child: Text("Select end time"),
//                      onPressed: (){
//                        _selectTime(context, "end");
//                      },
//                    ),
//                  ],
//                ),
//              ) : null
//              if (is_selected_light == true)


//                Card(
//                  color: Colors.white70,
//                  child: ListTile(
//                    title: RaisedButton(
//                      child: Text("Select time"),
//                      onPressed: (){
//                        _selectTime(context);
//                      },
//                    ),
//                    leading: Icon(Icons.access_time),
//                  ),
//                )
                  //_pickTime(),


                  //ComboBoxCard(_selectTime(context),"Turn on light",'The light that you choose will be turned on randomly',"GlobalParameters.SelectedTime",Icon(Icons.lightbulb_outline),"Disable"),

//              if (is_selected_time == true)
//                _selectTime(context);
                //parameterExplanation('The code to the system'),
                //new Padding(padding: new EdgeInsets.all(10.00)),
              ],
            ),

    ),
        ),
      );
  }
//  Widget lights_datatable()
//  {
//    //lights();
//    if (GlobalParameters.TurnOnLightSelectedLocation_or_not == true)
//    {
//      //List<String> a = Device.lights_labels_list();
//      return Container(
//        child: ListView.builder(
//            scrollDirection: Axis.vertical,
//            shrinkWrap: true,
//              itemCount: Device.lights_card_info_list.length,
//              itemBuilder: (BuildContext context, int index) =>
//                  buildCard(context, index)),
//      );
//    }
//    return SizedBox.shrink();
//  }
//  Widget buildCard(BuildContext context, int index) {
//    //https://stackoverflow.com/questions/58115148/how-to-change-height-of-a-card-in-flutter
//    List<String> labels = Device.lights_labels_list();
//    String label = labels[index];
//    bool isChecked = false;
//    //Color icon_color = Colors.grey[400];
//    //Icon icon = Icon(Icons.add);
//    bool is_added = false;
//    String startTime = Device.lights_card_info_list[index].str_selectedStartTime;
//    //Future<String> start_time = lights_list[index].str_selectedStartTime as Future<String>;
//    //final alreadySaved = _saved.contains(pair);
//    return
//
//      Card(
//          color: Device.lights_card_info_list[index].active_or_not_color,//Colors.white70,
//
//          //color: Colors.transparent.value,
//          child: Column(
//            children: <Widget>[
//              Row(
//                children: <Widget>[
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
//                  IconButton(
//                    icon: Device.lights_card_info_list[index].icon,//is_added == false ? Icon(Icons.add) : Icon(Icons.verified_user),
//                    color: Device.lights_card_info_list[index].icon_color,
//                    onPressed: (){
//                      setState(() {
//                        if (Device.lights_card_info_list[index].checkbox_val == true)
//                          {
//                            Device.lights_card_info_list[index].checkbox_val = false;
//                            Device.lights_card_info_list[index].icon = Icon(Icons.verified_user);
//                            Device.lights_card_info_list[index].icon_color = Colors.green;
//                            Device.lights_card_info_list[index].active_or_not_color = Colors.green[200];
////                            icon_color = Colors.green;
////                            icon = Icon(Icons.verified_user);
//                          }
//                        else if (Device.lights_card_info_list[index].checkbox_val == false)
//                        {
//                          Device.lights_card_info_list[index].checkbox_val = true;
//                          Device.lights_card_info_list[index].icon = Icon(Icons.add_circle);
//                          Device.lights_card_info_list[index].icon_color = Colors.grey;
//                          Device.lights_card_info_list[index].active_or_not_color = Colors.white70;
////                          icon_color =
////                          icon = ;
//                        }
//
//                      });
//
//                    },
//                  ),
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
//                  Text(Device.lights_card_info_list[index].name)
//
//
//
//
//                ],
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  FlatButton(
//                    color: Colors.green,
//                    disabledColor: Colors.green,
//                    textColor: Colors.white,
//                    child: Text("Start time",style: TextStyle(color: Colors.white),),
//                      onPressed: (){
//
//                        _selectTime(context,"start",index);
//                      },
//                  ),
//                  Center(
//                    child: Device.lights_card_info_list[index].str_selectedStartTime != "" ? Text(Device.lights_card_info_list[index].str_selectedStartTime) : Text("select start time"),
//                  )
//                ],
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  FlatButton(
//                    color: Colors.redAccent,
//                    disabledColor: Colors.redAccent,
//                    textColor: Colors.white,
//                    child: Text("End time",style: TextStyle(color: Colors.white),),
//                    onPressed: (){
//                      _selectTime(context,"end",index);
//                    },
//                  ),
////                  RaisedButton(
////                    child: Text("End time"),
////                  ),
//                  Center(
//                    child: Device.lights_card_info_list[index].str_selectedEndTime != "" ? Text(Device.lights_card_info_list[index].str_selectedEndTime) : Text("select end time"),
//                  )
//                ],
//              )
//
//
//
//
//            ],
//          ));
//    // );
//  }

  Widget select_light()
  {
    if (GlobalParameters.TurnOnLightSelectedLocation_or_not == true)
      {

        return ComboBoxCard(Device.lights_labels_list(),"Which light",'Select the light that you want',"GlobalParameters.TurnOnLightSelectedLocation",Icon(Icons.lightbulb_outline),"Select");
      }
     return SizedBox.shrink();
  }
  void lights()
  {
//    Device.lights_card_info_list.clear();
//    List<String> labels_list = Device.lights_labels_list();
//    List<String> id_list = Device.lights_id_list();
//    for (int i = 0;i < labels_list.length;i ++)
//    {
//      Device.lights_card_info_list.add(AllLights(labels_list[i],"","",false,id_list[i]));//name: labels_list[i],"","",false
//    }
  }
//  Widget select_light_time()
//  {
//    if (is_selected_light == true)
//    {
//      return Container(
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
//          children: <Widget>[
//            RaisedButton(
//              child: Column(
//                children: <Widget>[
//                  Text("Select start time"),
//                  str_selectedStartTime != "" ? Center(
//                      child: Text(str_selectedStartTime),
//                  ) : SizedBox.shrink(),
//                ],
//              ),
//              onPressed: (){
//                _selectTime(context,"start");
//              },
//            ),
//            RaisedButton(
//              child: Column(
//                children: <Widget>[
//                  Text("Select end time"),
//                   str_selectedEndTime != "" ? Center(
//                    child: Text(str_selectedEndTime),
//                  ) : SizedBox.shrink(),
//                ],
//              ),
//              //Text("Select end time"),
//              onPressed: (){
//                _selectTime(context, "end");
//              },
//            ),
//          ],
//        ),
//      );
//    }
//    return SizedBox.shrink();
//  }
  DateTime pickedDate;
  TimeOfDay time;
  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedDate,
    );
    if(date != null)
      setState(() {
        pickedDate = date;
      });
  }

//  Future<String> _selectTime(BuildContext context, String action,int index) async {
////    TimeOfDay selectedTime;
//    final TimeOfDay picked_s = await showTimePicker(
//        context: context,
//        initialTime: selectedTime, builder: (BuildContext context, Widget child) {
//      return MediaQuery(
//        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//        child: child,
//      );});
//
//    if (picked_s != null && picked_s != selectedTime )
//      setState(() {
//        if (action == "start")
//          {
//            selectedStartTime = picked_s;
//            //str_selected_start_time = "${selectedStartTime.hour}:${selectedStartTime.minute}";
//            str_selectedStartTime = "${selectedStartTime.hour}:${selectedStartTime.minute}";
//            Device.lights_card_info_list[index].str_selectedStartTime = str_selectedStartTime;
//            //return str_selectedStartTime;
//          }
//
//        else if (action == "end")
//          {
//            selectedEndTime = picked_s;
//            //TurnOnLightList.add(RandomLight(GlobalParameters.SelectedLightBulb,selectedStartTime,selectedEndTime,true,str_selectedStartTime,str_selectedEndTime));
//            str_selectedEndTime = "${selectedEndTime.hour}:${selectedEndTime.minute}";
//            Device.lights_card_info_list[index].str_selectedEndTime = str_selectedEndTime;
//            //str_selected_end_time = "${selectedEndTime.hour}:${selectedEndTime.minute}";
//            light_or_turn_off_timer();
//            //return str_selectedEndTime;
//            //            var map = {time_to_enter: }
////            GlobalParameters.TurnOnLightList.update(time_to_enter, selectedStartTime , selectedStartTime);
////            GlobalParameters.TurnOnLightList[time_to_enter] = ;
////            selectedEndTime = picked_s;
////            if (selectedStartTime != null)
////            {
////              double _doubleyourTime = selectedStartTime.hour.toDouble() +
////                  (selectedStartTime.minute.toDouble() / 60);
////              double _doubleNowTime = selectedEndTime.hour.toDouble() +
////                  (selectedEndTime.minute.toDouble() / 60);
////              Timer.periodic(Duration(seconds: 5), (timer) {
//                print(DateTime.now());
////              });
//
//            }
//        selectedTime = picked_s;
//        //return "";
//
//      });
//  }
//  Widget _pickTime() async {
//    return showTimePicker(context: context, initialTime: time);
////
////    TimeOfDay t = await showTimePicker(
////        context: context,
////        initialTime: time
////    );
////    if(t != null)
////      setState(() {
////        time = t;
////      });
////    return t;
//  }

//  static void light_or_turn_off_timer() {
//    TimeOfDay current_time = TimeOfDay.now();
//    TurnOnLightList.clear();
//    for (int i = 0; i < Device.lights_card_info_list.length;i ++)
//    {
//      if (Device.lights_card_info_list[i].checkbox_val == true)
//      {
//        List<String> splitted_start_time = Device.lights_card_info_list[i].str_selectedStartTime.split(':');
//        TimeOfDay start_time = new TimeOfDay(hour: int.parse(splitted_start_time[0]), minute: int.parse(splitted_start_time[1]));
//        List<String> splitted_end_time = Device.lights_card_info_list[i].str_selectedEndTime.split(':');
//        TimeOfDay end_time = new TimeOfDay(hour: int.parse(splitted_end_time[0]), minute: int.parse(splitted_end_time[1]));
//
//        TurnOnLightList.add(RandomLight(Device.lights_card_info_list[i].name,start_time,end_time,Device.lights_card_info_list[i].id));
//      }
//    }
//    //TimeOfDay t;
////    for (int i = 0;i < TurnOnLightList.length;i ++)
//////    {
//
////      DateTime start = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].start_time.hour, TurnOnLightList[i].start_time.minute);
////      DateTime end = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].end_time.hour, TurnOnLightList[i].end_time.minute);
//
//    Timer.periodic(Duration(seconds: 1), (timer) {
//      DateTime now = new DateTime.now();
//
//      for (int i = 0;i < TurnOnLightList.length;i ++)
//      {
//
//        //DateTime now = new DateTime.now();
//        DateTime start = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].start_time.hour, TurnOnLightList[i].start_time.minute);
//        DateTime end = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].end_time.hour, TurnOnLightList[i].end_time.minute);
//        if (now.hour >= start.hour)// && (now.hour <= end.hour) && (now.minute >= start.minute))
//            {
//          if (now.hour <= end.hour)
//          {
//            if (now.minute >= start.minute)
//            {
//              if ((now.hour == start.hour) && (now.minute == start.minute))
//              {
//                if (TurnOnLightList[i].turn_on_first_time == true)
//                {
//                  print("turn on the light");
//                  DevicesCommands.switch_light_command(TurnOnLightList[i].device_id, "on");
//                  TurnOnLightList[i].turn_on_first_time = false;
//                }
//
//              }
//              if ((now.hour == end.hour) && (now.minute == end.minute))
//              {
//                if (TurnOnLightList[i].turn_off_first_time == true)
//                {
//                  print("turn off the light");
//                  DevicesCommands.switch_light_command(TurnOnLightList[i].device_id, "off");
//                  TurnOnLightList[i].turn_off_first_time = false;
//                }
//
//
//                //timer.cancel();
//              }
//            }
//          }
//          //if ()
//
////            else
////            {
////              print(DateTime.now());
////            }
//          //if ((now.minute >= start.minute) && (now.minute <= end.minute))
//
//        }
//      }
//
//
//    });
//    //}
//
//  }
  Widget time_picker()
  {

  }
  Widget randomly_light()
  {
    //return SettingSection.SettingSec(context,"Random light","");




//    return Card(
//      color: Colors.white60,
//      child: Column(
//        children: <Widget>[
//          ListTile(
//            title: Text("Random light",style: TextStyle(
//              fontSize: 19,
//              fontWeight: FontWeight.bold
//            ),),
//            trailing: IconButton(
//              icon: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  Icon(Icons.navigate_next,color: more_lights_color),
//                ],
//              ),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) =>
//                      show_more_lights(Device.lights_card_info_list)),
//                );
//              },
//            ),
//          ),
////          SwitchListTile(
////            title: const Text('Random light',
////                style: TextStyle(
////                  fontSize: 20.0,
////                  fontWeight: FontWeight.bold,
////                )
////            ),
////            subtitle: const Text('turn on light every selected time',
////                style: TextStyle(
////                  fontSize: 15.0,
////                )
////            ),
////            value: GlobalParameters.TurnOnLightSelectedLocation_or_not,
////            onChanged: (value) {
////              setState(() {
////                if (value == false)
////                  {
////                    more_lights_color = Colors.black;
////                  }
////                else if (value == true)
////                {
////                  more_lights_color = Colors.blueAccent;
////                }
////                GlobalParameters.TurnOnLightSelectedLocation_or_not = value;
//////            _controller = ScrollController();
//////            _controller.animateTo(pixelsToMove,
//////                curve: Curves.linear, duration: Duration (milliseconds: 500));
//////            _controller.animateTo(_controller.offset + itemSize,
//////                curve: Curves.linear, duration: Duration(milliseconds: 500));
////              });
////            },
////            dense: true,
////            selected: GlobalParameters.TurnOnLightSelectedLocation_or_not,
////            activeTrackColor: Colors.blue[200],
////            activeColor: Colors.blueAccent,
////            inactiveThumbColor: Colors.white,
////            inactiveTrackColor: Colors.black,
////
////            //                  secondary: const Icon(Icons.lightbulb_outline),
////          ),
////          ListTile(
////              title: Row(
////                mainAxisAlignment: MainAxisAlignment.start,
////                children: <Widget>[
////                  Text("Lights options"),
////                  Spacer(),
////                  //Text(_show_more_lightsState.random_time),
////
////                ],
////              ),
////              trailing: IconButton(
////                icon: Row(
////                  mainAxisAlignment: MainAxisAlignment.start,
////                  children: <Widget>[
////                    Icon(Icons.navigate_next,color: more_lights_color),
////                  ],
////                ),
////                onPressed: () {
////                  if (GlobalParameters.TurnOnLightSelectedLocation_or_not == true)
////                  {
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(builder: (context) =>
////                          show_more_lights(Device.lights_card_info_list)),
////                    );
////                  }
////                },
////              )
////
////
////
////          )
//
//        ],
//      ),
//    );
  }
  Widget by_pass()
  {
    return Card(
      color: Colors.white60,
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
    );
  }
  Widget section_title(String title)
  {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //Align(
          //alignment: Alignment(1.0,1.0),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(

              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent
              ),
            ),
          ),


      ],
    );

  }

  Widget ComboBoxCard(List<String> options, String parameter_text,String parameterExplanation, String value_to_update, Icon icon,var default_selected)
  {
    return Card(
      color: Colors.white,
      child: new ListTile(
        leading: icon,
        title:
        ComboBoxParameter(
          locations: options,
          parameterName: parameter_text,
          onExitDelayTimeChanged: (String val) {
            setState(() {

              switch (value_to_update)
              {
                case "GlobalParameters.chimeSelectedLocation":
                  {
                    GlobalParameters.chimeSelectedLocation = convert_to_string_time(val);
                  }
                  break;
                case "GlobalParameters.exitSelectedLocation":
                  {
                    GlobalParameters.exitSelectedLocation = convert_to_string_time(val);
                  }
                  break;
                case "GlobalParameters.entrySelectedLocation":
                  {
                    GlobalParameters.entrySelectedLocation = convert_to_string_time(val);
                  }
                  break;
                case "GlobalParameters.sirenSelectedLocation":
                  {
                    GlobalParameters.sirenSelectedLocation = convert_to_string_time(val);
                  }
                  break;
                case "GlobalParameters.TurnOnLightSelectedLocation":
                  {

                    is_selected_light = true;
                    GlobalParameters.SelectedLightBulb = val;
//                    _scrollController.animateTo(
//                      0.0,
//                      curve: Curves.easeOut,
//                      duration: const Duration(milliseconds: 300),
//                    );
                    //GlobalParameters.TurnOnLightList.add(val);
//                    GlobalParameters.TurnOnLightSelectedLocation = convert_to_string_time(val);
                  }
                  break;
                case "GlobalParameters.SelectedTime":
                  {
                    is_selected_time = true;
                    //is_selected = true;
//                    _selectTime(context);
                    //GlobalParameters.SelectedLightTime = convert_to_string_time(val);
                    //GlobalParameters.TurnOnLightList.add(val);
//                    GlobalParameters.TurnOnLightSelectedLocation = convert_to_string_time(val);
                  }
                  break;

              }

            });

//            //secondsPassed = int.parse(splitted_time);
            if (value_to_update == GlobalParameters.entrySelectedLocation)
              GlobalParameters.current_delay_time = int.parse(convert_to_string_time(val));
            print(GlobalParameters.sirenSelectedLocation);
          },
          //delay_time: secondsPassed,
          delay_time: default_selected,
        ),
        subtitle: Text(parameterExplanation),

      ),
    );

  }

  Widget default_code() {
    //return Row(children: <Widget>[
    //new Padding(padding: new EdgeInsets.all(15.00)),
    return TextField(
      maxLength: 4,
      obscureText: true,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.teal)),
        //hintText: 'Enter default code',
        helperText: 'The code to the system',
        labelText: 'Enter default code, default: ' + GlobalParameters.user_default_code,
        prefixIcon: const Icon(
          Icons.security,
          color: Colors.orangeAccent,
        ),
//          prefixText: ' ',
//          suffixText: 'USD',
//          suffixStyle: const TextStyle(color: Colors.green)),
      ),
      keyboardType: TextInputType.number,
      onChanged: (text) {
        GlobalParameters.user_default_code = text;
      },

      //),
//      new TextField(
//        onChanged: (text) {
//          user_default_code = text;
//        },
//      )
//      new  TextField(// Not necessary for Option 1
//        decoration: InputDecoration(
//            border: InputBorder.none,
//            hintText: 'Enter code'
//        ),
//        onSubmitted: (String value) {
//          user_default_code = value;
//        },
//      ),
    );
  }

  static String convert_to_string_time(String delay_time)
  {
    List<String> items = delay_time.split(' ');
    int exit_time = int.parse(items[0]);
    if (items[1] == "min")
    {
      exit_time = exit_time * 60;
    }
    if (items[1] == "hrs")
    {
      exit_time = exit_time * 3600;
    }
    return exit_time.toString();
  }

//  Widget sounds(List<String> options, String parameter_text,String parameterExplanation, String value_to_update) {
//    return Card(
//      child: ListTile(
//        leading: Icon(Icons.audiotrack),
//        title: ComboBoxParameter(
//          locations: options,
//          parameterName: parameter_text,
//          onExitDelayTimeChanged: (String val) {
//            setState(() {
//              value_to_update = val;
//            });
//            //check_time(GlobalParameters.entrySelectedLocation);
//            //secondsPassed = int.parse(splitted_time);
//            //GlobalParameters.current_delay_time = int.parse(check_time(GlobalParameters.entrySelectedLocation));
//
//          },
//          //delay_time: secondsPassed,
//          delay_time: "Disable",
//          //delay_time: GlobalParameters.current_delay_time,
//        ),
//        subtitle: Text('Do chime sound when contact open'),
//
//      ),
//    );
////    return Row(children: <Widget>[
////      new Padding(padding: new EdgeInsets.all(15.00)),
////      const Text('Chime',
////          style: TextStyle(
////            fontSize: 20.0,
////            fontWeight: FontWeight.bold,
////          )),
////
////      //new Text("Exit delay time "),
////      new Container(
////        padding: new EdgeInsets.all(16.0),
////      ),
////      new DropdownButton(
////        hint: Text('Please choose'),
////        value: GlobalParameters.chimeSelectedLocation,
////        onChanged: (newValue) {
////          setState(() {
////            GlobalParameters.chimeSelectedLocation = newValue;
////            print(GlobalParameters.chimeSelectedLocation);
////          });
////        },
////        items: _chime_options.map((location) {
////          return DropdownMenuItem(
////            child: new Text(location),
////            value: location,
////          );
////        }).toList(),
////      ),
////    ]);
////    return SwitchListTile(
////      title: const Text('Enable Chime',
////          style: TextStyle(
////            fontSize: 20.0,
////            fontWeight: FontWeight.bold,
////          )
////      ),
////      subtitle: const Text('Do chime sound when contact open',
////          style: TextStyle(
////            fontSize: 15.0,
////          )
////      ),
////      value: ding_dong_switch,
////      onChanged: (value) {
////        setState(() {
////          ding_dong_switch = value;
////        });
////      },
////      secondary: Icon(Icons.surround_sound),
////      isThreeLine: true,
////      dense: true,
////      selected: ding_dong_switch,
////      activeTrackColor: Colors.green[200],
////      activeColor: Colors.green,
////      inactiveThumbColor: Colors.white,
////      inactiveTrackColor: Colors.black,
////
////      //                  secondary: const Icon(Icons.lightbulb_outline),
////    );
//  }

  Widget parameterExplanation(String _text) {
    return Row(children: <Widget>[
      new Padding(padding: new EdgeInsets.all(15.00)),
      Text(
        _text,
        style: TextStyle(
          fontSize: 15.0,
          //fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
//class show_more_lights extends StatefulWidget {
//
//  List<AllLights> lights_cards_info = new List<AllLights>();
//
//  show_more_lights(this.lights_cards_info);
//
//  @override
//  _show_more_lightsState createState() => _show_more_lightsState();
//}
//class _show_more_lightsState extends State<show_more_lights> {
//  TimeOfDay selectedStartTime;
//  TimeOfDay selectedEndTime;
//  TimeOfDay selectedTime = TimeOfDay.now();
//  String str_selectedStartTime = "";
//  String str_selectedEndTime = "";
//  static List<RandomLight> TurnOnLightList = new List<RandomLight>();
//  static String random_time = "1 hour";
//  Color more_lights_color = Colors.black;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: back_color,
//      appBar: AppBar(
//        title: Text("Random light options"),
//      ),
//      body:
//      Column(
//        children: <Widget>[
//          Card(
//            child: SwitchListTile(
//              title: const Text('Random light',
//                  style: TextStyle(
//                    fontSize: 20.0,
//                    fontWeight: FontWeight.bold,
//                  )
//              ),
//              subtitle: const Text('turn on light every selected time',
//                  style: TextStyle(
//                    fontSize: 15.0,
//                  )
//              ),
//              value: GlobalParameters.TurnOnLightSelectedLocation_or_not,
//              onChanged: (value) {
//                setState(() {
//                  if (value == false)
//                  {
//                    more_lights_color = Colors.black;
//                  }
//                  else if (value == true)
//                  {
//                    more_lights_color = Colors.blueAccent;
//                  }
//                  GlobalParameters.TurnOnLightSelectedLocation_or_not = value;
////            _controller = ScrollController();
////            _controller.animateTo(pixelsToMove,
////                curve: Curves.linear, duration: Duration (milliseconds: 500));
////            _controller.animateTo(_controller.offset + itemSize,
////                curve: Curves.linear, duration: Duration(milliseconds: 500));
//                });
//              },
//              dense: true,
//              selected: GlobalParameters.TurnOnLightSelectedLocation_or_not,
//              activeTrackColor: Colors.blue[200],
//              activeColor: Colors.blueAccent,
//              inactiveThumbColor: Colors.white,
//              inactiveTrackColor: Colors.black,
//
//              //                  secondary: const Icon(Icons.lightbulb_outline),
//            ),
//          ),
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
//          GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? Card(
//            child: ListTile(
//                title: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Text("Lights options"),
//                    Spacer(),
//                    Text(GlobalParameters.selected_range_time),
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
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => choose_light_random_time()),
//                      );
//                  },
//                )
//
//
//
//            )
//        ): SizedBox.shrink(),
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
//          GlobalParameters.TurnOnLightSelectedLocation_or_not == true ? Container(
//              child: ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  itemCount: Device.lights_card_info_list.length,
//                  itemBuilder: (BuildContext context, int index) =>
//                      buildCard(context, index)),
//            ): SizedBox.shrink(),
//        ],
//      )
//    );
////      Container(
////      child: ListView.builder(
////          scrollDirection: Axis.vertical,
////          shrinkWrap: true,
////          itemCount: Device.lights_card_info_list.length,
////          itemBuilder: (BuildContext context, int index) =>
////              buildCard(context, index)),
////    );
//
//    return null;
//  }
//  Widget buildCard(BuildContext context, int index)
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
//  static void light_or_turn_off_timer() {
//    TimeOfDay current_time = TimeOfDay.now();
//    TurnOnLightList.clear();
//    for (int i = 0; i < Device.lights_card_info_list.length;i ++)
//    {
//      if (Device.lights_card_info_list[i].checkbox_val == true)
//      {
//        List<String> splitted_start_time = Device.lights_card_info_list[i].str_selectedStartTime.split(':');
//        TimeOfDay start_time = new TimeOfDay(hour: int.parse(splitted_start_time[0]), minute: int.parse(splitted_start_time[1]));
//        List<String> splitted_end_time = Device.lights_card_info_list[i].str_selectedEndTime.split(':');
//        TimeOfDay end_time = new TimeOfDay(hour: int.parse(splitted_end_time[0]), minute: int.parse(splitted_end_time[1]));
//
//        TurnOnLightList.add(RandomLight(Device.lights_card_info_list[i].name,start_time,end_time,Device.lights_card_info_list[i].id));
//      }
//    }
//    //TimeOfDay t;
////    for (int i = 0;i < TurnOnLightList.length;i ++)
//////    {
//
////      DateTime start = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].start_time.hour, TurnOnLightList[i].start_time.minute);
////      DateTime end = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].end_time.hour, TurnOnLightList[i].end_time.minute);
//
//    Timer.periodic(Duration(seconds: 1), (timer) {
//      DateTime now = new DateTime.now();
//
//      for (int i = 0;i < TurnOnLightList.length;i ++)
//      {
//
//        //DateTime now = new DateTime.now();
//        DateTime start = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].start_time.hour, TurnOnLightList[i].start_time.minute);
//        DateTime end = new DateTime(now.year, now.month, now.day, TurnOnLightList[i].end_time.hour, TurnOnLightList[i].end_time.minute);
//        if (now.hour >= start.hour)// && (now.hour <= end.hour) && (now.minute >= start.minute))
//            {
//          if (now.hour <= end.hour)
//          {
//            if (now.minute >= start.minute)
//            {
//              if ((now.hour == start.hour) && (now.minute == start.minute))
//              {
//                if (TurnOnLightList[i].turn_on_first_time == true)
//                {
//                  print("turn on the light");
//                  DevicesCommands.switch_light_command(TurnOnLightList[i].device_id, "on");
//                  TurnOnLightList[i].turn_on_first_time = false;
//                }
//
//              }
//              if ((now.hour == end.hour) && (now.minute == end.minute))
//              {
//                if (TurnOnLightList[i].turn_off_first_time == true)
//                {
//                  print("turn off the light");
//                  DevicesCommands.switch_light_command(TurnOnLightList[i].device_id, "off");
//                  TurnOnLightList[i].turn_off_first_time = false;
//                }
//
//
//                //timer.cancel();
//              }
//            }
//          }
//          //if ()
//
////            else
////            {
////              print(DateTime.now());
////            }
//          //if ((now.minute >= start.minute) && (now.minute <= end.minute))
//
//        }
//      }
//
//
//    });
//    //}
//
//  }
//  Future<String> _selectTime(BuildContext context, String action,int index) async {
////    TimeOfDay selectedTime;
//    final TimeOfDay picked_s = await showTimePicker(
//        context: context,
//        initialTime: selectedTime, builder: (BuildContext context, Widget child) {
//      return MediaQuery(
//        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//        child: child,
//      );});
//
//    if (picked_s != null && picked_s != selectedTime )
//      setState(() {
//        if (action == "start")
//        {
//          selectedStartTime = picked_s;
//          //str_selected_start_time = "${selectedStartTime.hour}:${selectedStartTime.minute}";
//          str_selectedStartTime = "${selectedStartTime.hour}:${selectedStartTime.minute}";
//          Device.lights_card_info_list[index].str_selectedStartTime = str_selectedStartTime;
//          //return str_selectedStartTime;
//        }
//
//        else if (action == "end")
//        {
//          selectedEndTime = picked_s;
//          //TurnOnLightList.add(RandomLight(GlobalParameters.SelectedLightBulb,selectedStartTime,selectedEndTime,true,str_selectedStartTime,str_selectedEndTime));
//          str_selectedEndTime = "${selectedEndTime.hour}:${selectedEndTime.minute}";
//          Device.lights_card_info_list[index].str_selectedEndTime = str_selectedEndTime;
//          //str_selected_end_time = "${selectedEndTime.hour}:${selectedEndTime.minute}";
//          light_or_turn_off_timer();
//          //return str_selectedEndTime;
//          //            var map = {time_to_enter: }
////            GlobalParameters.TurnOnLightList.update(time_to_enter, selectedStartTime , selectedStartTime);
////            GlobalParameters.TurnOnLightList[time_to_enter] = ;
////            selectedEndTime = picked_s;
////            if (selectedStartTime != null)
////            {
////              double _doubleyourTime = selectedStartTime.hour.toDouble() +
////                  (selectedStartTime.minute.toDouble() / 60);
////              double _doubleNowTime = selectedEndTime.hour.toDouble() +
////                  (selectedEndTime.minute.toDouble() / 60);
////              Timer.periodic(Duration(seconds: 5), (timer) {
//          print(DateTime.now());
////              });
//
//        }
//        selectedTime = picked_s;
//        //return "";
//
//      });
//  }
//}
//
class choose_light_random_time extends StatefulWidget {

  //List<AllLights> lights_cards_info = new List<AllLights>();

  choose_light_random_time();

  @override
  _choose_light_random_time_optionsState createState() => _choose_light_random_time_optionsState();
}
class _choose_light_random_time_optionsState extends State<choose_light_random_time> {

  List<SelectOptions> _options = [
    SelectOptions("30 minutes",false),
    SelectOptions("1 hour",false),
    SelectOptions("2 hours",false),
  ];
  //options.add(SelectOptions("30 minutes",false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select light time"),
      ),
      body: SelectFromOptions(
          explanation: "select the time that every light bulb will stay on randomly several times between the times that you chose",
          default_val: GlobalParameters.selected_range_time,
          options: _options,
          returned_val: (String val) {
            GlobalParameters.selected_range_time = val;
          },
        ),
    );//SelectFromOptions(_options),
//      body: Column(
//        children: <Widget>[
//          ListTile(
//            title: Text("30 minutes"),
//            trailing: GlobalParameters.light_selected_30_min == true ? Icon(Icons.check,color: Colors.blue[700]):null,
//            onTap: (){
//              setState(() {
//                _show_more_lightsState.random_time = "30 minutes";
//                GlobalParameters.light_selected_30_min = true;
//                GlobalParameters.light_selected_1_hour = false;
//                GlobalParameters.light_selected_2_hours = false;
//              });
//
//            },
//          ),
//          Divider(thickness: 1.5),
//          ListTile(
//            title: Text("1 hour"),
//            trailing: GlobalParameters.light_selected_1_hour == true ? Icon(Icons.check,color: Colors.blue[700]):null,
//            onTap: (){
//              setState(() {
//                _show_more_lightsState.random_time = "1 hour";
//                GlobalParameters.light_selected_1_hour = true;
//                GlobalParameters.light_selected_2_hours = false;
//                GlobalParameters.light_selected_30_min = false;
//              });
//
//            },
//          ),
//          Divider(thickness: 1.5),
//          ListTile(
//            title: Text("2 hours"),
//            trailing: GlobalParameters.light_selected_2_hours == true ? Icon(Icons.check,color: Colors.blue[700]):null,
//            onTap: (){
//              setState(() {
//                _show_more_lightsState.random_time = "2 hours";
//                GlobalParameters.light_selected_2_hours = true;
//                GlobalParameters.light_selected_1_hour = false;
//                GlobalParameters.light_selected_30_min = false;
//              });
//
//            },
//          ),
//        ],
//      ),
      //body: ,
    //);
  }

}

