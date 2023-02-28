import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/SettingsMemory.dart';
import 'package:tcp_alarm_system/Classes/SettingsTrouble.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';

class LogMemory extends StatefulWidget {
  LogMemory();

  @override
  _LogMemoryState createState() => _LogMemoryState();
}

class _LogMemoryState extends State<LogMemory> {
  @override
  Widget build(BuildContext context) {
    return
        Row(
          children: <Widget>[
            Container(
              color: Colors.white70,
              height: 55,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: GlobalParameters.shortcuts.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCard(context, index))),
          ],
        );

//    return Center(
//      child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                      child: ListView.builder(
//                          scrollDirection: Axis.horizontal,
//                          shrinkWrap: true,
//                          itemCount: GlobalParameters.shortcuts.length,
//                          itemBuilder: (BuildContext context, int index) =>
//                              buildCard(context, index))),
//                ],
//              ),
//    );


  }
  Widget buildCard(BuildContext context, int index)
  {

    return Container(

          height: 55,
          width: 40,
          child: GestureDetector(
            onTap: () {
              switch(GlobalParameters.shortcuts[index].page)
              {
                case "trouble":
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          SettingsTrouble()), //randomly_light()
                    );
                  }
                  break;
                case "memory":
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          AlarmMemory()), //randomly_light()
                    );
                  }
                  break;
              }

            },
            child: Column(
              children: <Widget>[
                Text(GlobalParameters.shortcuts[index].value,
                  style: TextStyle(
                      fontSize: 17
                  ),),
                //Icon
                GlobalParameters.shortcuts[index].icon,//Icon(Icons.warning, color: Colors.orange, size: 35,)
                //Icon
              ],
            ),
          ),
        );
//                            Container(
//
//                              height: 55,
//                              child: GestureDetector(
//                                onTap: () {
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(builder: (context) =>
//                                        SettingsTrouble()), //randomly_light()
//                                  );
//                                },
//                                child: Column(
//                                  children: <Widget>[
//                                    Text(GlobalParameters.troubles.length.toString(),
//                                      style: TextStyle(
//                                          fontSize: 17
//                                      ),),
//                                    Icon(Icons.warning, color: Colors.orange, size: 35,)
//                                  ],
//                                ),
//                              ),
//                            ),



  }
}