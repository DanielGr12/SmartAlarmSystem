import 'dart:convert';
import 'dart:io';

import 'package:tcp_alarm_system/Classes/DeviceDatabase.dart';
//import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Widgets/DevicesWidget.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';
class DevicesCommands
{
  static Future<Map> switch_light_command(String device_id, String action) async {
    List<int> argument = new List<int>();
//    argument.add(action);
    List<LightCommands> commands = new List<LightCommands>();
    LightCommands command = new LightCommands(
        capability: "switch",
        component: "main",
        command: action,
        arguments: argument
    );
    commands.add(command);
    SwitchLight change_light = new SwitchLight(commands: commands);
    Map<String, dynamic> json_command = change_light.toJson();
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
}