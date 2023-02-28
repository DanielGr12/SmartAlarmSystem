import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tcp_alarm_system/Classes/DeviceDatabase.dart';
import 'package:tcp_alarm_system/Classes/DevicesCommands.dart';
import 'package:tcp_alarm_system/Classes/log.dart';
import 'package:tcp_alarm_system/main.dart';
import '../Classes/DevicesInfo.dart';
import 'package:flutter/material.dart';
import '../Globals/GlobalParameters.dart';
class DevicesWidget extends StatelessWidget
{


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new ListView.builder(
            itemCount: Device.DevicesList.length,
            itemBuilder: (BuildContext context, int index) =>
                buildDeviceCard(context, index)),
    );
  }

  Widget buildDeviceCard(BuildContext context, int index) {
    if ((index %2 == 0) && (index == Device.DevicesList.length-1))
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 130,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
                  );
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15),
                    ),//+ Borde,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                height: 50,
                                width: 50,
                                child: Image.asset(Device.DevicesList[index].image_path, fit: BoxFit.cover)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Device.DevicesList[index].name),
                        ),
//                        IconButton(
//                          icon: Icon(Icons.navigate_next),
//                          onPressed: (){
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
//                            );
//                          },
//                        ),
                      ],
                    )
//                  ListTile(
//                    leading: Image.asset(Device.DevicesList[index].image_path, fit: BoxFit.cover),
//                    title: Text(Device.DevicesList[index].name),
//                    trailing: IconButton(
//                      icon: Icon(Icons.navigate_next),
//                      onPressed: (){
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
//                        );
//                      },
//                    ),
//                    subtitle: device_subtitle(index),
//                    //Devices.DevicesList[index].device_name == "Contact detector" ? subt
//                  )
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 130,

            ),
          )

        ],
      );
    }
    else if (index % 2 == 0)
      {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 130,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
                    );
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15),
                      ),//+ Borde,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(Device.DevicesList[index].image_path, fit: BoxFit.cover)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(Device.DevicesList[index].name),
                          ),
//                          IconButton(
//                              icon: Icon(Icons.navigate_next),
//                              onPressed: (){
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
//                                );
//                              },
//                            ),
                        ],
                      )
//                    ListTile(
//                      leading: Image.asset(Device.DevicesList[index].image_path, fit: BoxFit.cover),
//                      title: Text(Device.DevicesList[index].name),
//                      trailing: IconButton(
//                        icon: Icon(Icons.navigate_next),
//                        onPressed: (){
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
//                          );
//                        },
//                      ),
//                      subtitle: device_subtitle(index),
//                      //Devices.DevicesList[index].device_name == "Contact detector" ? subt
//                    )
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 130,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index+1])),
                    );
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15),
                      ),//+ Borde,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(Device.DevicesList[index+1].image_path, fit: BoxFit.cover)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(Device.DevicesList[index+1].name),
                          ),
//                          IconButton(
//                            icon: Icon(Icons.navigate_next),
//                            onPressed: (){
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index+1])),
//                              );
//                            },
//                          ),
                        ],
                      )
//                    ListTile(
//                      leading: Image.asset(Device.DevicesList[index+1].image_path, fit: BoxFit.cover),
//                      title: Text(Device.DevicesList[index+1].name),
//                      trailing: IconButton(
//                        icon: Icon(Icons.navigate_next),
//                        onPressed: (){
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index+1])),
//                          );
//                        },
//                      ),
//                      subtitle: device_subtitle(index+1),
//                      //Devices.DevicesList[index].device_name == "Contact detector" ? subt
//                    )
                  ),
                ),
              ),
            )

          ],
        );
