import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DeviceDatabase.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';
//class capabilities
//{
//  bool temperatureMeasurement = false;
//  bool battery = false;
//  bool contactSensor = false;
//  bool motionSensor = false;
//  bool configuration = false;
//  bool refresh = false;
//  bool sensor = false;
//  bool healthCheck = false;
//  bool presenceSensor = false;
//  bool tone = false;
//  bool signalStrength = false;
//  bool actuator = false;
//  bool _switch = false;
//  bool alarm = false;
//  bool switchLevel = false;
//  bool colorTemperature = false;
//  bool light = false;
//  bool bridge = false;
//
//}
class Temperaturemeasurement implements ListItem
{
  Temperature temperature;
}

class Temperature implements ListItem
{
  final int value;
  final String unit;
  Temperature(this.value, this.unit);
}

class Battery implements ListItem
{
  final int value;
  final String unit;
  Battery(this.value, this.unit);
}

class Device
{
  static List<AllLights> lights_card_info_list = new List<AllLights>();
  String name;
  String image_path;
  String deviceId;
  String label;
  //capabilities device_capabilities;
  List<String> capabilities = new List<String>();
  //List<ListItem> capabilities_status = new List<ListItem>();
  Components status;
  String type;
  String detector_section;
  String detector_chime;
  bool is_chime_enabled = false;
  Device(this.name, this.image_path, this.capabilities, this.deviceId, this.label,this.status,this.type, this.detector_section,this.detector_chime,this.is_chime_enabled);


