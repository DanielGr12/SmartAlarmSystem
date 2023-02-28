
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Classes/log.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';

class ContactStatus {
  Components components;

  ContactStatus({this.components});

  ContactStatus.fromJson(Map<String, dynamic> json) {
    components = json['components'] != null ? new Components.fromJson(json['components']) : null;
  }


}

enum CapabilitiesEnum {
  contactSensor,
  checkInterval,
  temperatureMeasurement,
  battery,
  presenceSensor,
  signalStrength,
  alarm,
  switchProcess,
  motionSensor,
  light,
  colorTemperature,
  switchLevel,
  button1,
  button2,
  button3,
  button4
}

class Components {
  Main main;
  Button_func button4;
  Button_func button2;
  Button_func button3;
  Button_func button1;




  Components({this.main,this.button1,this.button2,this.button3,this.button4});

  Components.fromJson(Map<String, dynamic> json) {
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;




    //TODO: doesn't needs to be here(move to a place with status(id,label))
    //String str_low_battery_precentege = GlobalParameters.selected_low_battery_percent.replaceAll("%","");
//    int low_battery_precentege = int.parse(str_low_battery_precentege);
//    if (main.battery.battery.value <= low_battery_precentege)
//    {
//      //TODO: send notification
//      DateTime now = new DateTime.now();
//      String formattedDate = DateFormat('yyyy.MM.dd , HH:mm:ss ').format(now);
//      var my_log_key = UniqueKey();
//      LogEvent event = new LogEvent(formattedDate, "Low battery to ${main..label}", my_log_key, false,"");
//      LogEvent.LogEvents.add(event);
//
//    }




    button1 = json['button1'] != null ? new Button_func.fromJson(json['button1']) : null;
    button2 = json['button2'] != null ? new Button_func.fromJson(json['button2']) : null;
    button3 = json['button3'] != null ? new Button_func.fromJson(json['button3']) : null;
    button4 = json['button4'] != null ? new Button_func.fromJson(json['button4']) : null;
    //main = new Main.fromJson(json["components"]['main']);


  }