//        return Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            Column(
//                children: <Widget>[
//                  Flexible(
//                    child: Card(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: new BorderRadius.circular(15),
//                        ),//+ Borde,
//                        child: ListTile(
//                          leading: Image.asset(Device.DevicesList[index].image_path, fit: BoxFit.cover),
//                          title: Text(Device.DevicesList[index].name),
//                          trailing: IconButton(
//                            icon: Icon(Icons.navigate_next),
//                            onPressed: (){
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
//                              );
//                            },
//                          ),
//                          subtitle: device_subtitle(index),
//                          //Devices.DevicesList[index].device_name == "Contact detector" ? subt
//                        )
//                    ),
//
//                  ),
//                  Column(
//                    children: <Widget>[
//                      Flexible(
//                        child: Card(
//                            shape: RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.circular(15),
//                            ),//+ Borde,
//                            child: ListTile(
//                              leading: Image.asset(Device.DevicesList[index+1].image_path, fit: BoxFit.cover),
//                              title: Text(Device.DevicesList[index+1].name),
//                              trailing: IconButton(
//                                icon: Icon(Icons.navigate_next),
//                                onPressed: (){
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index+1])),
//                                  );
//                                },
//                              ),
//                              subtitle: device_subtitle(index+1),
//                              //Devices.DevicesList[index].device_name == "Contact detector" ? subt
//                            )
//                        ),
//                      )
//                    ],
//                  )
//
//                ],
//              ),
//
//
//
//          ],
//        );
      }

      return SizedBox.shrink();
    //https://stackoverflow.com/questions/58115148/how-to-change-height-of-a-card-in-flutter
    return Container(
      child:
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15),
        ),//+ Borde,
          child: ListTile(
            leading: Image.asset(Device.DevicesList[index].image_path, fit: BoxFit.cover),
            title: Text(Device.DevicesList[index].name),
            trailing: IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => show_more(Device.DevicesList[index])),
                );
              },
            ),
            subtitle: device_subtitle(index),
            //Devices.DevicesList[index].device_name == "Contact detector" ? subt
          )
      ),
    );
  }

  Widget device_subtitle(int index)
  {
    if (Device.DevicesList[index].name == "Contact detector")
    {
      return GlobalParameters.contact_state;
    }
    else if (Device.DevicesList[index].name == "Motion detector")
    {
      if (GlobalParameters.pir_event.data == "Detected")
        return GlobalParameters.pir_event;
    }
    else if (Device.DevicesList[index].name == "Keyfob")
    {
      if ((GlobalParameters.keyfob_last_event.data == "Last Pressed: Arm away") || (GlobalParameters.keyfob_last_event.data == "Last Pressed: Disarm"))
        return GlobalParameters.keyfob_last_event;

    }
//    if (Device.DevicesList[index].name == "SmartSense Motion Sensor")
//      {
//  //      var a = "https://api.smartthings.com/v1/devices/""/status";
//// + Device.DevicesList[index].deviceId.toString() +
//        Map data = get_device_status(Device.DevicesList[index].deviceId.toString()) as Map;
//        var a = data["components"]["main"]["switch"]["value"];
//        return a;
//      }
//    else if (Device.DevicesList[index].name == "SmartSense Open/Closed Sensor")
//    {
//      //Device.st_devices_name.add()
//      //if ((GlobalParameters.keyfob_last_event.data == "Last Pressed: Arm away") || (GlobalParameters.keyfob_last_event.data == "Last Pressed: Disarm"))
//        return GlobalParameters.keyfob_last_event;
//
//    }
    return null;
  }

}

class show_more extends StatefulWidget {

  final Device device_params;

  show_more(this.device_params);

  @override
  _show_moreState createState() => _show_moreState();
}

