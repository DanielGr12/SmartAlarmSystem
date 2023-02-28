import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Widgets/SettingSection.dart';
import 'package:tcp_alarm_system/Widgets/SettingsWidget.dart';

class SettingsPrivacy extends StatefulWidget {
  SettingsPrivacy();

  @override
  _SettingsPrivacyState createState() => _SettingsPrivacyState();
}

class _SettingsPrivacyState extends State<SettingsPrivacy> {
  List<SettingParameter> privacy_settings_parameters = [
    SettingParameter("System code","",Colors.white,false),
  ];
  @override
  Widget build(BuildContext context) {
    privacy_settings_parameters = [
      SettingParameter("System code","",Colors.white,false),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy"),
      ),
      body: SettingSection(options: privacy_settings_parameters),
    );
  }

}

class SettingsIsCodeValid extends StatefulWidget {
  SettingsIsCodeValid();

  @override
  _SettingsIsCodeValidState createState() => _SettingsIsCodeValidState();
}

class _SettingsIsCodeValidState extends State<SettingsIsCodeValid> {
  int tries_num = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter system code"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Enter the system code",style: TextStyle(
            fontSize: 30
          ),),
          Text("You have ${tries_num} more tries",style: TextStyle(
              fontSize: 30
          ),),
          Container(
            child: TextField(
              maxLength: 4,
              onSubmitted: (val){
                if (val == GlobalParameters.user_default_code)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SettingsIsCodeValid()), //randomly_light()
                  );
                }
                else
                {
                  setState(() {
                    tries_num --;
                  });
                  if (tries_num == 0)
                    {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            SettingsCode()), //randomly_light()
                      );
                    }
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          //titlePadding: EdgeInsets.all(0),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20),
                          ),//+ Border.all(color: Colors.white),///contentPadding: EdgeInsets.all(0.0),
                          title: Container(
                              height: 70.00,
                              width: 70.00,
                              child: Text("Invalid code!!!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                          ),
                        );
                      }

                  );
                }
              },
              obscureText: true,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                //hintText: 'Enter default code',
                helperText: 'Enter the system code',
                //labelText: 'Enter default code, current: ' + GlobalParameters.user_default_code,
                prefixIcon: const Icon(
                  Icons.security,
                  color: Colors.orangeAccent,
                ),
//          prefixText: ' ',
//          suffixText: 'USD',
//          suffixStyle: const TextStyle(color: Colors.green)),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {

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
            ),
          ),
        ],
      ),
    );
  }

}

class SettingsCode extends StatefulWidget {
  SettingsCode();

  @override
  _SettingsCodeState createState() => _SettingsCodeState();
}

class _SettingsCodeState extends State<SettingsCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("System code"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:20),
            child: TextField(
            maxLength: 4,
            obscureText: true,
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              //hintText: 'Enter default code',
              helperText: 'The code to the system',
              labelText: 'Enter default code, current: ' + GlobalParameters.user_default_code,
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
            ),
          ),
        ],
      ),
    );
  }

}