  int getCapabilitiesLength(){
    int count = 0;
    CapabilitiesEnum.values.forEach((name) {
      count++;
    });
    return count;
    //https://stackoverflow.com/questions/13899928/does-dart-support-enumerations
    //// get all the values of the enums
    //  for (List<Fruit> value in Fruit.values) {
    //    print(value);
    //  }
  }
  Icon device_icons(int index)
  {
    switch(CapabilitiesEnum.values[index])
    {

      case CapabilitiesEnum.contactSensor:
        return Icon(Icons.security);
        break;
      case CapabilitiesEnum.checkInterval:
        return Icon(Icons.timer);
        break;
      case CapabilitiesEnum.temperatureMeasurement:
        return Icon(Icons.cloud);
        break;
      case CapabilitiesEnum.battery:
        return Icon(Icons.battery_full);
        break;
      case CapabilitiesEnum.presenceSensor:
        return Icon(Icons.security);
        break;
      case CapabilitiesEnum.signalStrength:
        return Icon(Icons.wifi);
        break;
      case CapabilitiesEnum.alarm:
        return Icon(Icons.surround_sound);
        break;
      case CapabilitiesEnum.switchProcess:
        return Icon(Icons.swap_vert);
        break;
      case CapabilitiesEnum.motionSensor:
        return Icon(Icons.security);
        break;
      case CapabilitiesEnum.light:
        return Icon(Icons.lightbulb_outline);
        break;
      case CapabilitiesEnum.colorTemperature:
        return Icon(Icons.color_lens);
        break;
      case CapabilitiesEnum.switchLevel:
        return Icon(Icons.swap_horiz);
        break;
      case CapabilitiesEnum.button1:
        return Icon(Icons.security);
        break;
      case CapabilitiesEnum.button2:
        return Icon(Icons.security);
        break;
      case CapabilitiesEnum.button3:
        return Icon(Icons.security);
        break;
      case CapabilitiesEnum.button4:
        return Icon(Icons.security);
        break;
    }
  }
  String status_values(int index)
  {
    switch(CapabilitiesEnum.values[index])
    {

      case CapabilitiesEnum.contactSensor:
        String value = main.contactSensor.contact.value != null ? main.contactSensor.contact.value : "";
        return value;
        break;
      case CapabilitiesEnum.checkInterval:
        String value = main.healthCheck.checkInterval.value != null ? main.healthCheck.checkInterval.value.toString() + main.healthCheck.checkInterval.unit : "";
        return value;
        break;
      case CapabilitiesEnum.temperatureMeasurement:
        String degree = get_degree_symbol();
        String value = main.temperatureMeasurement.temperature.value != null ? main.temperatureMeasurement.temperature.value.toString() + degree : "";
        return value;
        break;
      case CapabilitiesEnum.battery:
        String value = main.battery.battery.value != null ? main.battery.battery.value.toString() + main.battery.battery.unit : "";
        return value;
        break;
      case CapabilitiesEnum.presenceSensor:
        String value = main.presenceSensor.presence.value != null ? main.presenceSensor.presence.value : "";
        return value;
        break;
      case CapabilitiesEnum.signalStrength:
        String value = main.signalStrength.rssi.value != null ? main.signalStrength.rssi.value.toString() + main.signalStrength.rssi.unit : "";
        return value;
        break;
      case CapabilitiesEnum.alarm:
        String value = main.alarm.alarm.value != null ? main.alarm.alarm.value : "";
        return value;
        break;
      case CapabilitiesEnum.switchProcess:
        String value = main.switchProcess.value != null ? main.switchProcess.value : "";
        return value;
        break;
      case CapabilitiesEnum.motionSensor:
        String value = main.motionSensor.motion.value != null ? main.motionSensor.motion.value.toString() : "";
        return value;
        break;
      case CapabilitiesEnum.light:
        String value = main.light.switch_process.value != null ? main.light.switch_process.value.toString() : "";
        return value;
        break;
      case CapabilitiesEnum.colorTemperature:
        String value = main.colorTemperature.value != null ? main.colorTemperature.value.toString() + main.colorTemperature.unit : "";
        return value;
        break;
      case CapabilitiesEnum.switchLevel:
        String value = main.switchLevel.level.value != null ? main.switchLevel.level.value.toString() + main.switchLevel.level.unit  : "";
        return value;
        break;
      case CapabilitiesEnum.button1:
        String value = main.button.button.value != null ? main.button.button.value : "";
        return value;
        break;
      case CapabilitiesEnum.button2:
        String value = main.button.button.value != null ? main.button.button.value : "";
        return value;
        break;
      case CapabilitiesEnum.button3:
        String value = main.button.button.value != null ? main.button.button.value : "";
        return value;
        break;
      case CapabilitiesEnum.button4:
        String value = main.button.button.value != null ? main.button.button.value : "";
        return value;
        break;
    }
  }
  String get_degree_symbol()
  {
    String degree_type = "";
    switch(main.temperatureMeasurement.temperature.unit)
    {
      case 'C':
        degree_type = " \u2103";
        break;
      case 'F':
        degree_type = " \u2109";
        break;
      case 'K':
        degree_type = " \u212A";
        break;
      case 'R':
        degree_type = " \u00B0R";
        break;
      default:
        degree_type = "";
        break;
    }
    return degree_type;
  }
  bool getSupportedCapabilities(int index,Device device)
  {
    switch(CapabilitiesEnum.values[index])
    {
      case CapabilitiesEnum.contactSensor:
        if(main.contactSensor != null)
          return true;
        break;
      case CapabilitiesEnum.checkInterval:
        if(main.healthCheck != null)
        {
          if (device.name != "IKEA TRÅDFRI LED Bulb")
            return true;
        }

        break;
      case CapabilitiesEnum.temperatureMeasurement:
        if(main.temperatureMeasurement != null)
          return true;
        break;
      case CapabilitiesEnum.battery:
        if(main.battery != null)
          return true;
        break;
      case CapabilitiesEnum.presenceSensor:
        if(main.presenceSensor != null)
          return true;
        break;
      case CapabilitiesEnum.signalStrength:
        if(main.signalStrength != null)
          return true;
        break;
      case CapabilitiesEnum.alarm:
        if(main.alarm != null)
          return true;
        break;
      case CapabilitiesEnum.switchProcess:
        if(main.switchProcess != null)
          return true;
        break;
      case CapabilitiesEnum.motionSensor:
        if(main.motionSensor != null)
          return true;
        break;
      case CapabilitiesEnum.light:
        if(main.light != null)
        {

          if (device.name != "IKEA TRÅDFRI LED Bulb")
            return true;
        }

        break;
      case CapabilitiesEnum.colorTemperature:
        if(main.colorTemperature != null)
          return true;
        break;
      case CapabilitiesEnum.switchLevel:
        if(main.switchLevel != null)
          return true;
        break;
      case CapabilitiesEnum.button1:
        if(button1 != null)
          return true;
        break;
      case CapabilitiesEnum.button2:
        if(button2 != null)
          return true;
        break;
      case CapabilitiesEnum.button3:
        if(button3 != null)
          return true;
        break;
      case CapabilitiesEnum.button4:
        if(button4 != null)
          return true;
        break;
      default:
        return false;
        break;
    }

    return false;

  }