class _show_moreState extends State<show_more> {
  double _selected_light_brightness = 0;
  double color_temperature = 2200;
  String elected_light_brightness;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device_params.name),
      ),
      body: new ListView.builder(
          itemCount: 16,//device_params.status.getCapabilitiesLength(),//device_params.capabilities.length,
          itemBuilder: (BuildContext context, int index) => buildCapabilitiesCard(context, index)),
    );
  }

  Widget buildCapabilitiesCard(BuildContext context, int index) {
    if(widget.device_params.status.getSupportedCapabilities(index,widget.device_params) == false)
      return SizedBox.shrink();

    //https://stackoverflow.com/questions/58115148/how-to-change-height-of-a-card-in-flutter
    return  Container(
      child: show_more_card(index)
//      Card(
//          child: ListTile(
//            title: Text(widget.device_params.status.getCapabilitieName(index), style: new TextStyle(fontSize: 20.0)),
//            subtitle: subtitle_widget(CapabilitiesEnum.values[index]),
//
////            CapabilitiesEnum.values[index] == CapabilitiesEnum.switchLevel ? Container(
////              width: 5,
////              child:
////                Center(
////                  child:
////                  Container(
////                    child: Slider(value: _selected_light_brightness.toDouble(),
////                     onChanged: (newValue)
////                    {
////                      setState(() {
////                      _selected_light_brightness = newValue;
////                    });
////                    },
////                    onChangeEnd: (newValue) {
////
////                      int varible = _selected_light_brightness.toInt();//
////                      dim_command(widget.device_params.deviceId,varible);
//////                    FutureBuilder(
//////                    future: post_command(widget.device_params.deviceId),
//////                    builder: (context, snapshot){
//////                      if (snapshot.connectionState == ConnectionState.done)
//////                      {
//////                        var data = snapshot.data;
//////                        return data;
//////                      }
//////                      else{
//////                        return CircularProgressIndicator();
//////                      }
//////                    },
//////                  );
////
////
////                    },
////                    min: 0,
////                    max: 100,
////                    divisions: 100,
////                    label: _selected_light_brightness.toStringAsFixed(0),
////                    //https://api.dart.dev/stable/2.7.2/dart-core/num/toStringAsFixed.html
////                    ),
////                  ),
////                ),
////            ): null ,
//            //Text(trailing_value(CapabilitiesEnum.values[index],widget.device_params.status.status_values(index)), style: new TextStyle(fontSize: 20.0)),
////slider(device_params.capabilities[index]),
//            leading: widget.device_params.status.device_icons(index),
//
//            trailing: trailing_value(CapabilitiesEnum.values[index],widget.device_params.status.status_values(index),widget.device_params.deviceId),
//
//
//          ),
//        )
    );
  }
  String json_string = (
      """
{
  "commands": [
    {
      "component": "main",
      "capability": "switchLevel",
      "command": "setLevel",
      "arguments": [0]
    }
  ]
}
      """
  );
  Widget show_more_card(int index) {


//    if ((widget.device_params.status.getCapabilitieName(index) !=
//    "Check Interval") && (widget.device_params.name == "IKEA TRÅDFRI LED Bulb") &&
//    (widget.device_params.status.getCapabilitieName(index) != "Light"))
//     {
    if ((widget.device_params.status.getCapabilitieName(index) == "Switch") &&
        (widget.device_params.capabilities.contains("alarm"))) {
      return SizedBox.shrink();
    }
    return Card(
      child: ListTile(
        title: title_value(index, widget.device_params),
//          Text(widget.device_params.status.getCapabilitieName(index),
//              style: new TextStyle(fontSize: 20.0)),
        subtitle: subtitle_widget(CapabilitiesEnum.values[index]),

//            CapabilitiesEnum.values[index] == CapabilitiesEnum.switchLevel ? Container(
//              width: 5,
//              child:
//                Center(
//                  child:
//                  Container(
//                    child: Slider(value: _selected_light_brightness.toDouble(),
//                     onChanged: (newValue)
//                    {
//                      setState(() {
//                      _selected_light_brightness = newValue;
//                    });
//                    },
//                    onChangeEnd: (newValue) {
//
//                      int varible = _selected_light_brightness.toInt();//
//                      dim_command(widget.device_params.deviceId,varible);
////                    FutureBuilder(
////                    future: post_command(widget.device_params.deviceId),
////                    builder: (context, snapshot){
////                      if (snapshot.connectionState == ConnectionState.done)
////                      {
////                        var data = snapshot.data;
////                        return data;
////                      }
////                      else{
////                        return CircularProgressIndicator();
////                      }
////                    },
////                  );
//
//
//                    },
//                    min: 0,
//                    max: 100,
//                    divisions: 100,
//                    label: _selected_light_brightness.toStringAsFixed(0),
//                    //https://api.dart.dev/stable/2.7.2/dart-core/num/toStringAsFixed.html
//                    ),
//                  ),
//                ),
//            ): null ,
        //Text(trailing_value(CapabilitiesEnum.values[index],widget.device_params.status.status_values(index)), style: new TextStyle(fontSize: 20.0)),
//slider(device_params.capabilities[index]),
        leading: widget.device_params.status.device_icons(index),

        trailing: trailing_value(CapabilitiesEnum.values[index],
            widget.device_params.status.status_values(index),
            widget.device_params.deviceId,
            widget.device_params),


      ),
    );


  }
  bool set_light_first_time = true;
  Widget title_value(int index,Device device)
  {
//    if (widget.device_params.capabilities[index] != "alarm")
//      {
        if (widget.device_params.status.getCapabilitieName(index) == "Switch")
        {
          if (set_light_first_time == true)
          {
            GlobalParameters.current_light_switch = "";
            if (device.status.main.light != null)
            {
              GlobalParameters.current_light_switch = device.status.main.light.switch_process.value;
            }

            set_light_first_time = false;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.device_params.status.getCapabilitieName(index),
                  style: new TextStyle(fontSize: 20.0)),
              Text(GlobalParameters.current_light_switch,style: new TextStyle(fontSize: 20.0)),
            ],
          );
        }
        return Text(widget.device_params.status.getCapabilitieName(index),
            style: new TextStyle(fontSize: 20.0));