  static List<Device> DevicesList = [
//    Device("Keyfob","assets/keyfob.jpg"),
//    Device("Motion detector","assets/pir_detector.png"),
//    Device("Contact detector","assets/contact_detector.png"),
//    Device("Camera","assets/hikvision_camera.jpg"),
//    Device("Keypad","assets/keypad.jpg"),
//    Device("Receiver","assets/mcr308_receiver.jpg")
  ];
  static List<Device> lights_list()
  {
    List<Device> lights_list = new List<Device>();
//    List<String> labels_list = Device.lights_labels_list();
//    List<String> id_list = Device.lights_id_list();
    for (int i = 0; i < Device.DevicesList.length;i ++)
    {
      if (Device.DevicesList[i].capabilities.contains("light") == true)
      {
        //lights_card_info_list.add(AllLights(Device.DevicesList[i].label,"","",false,Device.DevicesList[i].deviceId));
        lights_list.add(Device.DevicesList[i]);
      }
    }
    return lights_list;
  }

//  static List<RandomLight> lights_parameters_list()
//  {
//    List<RandomLight> labels_list = new List<RandomLight>();
//    List<Device> device_list = lights_list();
//    device_list.forEach((device) => labels_list.add(device.label));
////    for (int i = 0;i < device_list.length;i ++)
////    {
////      labels_list.add(device_list[i].label);
////    }
//    return labels_list;
//  }
  static List<String> lights_labels_list()
  {
    List<String> labels_list = new List<String>();
    List<Device> device_list = lights_list();
    device_list.forEach((device) => labels_list.add(device.label));
//    for (int i = 0;i < device_list.length;i ++)
//    {
//      labels_list.add(device_list[i].label);
//    }
    return labels_list;
  }
  static List<String> lights_id_list()
  {
    List<String> id_list = new List<String>();
    List<Device> device_list = lights_list();
    device_list.forEach((device) => id_list.add(device.deviceId));
//    for (int i = 0;i < device_list.length;i ++)
//    {
//      labels_list.add(device_list[i].label);
//    }
    return id_list;
  }
  static Future<Null> st_devices(Map devices)
  {
    print("start in st_devices");
//    String deviceId;
//    String label;
//    //capabilities device_capabilities;
//    List<String> capabilities = new List<String>();
    for (int i = 0; i < devices["items"].length;i ++)
    {
      String deviceId;
      String label;
      //capabilities device_capabilities;
      List<String> capabilities = new List<String>();

      Components status;
//      st_devices_name.add(devices["items"][i]['name']);
    switch (devices["items"][i]['name'])
    {
      case "Arrival Sensor":
      {
        for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
        {
          capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
        }

        deviceId = devices["items"][i]["deviceId"];
        label = devices["items"][i]["label"];

        DevicesList.add(Device(devices["items"][i]['name'], "assets/arrival_sensor_st.jpg",capabilities,deviceId,label ,status, null,"","Disable",false));
      }
      break;
      case "SmartSense Motion Sensor":
        {
          for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
          {
            capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
          }

          deviceId = devices["items"][i]["deviceId"];
          label = devices["items"][i]["label"];
          DevicesList.add(Device(devices["items"][i]['name'], "assets/motion_sensor_st.png",capabilities,deviceId,label ,status,"Interior","motion","Disable",false));
        }
        break;
      case "Aeotec Siren (Gen 5)":
        {
          for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
          {
            capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
          }

          deviceId = devices["items"][i]["deviceId"];
          label = devices["items"][i]["label"];
          DevicesList.add(Device(devices["items"][i]['name'], "assets/siren_st.png",capabilities,deviceId,label ,status, null,"","Disable",false));
        }
        break;
      case "IKEA TRÅDFRI LED Bulb":
        {

          for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
          {
            capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
          }
          deviceId = devices["items"][i]["deviceId"];
          label = devices["items"][i]["label"];
          DevicesList.add(Device(devices["items"][i]['name'], "assets/ikea_smart_bulb.jpg",capabilities,deviceId,label ,status, null,"","Disable",false));
          DevicesList.add(Device(devices["items"][i]['name'], "assets/ikea_smart_bulb.jpg",capabilities,deviceId,label ,status, null,"","Disable",false));
          lights_card_info_list.clear();
          print(lights_card_info_list.length.toString());
          Color color = Colors.white;
          Color not_active_color = Colors.white;
          lights_card_info_list.add(AllLights(label,"","",false,deviceId,Icon(Icons.add_circle,color: Colors.grey),color,not_active_color));
          lights_card_info_list.add(AllLights(label,"","",false,deviceId,Icon(Icons.add_circle,color: Colors.grey),color,not_active_color));
          print(lights_card_info_list.length.toString());
          print("added 2 devices");
          //Device.lights_list();
          //Device.lights_list();
        }
        break;
//      case "SmartThings v3 Hub":
//        {
//          for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
//          {
//            capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
//          }
//          deviceId = devices["items"][i]["deviceId"];
//          label = devices["items"][i]["label"];
//          DevicesList.add(Device(devices["items"][i]['name'], "assets/st_v3_hub.jpg",capabilities,deviceId,label,status, null,"","Disable",false));
//        }
//        break;
      case "SmartSense Open/Closed Sensor":
        {
          for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
          {
            capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
          }
          deviceId = devices["items"][i]["deviceId"];
          label = devices["items"][i]["label"];
          DevicesList.add(Device(devices["items"][i]['name'], "assets/contact_sensor_st.jpg",capabilities,deviceId,label ,status, "Perimeter","contact","Disable",false));
        }
        break;
      case "Aeotec Key Fob":
        {
          for (int j = 0; j < devices["items"][i]["components"][0]["capabilities"].length;j ++)
          {
            capabilities.add(devices["items"][i]["components"][0]["capabilities"][j]["id"]);
          }
          deviceId = devices["items"][i]["deviceId"];
          label = devices["items"][i]["label"];
          DevicesList.add(Device(devices["items"][i]['name'], "assets/contact_sensor_st.jpg",capabilities,deviceId,label ,status, null,"","Disable",false));
        }
        break;
      default:
        break;
    }
      print("end in st_devices");
    }
  }
//  Future<Map> get_device_status(String device_id) async {
//    HttpClient client = new HttpClient();
//    String myUrl = "https://api.smartthings.com/v1/devices/" + device_id + "/status";
//    client.getUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
//      request.headers.add(HttpHeaders.authorizationHeader,
//          ""); //removeAll(HttpHeaders.acceptEncodingHeader);
//      return request.close(); //.timeout(const Duration(seconds: 8));
//    }).then((HttpClientResponse response) async {
//      print(response.headers.toString());
//      print(response.statusCode.toString());
//      var responseBody = await response.transform(utf8.decoder).join();
//      Map data = json.decode(responseBody);
//      print(data);
//      print(data);
//      //Device.st_devices(data);
//
//      for (int i = 0;i < Device.DevicesList.length;i ++)
//      {
//        Map dat = get_device_status(Device.DevicesList[i].deviceId.toString()) as Map;
//
//      }
//
//      var a = data["components"]["main"]["switch"]["value"];
//      return a;
//      //return data;
//    });
//
//  }
}
abstract class ListItem {}