  String getCapabilitieName(int index)
  {
    switch(CapabilitiesEnum.values[index])
    {
      case CapabilitiesEnum.contactSensor:
          return 'Contact Sensor';
        break;
      case CapabilitiesEnum.checkInterval:
          return 'Check Interval';
        break;
      case CapabilitiesEnum.temperatureMeasurement:
          return 'Temperature';
        break;
      case CapabilitiesEnum.battery:
          return 'Battery';
        break;
      case CapabilitiesEnum.presenceSensor:
          return 'Presence Sensor';
        break;
      case CapabilitiesEnum.signalStrength:
          return 'Signal Strength';
        break;
      case CapabilitiesEnum.alarm:
          return 'Alarm';
        break;
      case CapabilitiesEnum.switchProcess:
          return 'Switch';
        break;
      case CapabilitiesEnum.motionSensor:
          return 'Motion Sensor';
        break;
      case CapabilitiesEnum.light:
          return 'Light';
        break;
      case CapabilitiesEnum.colorTemperature:
          return 'Color Temperature';
        break;
      case CapabilitiesEnum.switchLevel:
          return 'Dimmer';
        break;
      case CapabilitiesEnum.button1:
          return 'button 1';
        break;
      case CapabilitiesEnum.button2:
          return 'button 2';
        break;
      case CapabilitiesEnum.button3:
          return 'button 3';
        break;
      case CapabilitiesEnum.button4:
          return 'button 4';
        break;
      default:
        return null;
        break;
    }


  }

}

class Main {
  ContactSensor contactSensor;
  HealthCheck healthCheck;
  TemperatureMeasurement temperatureMeasurement;
  BatteryMeasurement battery;
  PresenceSensor presenceSensor;
  SignalStrength signalStrength;
  AlarmSignal alarm;
  Switch switchProcess;
  MotionSensor motionSensor;
  Light light;
  Level colorTemperature;
  SwitchLevel switchLevel;
  Button_func button;



  Main({this.contactSensor, this.healthCheck, this.temperatureMeasurement, this.battery});

  Main.fromJson(Map<String, dynamic> json) {
    contactSensor = json['contactSensor'] != null ? new ContactSensor.fromJson(json['contactSensor']) : null;
    healthCheck = json['healthCheck'] != null ? new HealthCheck.fromJson(json['healthCheck']) : null;
    temperatureMeasurement = json['temperatureMeasurement'] != null ? new TemperatureMeasurement.fromJson(json['temperatureMeasurement']) : null;
    battery = json['battery'] != null ? new BatteryMeasurement.fromJson(json['battery']) : null;
    presenceSensor = json['presenceSensor'] != null ? new PresenceSensor.fromJson(json['presenceSensor']) : null;
    signalStrength = json['signalStrength'] != null ? new SignalStrength.fromJson(json['signalStrength']) : null;
    alarm = json['alarm'] != null ? new AlarmSignal.fromJson(json['alarm']) : null;
    switchProcess = json['switch'] != null ? new Switch.fromJson(json['switch']) : null;
    motionSensor = json['motionSensor'] != null ? new MotionSensor.fromJson(json['motionSensor']) : null;
    colorTemperature = json['colorTemperature'] != null ? new Level.fromJson(json['colorTemperature']) : null;
    switchLevel = json['switchLevel'] != null ? new SwitchLevel.fromJson(json['switchLevel']) : null;
    light = json['light'] != null ? new Light.fromJson(json['light']) : null;
    //button = json['button'] != null ? new Button_func.fromJson(json['button']) : null;
  }
}