//      }
//    return Text("");

  }
  Widget subtitle_widget(CapabilitiesEnum calling_source)
  {
    switch(calling_source)
    {

      case CapabilitiesEnum.contactSensor:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.checkInterval:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.temperatureMeasurement:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.battery:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.presenceSensor:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.signalStrength:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.alarm:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.switchProcess:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.motionSensor:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.light:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.colorTemperature:
        return Container(
          child:
          Row(
            children: <Widget>[
              Container(
                  width: 20.15,
                  height: 35,
                  child: Image.asset("assets/warm_v2_light_bulb.png",)
              ),
              Center(
                child:
                Container(
                  width: 150,
                  child: Slider(value: color_temperature,
                    onChanged: (newValue)
                    {
                      setState(() {
                        color_temperature = newValue;
                      });
                    },
                    onChangeEnd: (newValue) {

                      int varible = color_temperature.toInt();//
                      change_color_temp_command(widget.device_params.deviceId,varible);
//                    FutureBuilder(
//                    future: post_command(widget.device_params.deviceId),
//                    builder: (context, snapshot){
//                      if (snapshot.connectionState == ConnectionState.done)
//                      {
//                        var data = snapshot.data;
//                        return data;
//                      }
//                      else{
//                        return CircularProgressIndicator();
//                      }
//                    },
//                  );


                    },
                    min: 2200,
                    max: 4000,
                    divisions: 1800,
                    label: color_temperature.toStringAsFixed(0),
                    //https://api.dart.dev/stable/2.7.2/dart-core/num/toStringAsFixed.html
                  ),
                ),
              ),
              Container(
                  width: 20.15,
                  height: 40,
                  child: Image.asset("assets/bright_light_bulb_v2.png",)
              ),
            ],
          ),
        );
        break;
      case CapabilitiesEnum.switchLevel:
        //slider dimmer
        return Container(
          //width: 5,
          child:
          Row(
            children: <Widget>[
              Container(
                  width: 25,
                  height: 25,
                  child: Image.asset("assets/dim_small.png",)
              ),
              Center(
                child:
                Container(
                  width: 150,
                  child: Slider(value: _selected_light_brightness.toDouble(),
                    onChanged: (newValue)
                    {
                      setState(() {
                        _selected_light_brightness = newValue;
                      });
                    },
                    onChangeEnd: (newValue) {

                      int varible = _selected_light_brightness.toInt();//
                      dim_command(widget.device_params.deviceId,varible);
//                    FutureBuilder(
//                    future: dim_command(widget.device_params.deviceId,varible),
//                    builder: (context, snapshot){
//                      if (snapshot.connectionState == ConnectionState.done)
//                      {
//                        var data = snapshot.data;
//                        return data;
//                      }
//                      else{
//                        return CircularProgressIndicator();
//                      }
//                    },
//                  );


                    },
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _selected_light_brightness.toStringAsFixed(0),
                    //https://api.dart.dev/stable/2.7.2/dart-core/num/toStringAsFixed.html
                  ),
                ),
              ),

              Container(
                width: 25,
                  height: 25,
                  child: Image.asset("assets/dim1.png",)
              ),
            ],
//             Center(
//              child:
//              Container(
//                child: Slider(value: _selected_light_brightness.toDouble(),
//                  onChanged: (newValue)
//                  {
//                    setState(() {
//                      _selected_light_brightness = newValue;
//                    });
//                  },
//                  onChangeEnd: (newValue) {
//
//                    int varible = _selected_light_brightness.toInt();//
//                    dim_command(widget.device_params.deviceId,varible);
////                    FutureBuilder(
////                    future: dim_command(widget.device_params.deviceId,varible),
////                    builder: (context, snapshot){
////                      if (snapshot.connectionState == ConnectionState.done)
////                      {
////                        var data = snapshot.data;
////                        return data;
////                      }
////                      else{
////                        return CircularProgressIndicator();
////                      }
////                    },
////                  );
//
//
//                  },
//                  min: 0,
//                  max: 100,
//                  divisions: 100,
//                  label: _selected_light_brightness.toStringAsFixed(0),
//                  //https://api.dart.dev/stable/2.7.2/dart-core/num/toStringAsFixed.html
//                ),
//              ),
//            ),
          ),
        );
        break;
      case CapabilitiesEnum.button1:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.button2:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.button3:
        // TODO: Handle this case.
        break;
      case CapabilitiesEnum.button4:
        // TODO: Handle this case.
        break;
    }
  }

  Future<Map> change_color_temp_command(String device_id, int temperature) async {
    List<int> argument = new List<int>();
    argument.add(temperature);
    List<Commands> commands = new List<Commands>();
    Commands command = new Commands(
        capability: "colorTemperature",
        component: "main",
        command: "setColorTemperature",
        arguments: argument
    );
    commands.add(command);
    ChangeColorTemperature change_light_temp = new ChangeColorTemperature(commands: commands);
    Map<String, dynamic> json_command = change_light_temp.toJson();
    print(json_command);
    ///////////////////////////////////////////////////////////////////

    HttpClient client = new HttpClient();
    String myUrl = "https://api.smartthings.com/v1/devices/${device_id}/commands";
//    client.post(myUrl, headers: {"Content-Type": "text/plain", HttpHeaders.authorizationHeader :
//      ""}, body: json.encode(), "");
    client.postUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
      request.headers.add(HttpHeaders.contentTypeHeader, 'text/plain');
      request.headers.add(HttpHeaders.authorizationHeader,
          "YOUR TOKEN HERE");
      request.add(utf8.encode(json.encode(json_command)));
      return request.close(); //.timeout(const Duration(seconds: 8));
    }).then((HttpClientResponse response) async {
      print(response.headers.toString());
      print('statusCode:'+ response.statusCode.toString());
      var responseBody = await response.transform(utf8.decoder).join();
      print(responseBody.toString());
      //Map data = json.decode(responseBody);

      //var parsedJson = json.decode(responseBody);


//      final pmt = new Components.fromJson(data["components"]);//["main"]
//      Device.DevicesList[index].status = pmt;
      // print(data);

    });

  }
