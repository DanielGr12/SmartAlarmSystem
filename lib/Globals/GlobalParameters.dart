import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';

class GlobalParameters
{
  static List<String> notReadyParts = new List<String>();
  static List<String> ByPassList = new List<String>();

  static String entrySelectedLocation = "Disabled";
  static String exitSelectedLocation = "Disabled";
  static String chimeSelectedLocation = "Disabled";
  static bool is_chime_enabled = false;
  static String sirenSelectedLocation = "";
  static bool TurnOnLightSelectedLocation_or_not = false;
  //static Map<String,Map<TimeOfDay,TimeOfDay>> TurnOnLightList = new Map<String,Map<TimeOfDay,TimeOfDay>>();
  static String SelectedLightTime;
  static String SelectedLightBulb;
  static String TurnOnLightSelectedLocation = "Disabled";
  static int current_delay_time = 0;
  static String user_default_code = "1111";
  static var documentDirectory;
  static TabController tab_controller;
  static Text contact_state = Text("Closed",
    style: TextStyle(
        color: Colors.green
    ),
  );
  static Text keyfob_last_event = Text("",);
  static Text pir_event = Text("",);
  static bool bypass_or_not = false;
  static String current_light_switch;
  static Color light_icon_color;
  static String selected_range_time = "1 hour";
  static String selected_chime_option = "";
  static bool is_exit_delay_time = false;
  static bool is_entry_delay_time = false;
  static String selected_low_battery_percent = "20%";
  static List<TroubleCell> troubles = new List<TroubleCell>();
  static List<Memory> memory = new List<Memory>();
  static List<MainShourtcut> shortcuts = new List<MainShourtcut>();
  static List<Sections> devices_sections = new List<Sections>();
  static Device selected_section_device;
  static List<Device> LastDevicesList = new List<Device>();
  static List<Device> LastNotUpdatedDevicesList = new List<Device>();
  static String last_contact_device_val;
  static String last_pir_device_val;
  static bool last_device_update = false;
  static String DeviceDelayexitSelectedLocation = "15";
  static bool entry_delay_time = false;
  static List<Device> SortedDevicesList = new List<Device>();
  static List<Device> contact_devices = new List<Device>();
  static List<Device> pir_devices = new List<Device>();
  static List<Device> arrival_devices = new List<Device>();
  static List<Device> siren_devices = new List<Device>();
  static List<Device> light_devices = new List<Device>();
  static List<Device> keyfob_devices = new List<Device>();
//  final Color back_color = _colorFromHex("f7f7f7");
}
class Sections
{
  String section_name;
  Icon icon;
  Sections(this.section_name,this.icon);
}
class Memory
{
  String detector_name;
  Icon icon;
  Memory(this.detector_name,this.icon);
}
class TroubleCell
{
  String name;
  Icon icon;
  String event;
  TroubleCell(this.name,this.icon,this.event);
}
class MainShourtcut
{
  String value;
  Icon icon;
  String page;
  MainShourtcut(this.value,this.icon,this.page);
}
class AllLights
{
  String name;
  String id;
//  //String device_id;
//  TimeOfDay start_time;
//  TimeOfDay end_time;
  String str_selectedStartTime = "";
  String str_selectedEndTime = "";
  bool checkbox_val;
  Icon icon;// = Icon(Icons.add);
  Color icon_color = Colors.grey;// = Colors.grey[400];
  Color active_or_not_color = Colors.white70;//green[200]
  AllLights(this.name,this.str_selectedStartTime,this.str_selectedEndTime,this.checkbox_val,this.id,this.icon,this.icon_color,this.active_or_not_color);
}
class RandomLight
{
  String name;
  String device_id;
  TimeOfDay start_time;
  TimeOfDay end_time;
  bool turn_on_first_time = true;
  bool turn_off_first_time = true;
  bool change_time_today = true;
  //String str_selectedStartTime = "";
  //String str_selectedEndTime = "";
  //bool checkbox_val;
  RandomLight(this.name, this.start_time, this.end_time,this.device_id);
}
class SelectOptions
{
  String text;
  bool is_selected;
  SelectOptions(this.text,this.is_selected);
}
class SettingParameter
{
  String text;
  String selected;
  Color current_color;
  bool show_icon;
  Icon icon;
  SettingParameter(this.text,this.selected,this.current_color,this.show_icon,[this.icon]);
}