class ContactSensor {
  Contact contact;

  ContactSensor({this.contact});

  ContactSensor.fromJson(Map<String, dynamic> json) {
    contact = new Contact.fromJson(json['contact']);
  }

}

class Contact {
  String value;
  String name = 'Contact';
  Contact({this.value});

  Contact.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

}


class HealthCheck {
  CheckInterval checkInterval;

  HealthCheck({this.checkInterval});

  HealthCheck.fromJson(Map<String, dynamic> json) {
    checkInterval = new CheckInterval.fromJson(json['checkInterval']);
//    healthStatus = json['healthStatus'] != null ? new HealthStatus.fromJson(json['healthStatus']) : null;
//    deviceWatchEnroll = json['DeviceWatch-Enroll'] != null ? new DeviceWatchEnroll.fromJson(json['DeviceWatch-Enroll']) : null;
//    deviceWatchDeviceStatus = json['DeviceWatch-DeviceStatus'] != null ? new HealthStatus.fromJson(json['DeviceWatch-DeviceStatus']) : null;
  }
}

class CheckInterval {
  int value;
  String unit;

  CheckInterval({this.value, this.unit});

  CheckInterval.fromJson(Map<String, dynamic> json) {
    value = json['value'] as int;
    unit = json['unit'];
    //data = json['data'] != null ? new Configuration.fromJson(json['data']) : null;
  }

}



class TemperatureMeasurement {
  Temperature temperature;

  TemperatureMeasurement({this.temperature});

  TemperatureMeasurement.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'] != null ? new Temperature.fromJson(json['temperature']) : null;


  }
}

class Temperature {
  int value;
  String unit;

  Temperature({this.value, this.unit});

  Temperature.fromJson(Map<String, dynamic> json) {
    value = json['value'] as int;
    unit = json['unit'];
  }


}

class BatteryMeasurement {
  Battery battery;

  BatteryMeasurement({this.battery});

  BatteryMeasurement.fromJson(Map<String, dynamic> json) {
    battery = json['battery'] != null ? new Battery.fromJson(json['battery']) : null;
  }
}


class Battery {
  int value;
  String unit;

  Battery({this.value, this.unit});

  Battery.fromJson(Map<String, dynamic> json) {
    value = json['value'] as int;
    unit = json['unit'];
  }


}
class PresenceSensor {
  Presence presence;

  PresenceSensor({this.presence});

  PresenceSensor.fromJson(Map<String, dynamic> json) {
    presence = json['presence'] != null ? new Presence.fromJson(json['presence']) : null;
  }
}

class Presence {
  String value;

  Presence({this.value});

  Presence.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }
}

class SignalStrength {
  Rssi rssi;
  Lqi lqi;

  SignalStrength({this.rssi, this.lqi});

  SignalStrength.fromJson(Map<String, dynamic> json) {
    rssi = json['rssi'] != null ? new Rssi.fromJson(json['rssi']) : null;
    lqi = json['lqi'] != null ? new Lqi.fromJson(json['lqi']) : null;
  }

}

class Rssi {
  int value;
  String unit;

  Rssi({this.value, this.unit});

  Rssi.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    unit = json['unit'];
  }

}

class Lqi {
  int value;

  Lqi({this.value});

  Lqi.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

}

class AlarmSignal {
  Alarm alarm;

  AlarmSignal({this.alarm});

  AlarmSignal.fromJson(Map<String, dynamic> json) {
    alarm = json['alarm'] != null ? new Alarm.fromJson(json['alarm']) : null;
  }


}

class Alarm {
  String value;

  Alarm({this.value});

  Alarm.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }


}



class SwitchSignal {
  Switch switch_process;

  SwitchSignal({this.switch_process});

  SwitchSignal.fromJson(Map<String, dynamic> json) {
    switch_process = json['switch'] != null ? new Switch.fromJson(json['switch']) : null;
  }
}

class Switch {
  String value;

  Switch({this.value});

  Switch.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }
}
class MotionSensor {
  Motion motion;

  MotionSensor({this.motion});

  MotionSensor.fromJson(Map<String, dynamic> json) {
    motion = json['motion'] != null ? new Motion.fromJson(json['motion']) : null;
  }
}

class Motion {
  String value;

  Motion({this.value});