//  static Future<Map> switch_light_command(String device_id, String action) async {
//    List<int> argument = new List<int>();
////    argument.add(action);
//    List<LightCommands> commands = new List<LightCommands>();
//    LightCommands command = new LightCommands(
//        capability: "switch",
//        component: "main",
//        command: action,
//        arguments: argument
//    );
//    commands.add(command);
//    SwitchLight change_light = new SwitchLight(commands: commands);
//    Map<String, dynamic> json_command = change_light.toJson();
//    print(json_command);
//    ///////////////////////////////////////////////////////////////////
//
//    HttpClient client = new HttpClient();
//    String myUrl = "https://api.smartthings.com/v1/devices/${device_id}/commands";
////    client.post(myUrl, headers: {"Content-Type": "text/plain", HttpHeaders.authorizationHeader :
////      ""}, body: json.encode(), "");
//    client.postUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
//      request.headers.add(HttpHeaders.contentTypeHeader, 'text/plain');
//      request.headers.add(HttpHeaders.authorizationHeader,
//          "");
//      request.add(utf8.encode(json.encode(json_command)));
//      return request.close(); //.timeout(const Duration(seconds: 8));
//    }).then((HttpClientResponse response) async {
//      print(response.headers.toString());
//      print('statusCode:'+ response.statusCode.toString());
//      var responseBody = await response.transform(utf8.decoder).join();
//      print(responseBody.toString());
//      //Map data = json.decode(responseBody);
//
//      //if(device_id == 'd891ebe2-a1ef-4404-8e02-f5002065f984') {
//      //var parsedJson = json.decode(responseBody);
//
//
////      final pmt = new Components.fromJson(data["components"]);//["main"]
////      Device.DevicesList[index].status = pmt;
//      // print(data);
//
//    });
//
//  }
  Future<Map> dim_command(String device_id, int dim_current_level) async {
    List<int> argument = new List<int>();
    argument.add(dim_current_level);
    List<Commands> commands = new List<Commands>();
    Commands command = new Commands(
        capability: "switchLevel",
        component: "main",
        command: "setLevel",
        arguments: argument
    );
    commands.add(command);
    DimmerCommand dim = new DimmerCommand(commands: commands);
    Map<String, dynamic> json_command = dim.toJson();
    print(json_command);
    ///////////////////////////////////////////////////////////////////

    HttpClient client = new HttpClient();
    String myUrl = "https://api.smartthings.com/v1/devices/${device_id}/commands";
//    client.post(myUrl, headers: {"Content-Type": "text/plain", HttpHeaders.authorizationHeader :
//      ""}, body: json.encode(), "");
    client.postUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
      request.headers.add(HttpHeaders.contentTypeHeader, 'text/plain');
      request.headers.add(HttpHeaders.authorizationHeader,
          "YOUR TOKEN HERE");
      request.add(utf8.encode(json.encode(json_command)));
      return request.close(); //.timeout(const Duration(seconds: 8));
    }).then((HttpClientResponse response) async {
      print(response.headers.toString());
      print('statusCode:'+ response.statusCode.toString());
      var responseBody = await response.transform(utf8.decoder).join();
      print(responseBody.toString());
      //Map data = json.decode(responseBody);

      //if(device_id == 'd891ebe2-a1ef-4404-8e02-f5002065f984') {
      //var parsedJson = json.decode(responseBody);


//      final pmt = new Components.fromJson(data["components"]);//["main"]
//      Device.DevicesList[index].status = pmt;
      // print(data);

    });

  }

  bool setup_light = true;
  Widget trailing_value(CapabilitiesEnum calling_source,String value, String device_id, Device device)
  {
    //String trailing_return_val = value;

    switch(calling_source)
    {

      case CapabilitiesEnum.contactSensor:
        return Text(value,style: TextStyle(
          fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.checkInterval:
        // TODO: Handle this case.
        return Text(value,style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.temperatureMeasurement:
        return Text(value,style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.battery:
        String str_battery_precentege = value.replaceAll("%","");
        int battery_precentege = int.parse(str_battery_precentege);
        String str_low_battery_precentege = GlobalParameters.selected_low_battery_percent.replaceAll("%","");
        int low_battery_precentege = int.parse(str_low_battery_precentege);
        Widget returned_widget;
        if (battery_precentege <= low_battery_precentege)
        {
          //TODO: send notification
//          DateTime now = new DateTime.now();
//          String formattedDate = DateFormat('yyyy.MM.dd , HH:mm:ss ').format(now);
//          var my_log_key = UniqueKey();
//          LogEvent event = new LogEvent(formattedDate, "Low battery to ${device.label}", my_log_key, false,"");
//          LogEvent.LogEvents.add(event);
          returned_widget = Text(value,style: TextStyle(
              fontSize: 17,
            color: Colors.redAccent
          ),);
        }
        else
        {
         returned_widget = Text(value,style: TextStyle(
          fontSize: 17
          ),);
        }
        return returned_widget;


        break;
      case CapabilitiesEnum.presenceSensor:
        return Text(value,style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.signalStrength:
        return Text(value,style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.alarm:
        return Text(value,style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.switchProcess:
        if (device.capabilities.contains("alarm") == false)
        {
          if(setup_light == true)
          {

            GlobalParameters.current_light_switch = "";
            if (device.status.main.light != null)
            {
              GlobalParameters.current_light_switch = device.status.main.light.switch_process.value;
            }

            setup_light = false;
          }

          if (value == "on")
            GlobalParameters.light_icon_color = Colors.lightGreen;
          else if (value == "off")
            GlobalParameters.light_icon_color = Colors.grey[200];

          return ClipRRect(

            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              color: GlobalParameters.light_icon_color,
              child: IconButton(
                icon: Icon(Icons.power_settings_new),
                //color: light_icon_color,
                onPressed: (){
                  if (GlobalParameters.current_light_switch == "off")
                  {
                    setState(() {
                      GlobalParameters.light_icon_color = Colors.lightGreen;
                    });
                    GlobalParameters.current_light_switch = "on";
                    DevicesCommands.switch_light_command(device_id, GlobalParameters.current_light_switch);

                  }
                  else if (GlobalParameters.current_light_switch == "on")
                  {
                    setState(() {
                      GlobalParameters.light_icon_color = Colors.grey[200];
                    });
                    GlobalParameters.current_light_switch = "off";
                    DevicesCommands.switch_light_command(device_id, GlobalParameters.current_light_switch);

                  }
                },
              ),
            ),
          );
        }

        break;
      case CapabilitiesEnum.motionSensor:
        return Text(value,style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.light:
        if(setup_light == true)
        {
          GlobalParameters.current_light_switch = value;

          setup_light = false;
        }

          if (value == "on")
              GlobalParameters.light_icon_color = Colors.lightGreen;
          else if (value == "off")
            GlobalParameters.light_icon_color = Colors.grey[200];

        return Text(GlobalParameters.current_light_switch);
        break;
      case CapabilitiesEnum.colorTemperature:
        return Text(color_temperature.toStringAsFixed(0) + " \u212A",style: TextStyle(
            fontSize: 17
        ),);
        break;
      case CapabilitiesEnum.switchLevel:
        return Text(_selected_light_brightness.toStringAsFixed(0).toString() + '%', style: new TextStyle(fontSize: 20.0));
        break;
      case CapabilitiesEnum.button1:
        // TODO: Handle this case.

      case CapabilitiesEnum.button2:
        // TODO: Handle this case.
        //break;
      case CapabilitiesEnum.button3:
        // TODO: Handle this case.
        //break;
      case CapabilitiesEnum.button4:
        // TODO: Handle this case.
        //break;
        return Text("");
    }


  }
  Widget sliderr(String capability)
  {
//    if (capability != "switchLevel")
//      return null;

    return Center(
      child: Slider(value: _selected_light_brightness.toDouble(), onChanged: (newValue) {
        //TODO: send a command to device_id
        setState(() {
          _selected_light_brightness = newValue;
        });
      },
        min: 0,
        max: 100,
        //divisions: 5,
      ),
    );
  }
}
//: null
