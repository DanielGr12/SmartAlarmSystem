//import 'package:tcp_alarm_system/Classes/log.dart';
import 'package:tcp_alarm_system/Globals/GlobalParameters.dart';

import '../Classes/log.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class LastEventWidget extends StatefulWidget
{
  @override
  _LastEventState createState() => _LastEventState();
}

class _LastEventState  extends State<LastEventWidget>
{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return last_event_widget(context);
  }

  Widget last_event_widget(BuildContext context)
  {
    //getDir();
    if (LogEvent.LogEvents.length > 0)
    {
      int cell = LogEvent.LogEvents.length-1;
      return Card(
        elevation: 0,
        color: Colors.white60,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              title: Text("Last event"),
              trailing: GestureDetector(
                child: Text(
                  'Show all events >',
                  style: TextStyle(
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                onTap: (){
                  setState(() {
                     GlobalParameters.tab_controller.index = 1;
                  });
                }
              ),
            ),
            new Divider(color: Colors.blue,indent: 16.0),
            new ListTile(
                title: Text(LogEvent.LogEvents[cell].event_name.toString()),//
                trailing:
                GestureDetector(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: LogEvent.LogEvents.length > 0 ? small_picture() : Text(""),//Image.asset("assets/keyfob.jpg", fit: BoxFit.cover),
//                    Image.file(
//                      File("assets/keyfob.jpg"),
//                      fit: BoxFit.cover,
//                      //width: 600.0,
//                      //height: 290.0
//                    ),


//                    LogEvent.LogEvents.length > 0 ? small_picture() : Text(""),//LogEvent.LogEvents[0].has_image == true ?
                    //Text("Image is here")

                  ),
                  onTap:(){
                    int cell = LogEvent.LogEvents.length-1;
                    String _image = LogEvent.LogEvents[cell].event_image_path;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: EdgeInsets.all(0),

                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20),
                            ),//+ Border.all(color: Colors.white),///contentPadding: EdgeInsets.all(0.0),
//                            decoration: new BoxDecoration(
//                              shape: BoxShape.rectangle,
//                              color: const Color(0xFFFFFF),
//                              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
//                            ),
                            title: Container(

                              height: 300.00,
                              width: 300.00,
//                              decoration: BoxDecoration(
//                                color: Colors.redAccent,
//                                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
//                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.file(File(_image),fit: BoxFit.fill),
                              ),


                            ),

//                            //contentPadding: EdgeInsets.all(0.0),
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.all(Radius.circular(32.0))
//                            ),
//                            //BorderRadius.all(Radius.circular(20.0))
//                            //title: Text(""),
//                            content: Image.file(File(_image),fit: BoxFit.fill),
                          );
                        }
                    );


                  } ,
                )
              //Image.asset("assets/keyfob.jpg", fit: BoxFit.cover),
              //width: 600.0,
              //height: 290.0


            )
          ],
        ),
      );
    }
    return Text("");
  }
  Widget small_picture()
  {
    int cell = LogEvent.LogEvents.length-1;

    if (LogEvent.LogEvents[cell].has_image == true)
    {
      String _image = LogEvent.LogEvents[cell].event_image_path;
      print(LogEvent.LogEvents[cell].event_image_path);
      return //loadImageFromFile(_image);
        //Image.asset("assets/keyfob.jpg", fit: BoxFit.cover);
        ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.file(File(_image),fit: BoxFit.fill)
        );
      Image.file(File(_image),fit: BoxFit.cover);

    }



    // : null,
//                              LogEvent.LogEvents[0].has_image == true ? //Text("Image is here")
//                              Image.file(
//                                File(LogEvent.LogEvents[0].event_image_path),
//                                fit: BoxFit.cover,
//                                //width: 600.0,
//                                //height: 290.0
//                              ) : null,
  }






}