  Motion.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }
}
class Light {
  Switch switch_process;

  Light({this.switch_process});

  Light.fromJson(Map<String, dynamic> json) {
    switch_process = json['switch'] != null ? new Switch.fromJson(json['switch']) : null;
  }

}
class SwitchLevel {
  Level level;

  SwitchLevel({this.level});

  SwitchLevel.fromJson(Map<String, dynamic> json) {
    level = json['level'] != null ? new Level.fromJson(json['level']) : null;
  }
}

class Level {
  int value;
  String unit;

  Level({this.value, this.unit});

  Level.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    unit = json['unit'];
  }
}

class ColorTemperature {
  Level colorTemperature;

  ColorTemperature({this.colorTemperature});

  ColorTemperature.fromJson(Map<String, dynamic> json) {
    colorTemperature = json['colorTemperature'] != null ? new Level.fromJson(json['colorTemperature']) : null;
  }
}

//class Button_func {
//  Button button;
//  HoldableButton holdableButton;
//  Sensor sensor;
//
//  Button4({this.button, this.holdableButton, this.sensor});
//
//  Button4.fromJson(Map<String, dynamic> json) {
//    button = json['button'] != null ? new Button.fromJson(json['button']) : null;
//    holdableButton = json['holdableButton'] != null ? new HoldableButton.fromJson(json['holdableButton']) : null;
//    sensor = json['sensor'] != null ? new Sensor.fromJson(json['sensor']) : null;
//  }
//}

class Button_func {
  Button button;

  Button_func({this.button});

  Button_func.fromJson(Map<String, dynamic> json) {
    button = json['button'] != null ? new Button.fromJson(json['button']['button']) : null;
  }
}

class Button {
  String value;

  Button({this.value});

  Button.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }
}



//////////////////////////////////////////////////////////////////////////
// send commands                                                      ////
//////////////////////////////////////////////////////////////////////////



class DimmerCommand {
  List<Commands> commands;

  DimmerCommand({this.commands});

  DimmerCommand.fromJson(Map<String, dynamic> json) {
    if (json['commands'] != null) {
      commands = new List<Commands>();
      json['commands'].forEach((v) {
        commands.add(new Commands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commands != null) {
      data['commands'] = this.commands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commands {
  String component;
  String capability;
  String command;
  List<int> arguments;

  Commands({this.component, this.capability, this.command, this.arguments});

  Commands.fromJson(Map<String, dynamic> json) {
    component = json['component'];
    capability = json['capability'];
    command = json['command'];
    arguments = json['arguments'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['component'] = this.component;
    data['capability'] = this.capability;
    data['command'] = this.command;
    data['arguments'] = this.arguments;
    return data;
  }
}
class SwitchLight {
  List<LightCommands> commands;

  SwitchLight({this.commands});

  SwitchLight.fromJson(Map<String, dynamic> json) {
    if (json['commands'] != null) {
      commands = new List<LightCommands>();
      json['commands'].forEach((v) {
        commands.add(new LightCommands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commands != null) {
      data['commands'] = this.commands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LightCommands {
  String component;
  String capability;
  String command;
  List<int> arguments;

  LightCommands({this.component, this.capability, this.command, this.arguments});

  LightCommands.fromJson(Map<String, dynamic> json) {
    component = json['component'];
    capability = json['capability'];
    command = json['command'];
    if (json['arguments'] != null) {
      arguments = new List<Null>();
      json['arguments'].forEach((v) {
        //arguments.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['component'] = this.component;
    data['capability'] = this.capability;
    data['command'] = this.command;
    if (this.arguments != null) {
//      data['arguments'] = this.arguments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChangeColorTemperature {
  List<Commands> commands;

  ChangeColorTemperature({this.commands});

  ChangeColorTemperature.fromJson(Map<String, dynamic> json) {
    if (json['commands'] != null) {
      commands = new List<Commands>();
      json['commands'].forEach((v) {
        commands.add(new Commands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commands != null) {
      data['commands'] = this.commands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class SirenCommand {
  List<Commands> commands;

  SirenCommand({this.commands});

  SirenCommand.fromJson(Map<String, dynamic> json) {
    if (json['commands'] != null) {
      commands = new List<Commands>();
      json['commands'].forEach((v) {
        commands.add(new Commands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commands != null) {
      data['commands'] = this.commands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}