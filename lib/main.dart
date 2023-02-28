import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcp_alarm_system/Classes/DevicesInfo.dart';
import 'package:tcp_alarm_system/Classes/LogMemory.dart';
import 'package:tcp_alarm_system/Classes/SettingsTrouble.dart';
import 'package:tcp_alarm_system/Classes/WorkDiagnostics.dart';
import 'package:tcp_alarm_system/Widgets/DevicesWidget.dart';
import 'package:tcp_alarm_system/Classes/DeviceDatabase.dart';
import 'package:tcp_alarm_system/Widgets/LogEventWidgets.dart';
import 'Classes/log.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'; // show get;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:quiver/async.dart';
import 'Widgets/ArmDisarmButton.dart';
import 'Globals/GlobalParameters.dart';
import 'Widgets/NotReadyEventsWidget.dart';
import 'Widgets/SettingsWidget.dart';
import 'Widgets/LastEventWidget.dart';
Socket receiver_socket;
Socket receiver_test_socket;
Socket keypad_socket;
var client = Client();
CountdownTimer countDownTimer;
String RX_DATA_RECEIVER = "";
String RX_DATA_KEYPAD = "";
var sub;

final username = 'ENTER YOUR USERNAME';
final password = 'ENTER YOUR PASSWORD';
final credentials = '$username:$password';
final stringToBase64 = utf8.fuse(base64);
final encodedCredentials = stringToBase64.encode(credentials);
Map<String, String> headers = {
  HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
  HttpHeaders.hostHeader: '10.0.0.21',
};
enum CallingSource {
  keyfob,
  keypad,
  smartphone_button
}
enum AlarmCallingSource {
  contact,
  pir
}
List<String> wallpapers_list = new List<String>();
String current_wallpaper = "assets/image6.jpg";
void main() async {
  Socket sock;
  //Socket sock = await Socket.connect('10.0.0.11', 10001);
  //print(sock.toString());
  runApp(MyApp(sock));
}

class MyApp extends StatelessWidget {
  Socket socket;

  MyApp(Socket s) {
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {
    final title = 'TcpSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: socket,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Socket channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //static const duration = const Duration(seconds: 1);
  int secondsPassed = 0;

//  bool isActive = false;
//  Timer timer;
//  int seconds = 0;
//  //secondsPassed % 60
//  LabelText time_label;
//  = new LabelText(
//  label: "SEC",value: seconds.toString().padLeft(2,'0')//"",value: "",//
//  );
  //bool enable_timer = false;

  SnackBar snackBar = new SnackBar(
    content: Text(""),
  );

  //final client = new HttpClient();
  //client.connectionTimeout = const Duration(seconds: 10);

  //client.connectionTimeout = const Duration(seconds: 10);

  TextEditingController _controller = TextEditingController();
  String RX_data;

  //UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];

  //zeev StreamSubscription<String> _subscription;
  //Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

///////////////////////////
  //List<String> notReadyParts = new List<String>();
  bool ready_not_ready = true;

  //String current_state = "Disarm,Ready";
  String ready_state = "Ready";
  String arm_state = "Disarm";
  String notReadyParts_text = "";
  Icon current_icon = Icon(
    Icons.lock_open,
    color: Colors.lightGreen,
    size: 76,
  );
  String current_speak_text = "";
  String alarm_state = "";
//  Text contact_state = Text("Closed",
//    style: TextStyle(
//        color: Colors.green
//    ),
//  );
  Color alarm_current_color = Colors.green;

  //TabController tab_controller;
  bool ding_dong_switch = false;
  //List<LogEvent> LogEvents = new List<LogEvent>();
  List<DropdownMenuItem<int>> listDrop = [];

  TextEditingController customController = TextEditingController();
  final List<MyTabs> _tabs = [
    new MyTabs(title: "Home screen", color: Colors.green),
    new MyTabs(title: "Log events", color: Colors.indigo),
    new MyTabs(title: "Settings", color: Colors.blueAccent[200]),
    new MyTabs(title: "Devices", color: Colors.orangeAccent[200]),
    new MyTabs(title: "Cameras", color: Colors.deepPurple)
  ];
  MyTabs _myHandler;

  String imageDataPath;
  //var filePathAndName;
  String filePathImagesDirectory;
  bool dataLoaded = false;
  String user_code = "";
  //String user_default_code = "0000";
  String splitted_time = "";
  //int current_delay_time = 0;
  List<FileSystemEntity> pictures_pathes = new List<FileSystemEntity>();
  int path_index = 0;

  Future getDir() async {
    GlobalParameters.documentDirectory = await getApplicationDocumentsDirectory();
    //print(appDir.path);
  }


  void initState() {
    var receiver_adress = new InternetAddress('10.0.0.12');
    var keypad_adress = new InternetAddress('10.0.0.11');
    var receiver_test_adress = new InternetAddress('10.0.0.10');
    int port = 10001;

    super.initState();

    deleteAllImages();

    getDir();

    GlobalParameters.tab_controller = new TabController(vsync: this, length: 5);
    _myHandler = _tabs[0];
    GlobalParameters.tab_controller.addListener(_handleSelected);

    Socket.connect(receiver_adress, port).then((Socket sock) {
      receiver_socket = sock;
      receiver_socket.listen(dataHandlerReceiver,
          onError: errorHandlerReceiver,
          onDone: doneHandlerReceiver,
          cancelOnError: false);
    });

    Socket.connect(receiver_test_adress, port).then((Socket sock) {
      receiver_test_socket = sock;
      receiver_test_socket.listen(dataHandlerKeypad,
          onError: errorHandlerKeypad,
          onDone: doneHandlerKeypad,
          cancelOnError: false);
    });

    Socket.connect(keypad_adress, port).then((Socket sock) {
      keypad_socket = sock;
      keypad_socket.listen(dataHandlerKeypad,
          onError: errorHandlerKeypad,
          onDone: doneHandlerKeypad,
          cancelOnError: false);
    });

    wallpapers_list.add("assets/image1.jpg");
    wallpapers_list.add("assets/image4.jpg");
    wallpapers_list.add("assets/image6.jpg");
    wallpapers_list.add("assets/image8.jpg");
    wallpapers_list.add("assets/image9.jpg");
    wallpapers_list.add("assets/image11.jpg");
    wallpapers_list.add("assets/background2.jpg");
    wallpapers_list.add("assets/background3.jpg");
    wallpapers_list.add("assets/background4.jpg");
    wallpapers_list.add("assets/background8.jpg");
    wallpapers_list.add("assets/background9.jpg");
    wallpapers_list.add("assets/background11.jpg");
    wallpapers_list.add("assets/image20.jpg");
    wallpapers_list.add("assets/image20.jpg");
    wallpapers_list.add("assets/image20.jpg");
    //var client = Client();
    //_st_get_devices() as Map;

    //_st_get_devices();
    //_st_get_devices_test();
    st_collect_all_devices_status();
    //st_collect_all_devices_status();


    //GlobalParameters.shortcuts.add(MainShourtcut(GlobalParameters.troubles.length.toString(),Icon(Icons.warning,color: Colors.orange,size: 35),"trouble"));

    GlobalParameters.memory.add(Memory("Contact",Icon(Icons.business)));
    GlobalParameters.memory.add(Memory("PIR",Icon(Icons.directions_walk)));
    GlobalParameters.shortcuts.add(MainShourtcut(GlobalParameters.memory.length.toString(),Icon(Icons.notifications_active,color: Colors.redAccent,size: 35),"memory"));

    GlobalParameters.devices_sections.add(Sections("Contact detectors",Icon(Icons.business)));
    GlobalParameters.devices_sections.add(Sections("Motion detectors",Icon(Icons.directions_walk)));
    // downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');


  }
//  void _handleTabSelectionColor()
//  {
//    setState(() {
//      widget.c
//    });
//  }

  void deleteAllImages()async{
    var _documentDirectory = await getApplicationDocumentsDirectory();
    var DirectoryPath = _documentDirectory.path + '/images/';

    var systemTempDir = Directory(DirectoryPath);
    if(systemTempDir.existsSync() == true)
      systemTempDir.deleteSync(recursive: true);
    imageCache.clear();

  }
 /*
  downloadAndSavePhoto(String authEncoded, String url) async {
//https://pub.dev/packages/http

//    try {
//      var uriResponse = await client.post('https://example.com/whatsit/create',
//          body: {'name': 'doodle', 'color': 'blue'});
//      print(await client.get(uriResponse.bodyFields['uri']));
//    } finally {
//      client.close();
//    }

    try {
      final response = await get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ' + authEncoded,
          HttpHeaders.hostHeader: '10.0.0.21'
          // Do same with your authentication requirement
        },
        //body: param,
      ).timeout(const Duration(seconds: 4));

      response.headers.forEach((k, v) => print(k + " : " + v));

      if (response.statusCode == 200) {
        print("Sucsess : " + response.statusCode.toString());

        // Get file from internet
        //var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; //%%%
        //var response = await get(url); //%%%
        // documentDirectory is the unique device path to the area you'll be saving in
        var documentDirectory = await getApplicationDocumentsDirectory();
        var firstPath = documentDirectory.path + "/images"; //%%%
        //You'll have to manually create subdirectories
        await Directory(firstPath).create(recursive: true); //%%%
        // Name the file, create the file, and save in byte form.
        var filePathAndName = documentDirectory.path + '/images/pic.jpg';

        File file = new File(filePathAndName);

        if (file.existsSync()) {
          print('file already exist');
          print('lastModifiedsync:' + file.lastModifiedSync().toString());
          //var image = await file.readAsBytes();
          //return image;
        } else {
          print('file not found downloading from server');
          //var request = await http.get(url,);
          //var bytes = await request.bodyBytes;//close();
          //await file.writeAsBytes(bytes);
          //print(file.path);
          //return bytes;
        }

        //option 1: (from other place)
        file.create(recursive: true).then((val) async {
          if (await val.exists()) {
            //just protect if the file is not exsist...
            print('file over write');
            await file.writeAsBytesSync(response.bodyBytes);
          }
        });

        //option 2: orginal , over write every time
        //file.writeAsBytesSync(response.bodyBytes); //%%%

        setState(() {
          // When the data is available, display it
          imageDataPath = filePathAndName;
          dataLoaded = true;
        });
      }
    } catch (error, stacktrace) {
      print("zeev Exception occured: $error stackTrace: $stacktrace");
      //return UserResponse.withError("$error");

    } finally {
      client.close();
      print("close client");
    }
  }
*/



  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          //backgroundColor: Colors.grey[100],
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
            key: _scaffoldKey,
            appBar: AppBar(
              title: alarm_state == "Alarm"
                  ? new Text(alarm_state)
                  : new Text(_myHandler.title), //alarm_state
              backgroundColor: alarm_state == "Alarm"
                  ? alarm_current_color
                  : _myHandler.color, //alarm_current_color,
              actions: <Widget>[
                //selectPopupMenuWidget(),
              ],
            ),
            drawer: drawer_func(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.chat),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              //tooltip: 'Upload',
              onPressed: () async {
//                int len = Device.DevicesList.length;
//                GlobalParameters.LastDevicesList.clear();
//                for (int i = 0;i<len;i ++)
//                  {
//                    GlobalParameters.LastDevicesList.add(Device.DevicesList[i]);
//                  }
//                int index = 0;
//                bool finished = false;
//                for (int i = 0;i < Device.DevicesList.length;i ++)
//                  {
//                    if (Device.DevicesList[i].deviceId == "d891ebe2-a1ef-4404-8e02-f5002065f984")
//                      {
//                        index = i;
//                        finished = true;
//                      }
//                  }
//                if (finished = true)
//                  {
//                    get_device_status(Device.DevicesList[index].deviceId,Device.DevicesList.indexOf(Device.DevicesList[index]));
//                    if (Device.DevicesList[index].capabilities.contains("contactSensor") == true)
//                    {
//                      print("Contact status: ${Device.DevicesList[index].status.main.contactSensor.contact.value}");
//                    }
//                  }

                await update_status();


//                for (int i = 0;i < len;i ++)
//                  {
//                    if (Device.DevicesList[i] != GlobalParameters.LastDevicesList[i])
//                      {
//                        DeviceReceiverProcessData(Device.DevicesList[i]);
//                      }
//
//                  }

                //post_command("f9906945-228f-4584-a274-fae9696e0711");
//                _st_get_devices();
////                if (GlobalParameters.sirenSelectedLocation != null)
//                  SendToArduinoTestReceiver("start,siren,0,on,${GlobalParameters.sirenSelectedLocation},end");
              },
            ),
            bottomNavigationBar:
            new Material(
              color: Colors.grey[100],
              child: new TabBar(

                  indicatorColor: Colors.blueAccent,
                  controller: GlobalParameters.tab_controller, tabs: <Tab>[
                new Tab(icon: new Icon(Icons.home,color: Colors.grey[400],)),
                new Tab(icon: new Icon(Icons.featured_play_list,color: Colors.grey[400],)),
                new Tab(icon: new Icon(Icons.settings,color: Colors.grey[400],)),
                new Tab(icon: new Icon(Icons.devices,color: Colors.grey[400],)),
                new Tab(icon: new Icon(Icons.camera_alt,color: Colors.grey[400],)),
              ]),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(current_wallpaper),
                  fit: BoxFit.cover,
                ),
              ),

//              new BoxDecoration(
//                 decoration: new
//                  image: new DecorationImage(
//                    image: new AssetImage("assets/BackGroundImage.jpg"),
//                    fit: BoxFit.fill,
//                  ),
//                ),

              child: new TabBarView(controller: GlobalParameters.tab_controller, children: <Widget>[
//
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: new Center(
                    child: Column(children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      LabelText(
//                          label: "SEC",value: seconds.toString().padLeft(2,'0')
//                      ),
//                    ],
//                  ),

                      //state_container(),

                      //current_state_func(),

                      buttons_bar(),

                      Divider(color: Colors.grey[700],),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: LogMemory(),
                      ),
                      Divider(color: Colors.grey[700],),
                      //new Padding(padding: new EdgeInsets.all(8.00)),
                      Text("Not ready events:",
                          style: Theme.of(context).textTheme.title),
                      NotReadyEventsWidget(),
                      //ready_container(),
                      new Padding(padding: new EdgeInsets.all(8.00)),
                      Text("received msg:$RX_DATA_RECEIVER"),

                      LastEventWidget(),

                      //last_event_widget(),
                      //snackBar,

//                  Text(
//                      _ports.length > 0
//                          ? "Available Serial Ports"
//                          : "No serial devices available",
//                      style: Theme.of(context).textTheme.title),
//                  ..._ports,
//                  Text('Status: $_status\n'),
//                  Text("Result Data", style: Theme.of(context).textTheme.title),
//                  ..._serialData,
                    ]),
                  ),
                ),
                //---end of tab 1

                //----------
                //second tab
                //----------
                LogEventWidgets(),
                //---end of tab 2

                //----------
                //third tab
                //----------
                SettingsWidget(),
                //---end of tab 3


                //----------
                //fourth tab
                //----------
                DevicesWidget(),
                //end of tab 4


                //----------
                //fifth tab
                //----------
                load_image(context),
                //end of tab 5

                //Switch_1(),
              ]),
            ));


//      Scaffold(
//        //backgroundColor: Colors.grey[100],
////      appBar: AppBar(
////        title: Text(widget.title),
////      ),
//        key: _scaffoldKey,
//        appBar: AppBar(
//          title: alarm_state == "Alarm"
//              ? new Text(alarm_state)
//              : new Text(_myHandler.title), //alarm_state
//          backgroundColor: alarm_state == "Alarm"
//              ? alarm_current_color
//              : _myHandler.color, //alarm_current_color,
//          actions: <Widget>[
//            //selectPopupMenuWidget(),
//          ],
//        ),
//        drawer: drawer_func(),
//        bottomNavigationBar: new Material(
//          color: Colors.orangeAccent,
//          child: new TabBar(controller: GlobalParameters.tab_controller, tabs: <Tab>[
//            new Tab(icon: new Icon(Icons.home)),
//            new Tab(icon: new Icon(Icons.featured_play_list)),
//            new Tab(icon: new Icon(Icons.settings)),
//            new Tab(icon: new Icon(Icons.devices)),
//            new Tab(icon: new Icon(Icons.camera_alt)),
//          ]),
//        ),
//        body: new TabBarView(controller: GlobalParameters.tab_controller, children: <Widget>[
//          SingleChildScrollView(
//            child: new Center(
//              child: Column(children: <Widget>[
////                  Row(
////                    mainAxisAlignment: MainAxisAlignment.start,
////                    children: <Widget>[
////                      LabelText(
////                          label: "SEC",value: seconds.toString().padLeft(2,'0')
////                      ),
////                    ],
////                  ),
//
//                //state_container(),
//
//                //current_state_func(),
//
//                buttons_bar(),
//
//
//                //new Padding(padding: new EdgeInsets.all(8.00)),
//                Text("Not ready events:",
//                    style: Theme.of(context).textTheme.title),
//                NotReadyEventsWidget(),
//                //ready_container(),
//                new Padding(padding: new EdgeInsets.all(8.00)),
//                Text("received msg:$RX_DATA_RECEIVER"),
//
//                LastEventWidget(),
//                 //last_event_widget(),
//                //snackBar,
//
////                  Text(
////                      _ports.length > 0
////                          ? "Available Serial Ports"
////                          : "No serial devices available",
////                      style: Theme.of(context).textTheme.title),
////                  ..._ports,
////                  Text('Status: $_status\n'),
////                  Text("Result Data", style: Theme.of(context).textTheme.title),
////                  ..._serialData,
//              ]),
//            ),
//          ),
//          //---end of tab 1
//
//          //----------
//          //second tab
//          //----------
//          LogEventWidgets(),
//          //---end of tab 2
//
//          //----------
//          //third tab
//          //----------
//          SettingsWidget(),
//          //---end of tab 3
//
//
//          //----------
//          //fourth tab
//          //----------
//          DevicesWidget(),
//          //end of tab 4
//
//
//          //----------
//          //fifth tab
//          //----------
//          load_image(context),
//          //end of tab 5
//
//          //Switch_1(),
//        ]));
  }

  @override
  void dispose() {
    receiver_socket.close();
    keypad_socket.close();
    super.dispose();
  }
  void show_all_func()
  {
    setState(() {
      GlobalParameters.tab_controller.index = 1;
    });
  }
  Future<Null> update_status () async
  {
    int len = Device.DevicesList.length;
    for (int i = 0;i < len;i ++)
    {
      var status;
      var _pmt = await get_device_status(Device.DevicesList[i].deviceId,i);
      if (_pmt != null)
      {
        status = Components.fromJson(_pmt["components"]);//["main"]
      }
      await set_status(i,status);
      print("device data: $_pmt, $i, ${Device.DevicesList[i].label},${Device.DevicesList[i].deviceId}");
    }

    print('end of get status');
    for (int i = 0;i < len;i ++)
    {
      if (Device.DevicesList[i].status != null)
      {
        if (Device.DevicesList[i].capabilities.contains("contactSensor"))
        {
          if (Device.DevicesList[i].status.main.contactSensor.contact.value != GlobalParameters.last_contact_device_val)//GlobalParameters.LastDevicesList[index].status.main.contactSensor.contact.value)
            {
            DeviceReceiverProcessData(Device.DevicesList[i]);
          }
        }
        if (Device.DevicesList[i].capabilities.contains("motionSensor"))
        {
          if (Device.DevicesList[i].status.main.motionSensor.motion.value != GlobalParameters.last_pir_device_val)//GlobalParameters.LastDevicesList[index].status.main.contactSensor.contact.value)
              {
            DeviceReceiverProcessData(Device.DevicesList[i]);
          }
        }
      }
    }


//    int len = Device.DevicesList.length;
//
//    //get_device_status("d891ebe2-a1ef-4404-8e02-f5002065f984",i);
//    await Future.forEach(Device.DevicesList, (device) async {
//      print("start get_device_status");
//      //get_status(device.deviceId,Device.DevicesList.indexOf(device)));
//      get_device_status(device.deviceId,Device.DevicesList.indexOf(device));
//      if (device.capabilities.contains("contactSensor") == true)
//        {
//          print("Contact status: ${device.status.main.contactSensor.contact.value}");
//        }
////      if (device.capabilities.contains("motionSensor") == true)
////      {
////        print("motion status: ${device.status.}");
////      }
//
//      print("end get_device_status");
//    });
//    for (int i = 0;i < Device.DevicesList.length;i ++)
//    {
//
//      print("start get_device_status");
//      get_device_status(Device.DevicesList[i].deviceId,i);
//      if (Device.DevicesList[i].capabilities.contains("contactSensor") == true)
//        {
//          print("Contact status: ${Device.DevicesList[i].status.main.contactSensor.contact.value}");
//        }
//
//      print("end get_device_status");
//
//      //Map values = device_status["components"]["main"][Device.capabilities_status[i]];
//    }

  }
//  Widget last_event_widget()
//  {
//    //getDir();
//    if (LogEvent.LogEvents.length > 0)
//    {
//      int cell = LogEvent.LogEvents.length-1;
//      return Card(
//        child: new Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            new ListTile(
//              title: Text("Last event"),
//              trailing: GestureDetector(
//                child: Text(
//                  'Show all events >',
//                  style: TextStyle(
//                    fontSize: 17,
//                    decoration: TextDecoration.underline,
//                    color: Colors.blue,
//                  ),
//                ),
//                onTap: show_all_func,
//              ),
//            ),
//            new Divider(color: Colors.blue,indent: 16.0),
//            new ListTile(
//                title: Text(LogEvent.LogEvents[cell].event_name.toString()),//
//                trailing:
//                GestureDetector(
//                  child: Container(
//                    height: 60,
//                    width: 60,
//                    child: LogEvent.LogEvents.length > 0 ? small_picture() : Text(""),//Image.asset("assets/keyfob.jpg", fit: BoxFit.cover),
////                    Image.file(
////                      File("assets/keyfob.jpg"),
////                      fit: BoxFit.cover,
////                      //width: 600.0,
////                      //height: 290.0
////                    ),
//
//
////                    LogEvent.LogEvents.length > 0 ? small_picture() : Text(""),//LogEvent.LogEvents[0].has_image == true ?
//                    //Text("Image is here")
//
//                  ),
//                  onTap:(){
//                    int cell = LogEvent.LogEvents.length-1;
//                    String _image = LogEvent.LogEvents[cell].event_image_path;
//                      showDialog(
//                          context: context,
//                        builder: (BuildContext context) {
//                          return AlertDialog(
//                            titlePadding: EdgeInsets.all(0),
//
//                            shape: new RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.circular(20),
//                            ),//+ Border.all(color: Colors.white),///contentPadding: EdgeInsets.all(0.0),
////                            decoration: new BoxDecoration(
////                              shape: BoxShape.rectangle,
////                              color: const Color(0xFFFFFF),
////                              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
////                            ),
//                            title: Container(
//
//                              height: 300.00,
//                              width: 300.00,
////                              decoration: BoxDecoration(
////                                color: Colors.redAccent,
////                                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
////                              ),
//                              child: ClipRRect(
//                                borderRadius: BorderRadius.circular(20.0),
//                                child: Image.file(File(_image),fit: BoxFit.fill),
//                              ),
//
//
//                            ),
//
////                            //contentPadding: EdgeInsets.all(0.0),
////                            shape: RoundedRectangleBorder(
////                                borderRadius: BorderRadius.all(Radius.circular(32.0))
////                            ),
////                            //BorderRadius.all(Radius.circular(20.0))
////                            //title: Text(""),
////                            content: Image.file(File(_image),fit: BoxFit.fill),
//                          );
//                        }
//                      );
//
//
//                  } ,
//                )
//              //Image.asset("assets/keyfob.jpg", fit: BoxFit.cover),
//                  //width: 600.0,
//                  //height: 290.0
//
//
//            )
//          ],
//        ),
//      );
//    }
//    return Text("");
//  }

  Image loadImageFromFile(String path) {
    File file = new File(path);
    Image img = Image.file(file);
  }

//  void storeImageToFile(String path,String url) async {
//    var response = await get(Url);
//    File file = new File(path);
//    file.create(recursive: true).then((val) async {
//      if (await val.exists()) {
//        await file.writeAsBytesSync(response.bodyBytes);
//      }
//    });
//  }

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }

//  Widget small_picture()
//  {
//      int cell = LogEvent.LogEvents.length-1;
//
//      if (LogEvent.LogEvents[cell].has_image == true)
//      {
//        String _image = LogEvent.LogEvents[cell].event_image_path;
//        print(LogEvent.LogEvents[cell].event_image_path);
//        return //loadImageFromFile(_image);
//          //Image.asset("assets/keyfob.jpg", fit: BoxFit.cover);
//          ClipRRect(
//            borderRadius: BorderRadius.circular(10.0),
//            child: Image.file(File(_image),fit: BoxFit.fill)
//          );
//          Image.file(File(_image),fit: BoxFit.cover);
//
//      }
//
//
//
//    // : null,
////                              LogEvent.LogEvents[0].has_image == true ? //Text("Image is here")
////                              Image.file(
////                                File(LogEvent.LogEvents[0].event_image_path),
////                                fit: BoxFit.cover,
////                                //width: 600.0,
////                                //height: 290.0
////                              ) : null,
//  }
  void func()
  {

  }
  void _handleSelected() {
    setState(() {
      _myHandler = _tabs[GlobalParameters.tab_controller.index];
      if (GlobalParameters.tab_controller.index == 4)//camera tab
      {
        pictures_pathes = get_pathes();

      }


    });
  }


  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = new Completer();
    var lister = dir.list(recursive: false);
    lister.listen (
            (file) => files.add(file),
        // should also register onError
        onDone:   () => completer.complete(files)
    );
    return completer.future;
  }
  int path_counter = 0;
  Widget load_image(BuildContext context) {
    if (dataLoaded) {
      return Scaffold(
//        body: Container(
//          alignment: Alignment.center,
//          child: Container(
//            width: 300.0,
//            height: 500.0,
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(30.0),
//                image: DecorationImage(
//                    image: AssetImage(
//                      "assets/puffin.jpeg",
//                    ), fit: BoxFit.cover)
//            ),
//          ),
//        ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            //height: 400.0,
            child: new Center(
              child: new Column(
                children: <Widget>[
                  Text(imageDataPath),
                  Text(path_index.toString()),
                  Text("max items: " + pictures_pathes.length.toString()),
                  Image.file(
                    File(imageDataPath),
                    fit: BoxFit.cover,
                    //width: 600.0,
                    //height: 290.0
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      //imageDataPath = filePathImagesDirectory + 'pic$path_counter.jpg';

//                      if (_counter == path_counter)
//                      {
//                        path_counter = 0;
//                      }
//                      path_counter++;
//                      int count = path_counter-1;
//                      imageDataPath = filePathImagesDirectory + 'pic$count.jpg';
                      path_index ++;
                      if (path_index >= pictures_pathes.length)
                      {
                        path_index = 0;
                      }

                      imageDataPath = pictures_pathes[path_index].path;
                    });

                  },
                  child: Icon(Icons.navigate_before),
                ),
                FloatingActionButton(
                  onPressed: () {
                    final tmp_file = File(imageDataPath);
                    if(tmp_file.existsSync())
                      {
                        setState(() {
                          pictures_pathes.removeAt(path_index);
                          tmp_file.deleteSync();
                          imageCache.clear();
                        });

                        print("file exist!");
                      }
//
                    else
                    {
                      print("file does not exist!");
                    }

                  },
                  child: Icon(Icons.delete),
                ),
                FloatingActionButton(
                  onPressed: () {
                    //_downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
                    setState(() {
                      dataLoaded = false;
                    });
                  },
                  child: Icon(Icons.camera),
                ),
                FloatingActionButton(
                  onPressed: () {
                    //_downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
                    get_pathes();
//                    final tmp_directory = Directory(filePathImagesDirectory);
//                    List contents = tmp_directory.listSync();
//                    for (var fileOrDir in contents) {
//                      //if (fileOrDir is File) {
//                      print(fileOrDir.path);
//                      //} else if (fileOrDir is Directory) {
//                      //  print(fileOrDir.path);
//                      //}
//                      //fileOrDir.deleteSync();

                    //}
//                    dirContents(tmp_directory).then((onValue){
//                      print(onValue);
//                    });
                  },
                  child: Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
//                      path_counter--;
//                      if (path_counter == 0)
//                      {
//
//                        path_counter = _counter;
//                      }
//                      int count = path_counter-1;
//                      imageDataPath = filePathImagesDirectory + 'pic$count.jpg';

                      if (path_index == 0)
                      {
                        path_index = pictures_pathes.length;
                      }
                      path_index --;
                      imageDataPath = pictures_pathes[path_index].path;
                    });

                  },
                  child: Icon(Icons.navigate_next),
                ),
              ],
            ),
          )
//        floatingActionButton: FloatingActionButton(
//          onPressed: ()  {
//            setState(() {
//            dataLoaded = false;
//            });
////            new FutureBuilder<void>(
////                future: _downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture'),
////                builder: (context, snapshot){
////                  print('In Builder');
////                }
////            );
//
//
////            setState(() {
////              // When the data is available, display it
////              //imageData = filePathAndName;
////              dataLoaded = false;
////            });
//            //dataLoaded = false;
//            //var result = await fetchPost()
//            //var result = await _downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
//          },
//          child: Icon(Icons.camera),
//          backgroundColor: Colors.deepPurple,
//        ),
          );
    } else {
      return Scaffold(
        body: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _downloadAndSavePhoto(encodedCredentials,
                'http://10.0.0.21/ISAPI/Streaming/channels/1/picture',null, false);
          },
          child: Icon(Icons.camera),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

//  Widget current_state_func(int seconds)
//  {
//    return Container(
//      //decoration: new BoxDecoration(color: Colors.grey[200]),
//      //backgroundColor:Colors.grey[50],
//      height: 200,
//      child: Card(
//        color: Colors.white,
//        child: ButtonBar(
//          alignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            state_icon(),
//          ],
//        ),
//      ),
//    );
//  }
  List<FileSystemEntity> get_pathes()
  {
    final tmp_directory = Directory(filePathImagesDirectory);
    List<FileSystemEntity> contents = tmp_directory.listSync();
    for (var fileOrDir in contents) {
      //if (fileOrDir is File) {
      print(fileOrDir.path);
      //} else if (fileOrDir is Directory) {
      //  print(fileOrDir.path);
      //}
      //fileOrDir.deleteSync();

    }
    return contents;
  }

  Widget buttons_bar() {
    return Container(
      //decoration: new BoxDecoration(color: Colors.grey[200]),
      //backgroundColor:Colors.grey[50],
      //height: 300,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        //color: Colors.white[250],
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

                  //ShowExitDelayTimer(),
                  Container(
                        //alignment: Alignment.centerLeft,

                        child: state_icon(),
                      ),

              ShowExitDelayTimer(),
//              Row(
//
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
////                  Align(
////                      alignment: Alignment.topLeft,
////                      child: ShowExitDelayTimer()
////                  ),
////                  Align(
////                    alignment: Alignment.centerRight,
////                    child:
//                    Center(
//                      child: Container(
//                        //alignment: Alignment.centerLeft,
//
//                        child: state_icon(),
//                      ),
//                    ),
//                  //Container()
//
////                  )Text("")
//                  //),
//                ],
//              ),


              new Padding(padding: new EdgeInsets.all(20.00)),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  arm_away_button(),
                  arm_home_button(),
                  disarm_button(),
                ],
              ),

            ]),
      ),
    );
  }

  Widget drawer_func() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Profile name"),
            accountEmail: new Text("Profile Email"),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Icon(Icons.account_circle, size: 60),
            ),
          ),
          new ListTile(
            title: new Text("Clear log events"),
            trailing: new Icon(Icons.clear_all),
            onTap: () {
              setState(() {
                LogEvent.LogEvents.clear();
              });
              Navigator.of(context).pop();
            },
          ),
          new ListTile(
            title: new Text("Change wallpaper"),
            trailing: new Icon(Icons.wallpaper),
            onTap: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeWallpaper()),
                );
              });
              //Navigator.of(context).pop();
            },
          ),
          new ListTile(
            title: new Text("Work diagnostics"),
            trailing: new Icon(Icons.assignment),
            onTap: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkDiagnostics()),
                );
              });
              //Navigator.of(context).pop();
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text("Close"),
            trailing: new Icon(Icons.close),
            onTap: () {
              setState(() {
                LogEvent.LogEvents.clear();
              });
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget state_icon() {
    //double width = MediaQuery.of(context).size.width;
    return Material(
      elevation: 0,
      //color: Colors.white60,
      //elevation: 0,
      color: Colors.transparent,
      //color: alarm_current_color, // button color
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

              // time_label,
//              Align(
//                  alignment: Alignment.topLeft,
//                  child: ShowExitDelayTimer()
//              ),

              Align(
                  alignment: Alignment.center,
                  child: current_icon
              ),
              //Container(),
//              Container(
//                width: 80,
//                height: 100,
//                child: GestureDetector(
//                  onTap: (){
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) =>
//                          SettingsTrouble()), //randomly_light()
//                    );
//                  },
//                  child: Column(
//                    children: <Widget>[
//                      Text(GlobalParameters.troubles.length.toString(),style: TextStyle(
//                        fontSize: 25
//                      ),),
//                      Icon(Icons.warning,color: Colors.orange,size: 65,)
//                    ],
//                  ),
//                ),
//              )



                //padding: const EdgeInsets.fromLTRB(70, 10, 100, 10),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[

//                  ],
//                )






          Text(
            arm_state,
            style: TextStyle(
              //fontWeight: FontWeight.bold,
              color: current_icon.color,
              fontSize: 22.0,
            ),
            //color: Colors.white,
          ),
          Text(
            ready_state,
            style: TextStyle(
              //fontWeight: FontWeight.bold,
              color: current_icon.color,
              fontSize: 20.0,
            ),
            //color: Colors.white,
          ), // text
        ],
      ),
    );
  }

  Widget arm_home_button() {
    return ArmDisarmButton(
      ButtonColor: Colors.orangeAccent,
      ButtonSplashColor: Colors.orangeAccent[200],
      ButtonIcon: Icons.home,
      ButtonText: "Arm Home",
      onButtonSelected: () {
        //ReceiverProcessData("start,keyfob,0,arm_home,end");
        arm_activity("arm_home",CallingSource.smartphone_button);
//        //secondsPassed = GlobalParameters.current_delay_time;
//        if (GlobalParameters.current_delay_time != 0) {
//          startExitDelayTimer();
//          KeypadProcessData(
//              "start,timer,on," + GlobalParameters.current_delay_time.toString() + ",end");
//        }
//        _start = GlobalParameters.current_delay_time;
      },
    );
  }

  Widget arm_away_button() {
    return ArmDisarmButton(
      ButtonColor: Colors.red,
      ButtonSplashColor: Colors.red[200],
      ButtonIcon: Icons.lock,
      ButtonText: "Arm Away",
      onButtonSelected: () {
        //ReceiverProcessData("start,keyfob,0,arm_away,end");
        arm_activity("arm_away",CallingSource.smartphone_button);
        //GlobalParameters.memory.clear();
        List<MainShourtcut> _shortcut = new List<MainShourtcut>();
        for (int i = 0;i < GlobalParameters.shortcuts.length;i ++)
          {
            if (GlobalParameters.shortcuts[i].page != "memory")
              {
                _shortcut.add(GlobalParameters.shortcuts[i]);
              }
          }
        GlobalParameters.shortcuts.clear();
//        if (_shortcut.length != 0)
//          {
//            for(int i = 0;i < _shortcut.length;i ++)
//              {
//                GlobalParameters.shortcuts.add(_shortcut[i]);
//              }
//          }
        for (int i = 0;i < _shortcut.length;i ++)
        {
          GlobalParameters.shortcuts.add(_shortcut[i]);
        }
        GlobalParameters.memory.clear();
//        GlobalParameters.shortcuts.forEach(index,value) {
//
//        };
//        setState(() {
//          GlobalParameters.shortcuts.remove(GlobalParameters.memory);
//        });

      },
    );
  }

  Widget disarm_button() {
    return ArmDisarmButton(
      ButtonColor: Colors.green,
      ButtonSplashColor: Colors.green[200],
      ButtonIcon: Icons.lock_open,
      ButtonText: "Disarm",
      onButtonSelected: () {
        //SendToArduinoKeypad("start,leds,trouble,on,end");
        arm_activity("Disarm", CallingSource.smartphone_button);
      },
    );
  }

  /// --------------
  /// tcp functions:
  /// --------------

  void dataHandlerReceiver(data) {
    setState(() {
      RX_DATA_RECEIVER = String.fromCharCodes(data).trim();
    });
    ReceiverProcessData(RX_DATA_RECEIVER); //process_data

    print(RX_DATA_RECEIVER);
  }

  void dataHandlerKeypad(data) {
    setState(() {
      RX_DATA_KEYPAD = String.fromCharCodes(data).trim();
    });
    KeypadProcessData(RX_DATA_KEYPAD);

    print(RX_DATA_RECEIVER);
  }

  void errorHandlerReceiver(error, StackTrace trace) {
    print(error);
  }

  void doneHandlerReceiver() {
    receiver_socket.destroy();
    exit(0);
  }

  void errorHandlerKeypad(error, StackTrace trace) {
    print(error);
  }

  void doneHandlerKeypad() {
    keypad_socket.destroy();
    exit(0);
  }

  Widget selectPopupMenuWidget() {
    return PopupMenuButton(
      child: Icon(Icons.menu),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Clear log events"),
          value: 1,
        ),
//                  PopupMenuItem(
//                    value: 1,
//                    child: Text("Flutter.io"),
//                  ),
//                  PopupMenuItem(
//                    child: Text("Google.com"),
//                  ),
      ],
      //initialValue: 2,
      onSelected: (value) {
        if (value == 1) {
          print("aaaaa");
          setState(() {
            LogEvent.LogEvents.clear();
          });
        }
        print("value:$value");
        print("You have selected the menu.");
      },
      onCanceled: () {
        print("You have canceled the menu.");
      },
      //padding: EdgeInsets.symmetric(horizontal: 50),
    );
  }

  void audio_producer() {
    if (ding_dong_switch == true) {
      print("ding dong");
    }
  }

  void DeviceReceiverProcessData(Device device) {
    //var lineParts = value.split(',');
//    if (lineParts.length < 5) {
//      return;
//    }
//    if (lineParts[3] == "arm")//build pach for the keyfob //TODO: fix in the future
//        {
//      lineParts[3] = "arm_away";
//    }
    //List<String> notReadyParts = new List<String>();
    //string[] notReadyParts;

    ////////////////////////////////////////////////////////////
    //TODO: do the if for the keyfob
//    if (lineParts[3] == "arm_away") {
//      arm_activity(lineParts[3],CallingSource.keyfob);
//    }
//    if (lineParts[3] == "arm_home")  {
//      arm_activity(lineParts[3],CallingSource.keyfob);
//    }
//    if ((lineParts[3] == "arm_home") && (ready_not_ready == false) ||
//        (lineParts[3] == "arm_away") && (ready_not_ready == false)) {
//      SendToArduinoKeypad("start,buzzer,1,fail,5000,end");
//    }
//    if (lineParts[3] == "disarm") {
//      arm_activity("Disarm", CallingSource.keyfob);
//      //label1.Text = "-----";
//      //label1.ForeColor = Color.Black;
//      //label2.ForeColor = Color.Green;
//    }
    ////////////////////////////////////////////////////////////
    if (device.capabilities.contains("motionSensor") == true) {
      SendToArduinoKeypad("start,leds,pir,pulse,2,end");
      GlobalParameters.pir_event = Text("Detected");
      if (arm_state == "Arm away")
        {
          if (device.type == "Interior")
          {
            if (device.status.main.motionSensor.motion.value == "active")
            {
              setState(() {
                GlobalParameters.memory.add(Memory("${device.label}",Icon(Icons.directions_walk)));
              });
              alarm_process(AlarmCallingSource.pir, arm_state);
            }
          }
          else if (device.type == "Perimeter")
          {
            if (device.status.main.motionSensor.motion.value == "active")
            {
              setState(() {
                GlobalParameters.memory.add(Memory("${device.label}",Icon(Icons.directions_walk)));
              });
              alarm_process(AlarmCallingSource.pir, arm_state);
            }
          }
          else if (device.type == "Delay")
          {
            secondsPassed = int.parse(GlobalParameters.DeviceDelayexitSelectedLocation);
            GlobalParameters.entry_delay_time = true;
            if (secondsPassed != 0) {
              _start = secondsPassed;
              startExitDelayTimer();
            }
          }
        }
        else if (arm_state == "Arm home")
      {
        if (device.type == "Interior")
        {
          //Do nothing
        }
        else if (device.type == "Perimeter")
        {
          if (device.status.main.motionSensor.motion.value == "active")
          {
            setState(() {
              GlobalParameters.memory.add(Memory("${device.label}",Icon(Icons.directions_walk)));
            });
            alarm_process(AlarmCallingSource.pir, arm_state);
          }
        }
        else if (device.type == "Delay")
        {
          secondsPassed = int.parse(GlobalParameters.DeviceDelayexitSelectedLocation);
          GlobalParameters.entry_delay_time = true;
          if (secondsPassed != 0) {
            _start = secondsPassed;
            startExitDelayTimer();
          }
        }
      }


      //label1.Text = "Alarm";
      //label1.ForeColor = Color.Red;
      //SendToArduinoKeypad("start,leds,alarm,on,end");
      //SendToArduinoKeypad("start,leds,pir,pulse,2000,end");
      //port.WriteLine("start,leds,alarm,on,end");


      //alarm_process(AlarmCallingSource.pir, arm_state);


//      setState(() {
//
//        alarm_current_color = Colors.red;
//        alarm_state = "Alarm";
//
//      });



//      var log_key = UniqueKey();
//      _downloadAndSavePhoto(encodedCredentials,
//          'http://10.0.0.21/ISAPI/Streaming/channels/1/picture',log_key , true);
//      var my_event = add_event("PIR Alarm!!",true,log_key);

      //_downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
    }
//    if (device.capabilities.contains("motionSensor") == true) {
//      SendToArduinoKeypad("start,leds,pir,pulse,2,end");
//      GlobalParameters.pir_event = Text("Detected");
//      //startPirEvent();
//    }

    if (device.capabilities.contains("contactSensor") == true)
      {
        if (device.status.main.contactSensor.contact.value == "open")
          {
            if (arm_state == "Arm away" && (device.type != "Interior"))
              {
                if (device.type == "Delay")
                {
                  secondsPassed = int.parse(GlobalParameters.DeviceDelayexitSelectedLocation);
                  GlobalParameters.entry_delay_time = true;
                  if (secondsPassed != 0) {
                    _start = secondsPassed;
                    startExitDelayTimer();
                  }

                  //alarm_process(AlarmCallingSource.contact, arm_state);
                }
                else
                {
                  setState(() {
                    GlobalParameters.memory.add(Memory("${device.label}",Icon(Icons.business)));
                  });
                  alarm_process(AlarmCallingSource.contact, arm_state);
                }

              }
            if (arm_state == "Arm home")
              {
                setState(() {
                  GlobalParameters.memory.add(Memory("${device.label}",Icon(Icons.business)));
                });
                alarm_process(AlarmCallingSource.contact, arm_state);
              }
            if ((arm_state != "Arm away") && (arm_state != "Arm home"))//))
              {
                SendToArduinoKeypad("start,leds,contact,on,end");
                SendToArduinoKeypad("start,leds,ready,off,end");
                setState(() {
                  current_icon = Icon(
                    Icons.lock_open,
                    color: Colors.green,
                    size: 76,
                  );
                  if (GlobalParameters.bypass_or_not == false)
                  {
                    ready_not_ready = false;
                  }
                  GlobalParameters.notReadyParts.add("Contact Opened");
                  GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));
                  GlobalParameters.contact_state = Text("Open",
                    style: TextStyle(
                        color: Colors.redAccent
                    ),
                  );
                  audio_producer(); ///////////////////////////////////////////////////////////////////////
                  _show_snack_bar();
                  print("snack bar enabled");
                  //downloadAndSavePhoto(encodedCredentials,
                  //   'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
                  active_chime();
                });
              }
            if((arm_state == "Disarm") &&
                (ready_state == "Ready"))
              {
                if (GlobalParameters.notReadyParts.contains("Contact Opened") == false) {
                  setState(() {
                    current_icon = Icon(
                      Icons.lock_open,
                      color: Colors.green,
                      size: 76,
                    );
                    GlobalParameters.notReadyParts.add("Contact Opened");

                    GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));

                    GlobalParameters.contact_state = Text("Open",
                      style: TextStyle(
                          color: Colors.redAccent
                      ),
                    );
                  });

                  SendToArduinoKeypad("start,leds,ready,off,end");
                  SendToArduinoKeypad("start,leds,contact,on,end");
                }

                setState(() {
                  arm_state = "Disarm";
                  ready_state = "Not ready";
                  if (GlobalParameters.bypass_or_not == false)
                  {
                    ready_not_ready = false;
                  }
                });
                //label2.Text = "Disarm,Not ready";

                //SendToArduino("start,leds,ready,off,end");
                SendToArduinoKeypad("start,leds,arm,off,end");
              }
          }
        else if (device.status.main.contactSensor.contact.value == "closed")
          {
            //turn off the contact led
            SendToArduinoKeypad("start,leds,contact,off,end");

            //update the ready list and led
            setState(() {
              update_ready_list("Contact Opened");
              GlobalParameters.contact_state = Text("Close",
                style: TextStyle(
                    color: Colors.lightGreen
                ),
              );
            });
          }
      }
//    if (((device.capabilities.contains("contactSensor") == true) &&
//        (lineParts[3] == "opened") &&
//        (arm_state == "Arm away"))
//        ||
//        ((lineParts[1] == "contact") &&
//            (lineParts[3] == "opened") &&
//            (arm_state == "Arm home"))) {
//
//      alarm_process(AlarmCallingSource.contact, arm_state);
//      // activate_alarm(arm_state);
//
//    }
//    if ((lineParts[1] == "contact") &&
//        (lineParts[3] == "opened") &&
//        (arm_state != "Arm away") &&
//        (arm_state != "Arm home"))
//    {
//      SendToArduinoKeypad("start,leds,contact,on,end");
//      SendToArduinoKeypad("start,leds,ready,off,end");
//      setState(() {
//        current_icon = Icon(
//          Icons.lock_open,
//          color: Colors.green,
//          size: 76,
//        );
//        if (GlobalParameters.bypass_or_not == false)
//        {
//          ready_not_ready = false;
//        }
//        GlobalParameters.notReadyParts.add("Contact Opened");
//        GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));
//        GlobalParameters.contact_state = Text("Open",
//          style: TextStyle(
//              color: Colors.redAccent
//          ),
//        );
//        audio_producer(); ///////////////////////////////////////////////////////////////////////
//        _show_snack_bar();
//        print("snack bar enabled");
//        //downloadAndSavePhoto(encodedCredentials,
//        //   'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
//        active_chime();
//      });
//    }
    //TODO: see how to check if tamper is open
    if (device.capabilities.contains("tamperOpened") == true) {
      if (arm_state == "Arm away") {
        SendToArduinoKeypad("start,leds,alarm,on,end");
        setState(() {
          alarm_current_color = Colors.red;
          alarm_state = "Alarm";
        });
      }
      else if ((arm_state == "Disarm") &&
          (ready_state == "Ready")) {
        setState(() {
          ready_state = "Not ready";
          current_icon = Icon(
            Icons.lock_open,
            color: Colors.green,
            size: 76,
          );
          GlobalParameters.notReadyParts.add(
              "Tamper Opened"); /////////////////////////////////////////
          GlobalParameters.troubles.add(TroubleCell(
              "Tamper Opened", Icon(Icons.warning, color: Colors.redAccent,),
              "tamper opened"));
        });
        SendToArduinoKeypad("start,leds,trouble,on,end");
        SendToArduinoKeypad("start,leds,ready,off,end");
      }
      else if ((arm_state == "Disarm") &&
          (ready_state == "Ready"))
        {
          if (GlobalParameters.notReadyParts.contains("Tamper Opened") == false) {
            setState(() {
              ready_state = "Not ready";
              current_icon = Icon(
                Icons.lock_open,
                color: Colors.green,
                size: 76,
              );
              GlobalParameters.notReadyParts.add("Tamper Opened"); /////////////////////////////////////////
              GlobalParameters.troubles.add(TroubleCell("Tamper Opened",Icon(Icons.warning,color: Colors.redAccent,),"tamper opened"));
            });
            SendToArduinoKeypad("start,leds,trouble,on,end");
            SendToArduinoKeypad("start,leds,ready,off,end");
          }
        }
    }
    else if (device.capabilities.contains("tamperClosed") == true)
      {
        SendToArduinoKeypad("start,leds,trouble,off,end");

        //update the ready list and led
        setState(() {
          update_ready_list("Tamper Opened");
        });
      }
//    if ((lineParts[1] == "detectors") &&
//        (lineParts[3] == "tamper_opened") &&
//        (arm_state == "Arm away")) {
//      //label1.Text = "Alarm";
//      //label1.ForeColor = Color.Red;
//      SendToArduinoKeypad("start,leds,alarm,on,end");
//      setState(() {
//        alarm_current_color = Colors.red;
//        alarm_state = "Alarm";
//      });
//    }
    ////////////////////////////////////////////////////////////
//    if ((lineParts[1] == "detectors") &&
//        (lineParts[3] == "tamper_opened") &&
//        (arm_state == "Disarm") &&
//        (ready_state == "Ready")) {
//      if (GlobalParameters.notReadyParts.contains("Tamper Opened") == false) {
//        setState(() {
//          ready_state = "Not ready";
//          current_icon = Icon(
//            Icons.lock_open,
//            color: Colors.green,
//            size: 76,
//          );
//          GlobalParameters.notReadyParts.add("Tamper Opened"); /////////////////////////////////////////
//          GlobalParameters.troubles.add(TroubleCell("Tamper Opened",Icon(Icons.warning,color: Colors.redAccent,),"tamper opened"));
//        });
//        SendToArduinoKeypad("start,leds,trouble,on,end");
//        SendToArduinoKeypad("start,leds,ready,off,end");
//      }
//      //textBox2.Text = "";
//      for (int i = 0; i < GlobalParameters.notReadyParts.length; i++) {
//        //textBox2.Text += notReadyParts[i].ToString() + "\n";
//      }
//      //textBox2.Text = notReadyParts.ToString();
//      //label2.Text = "Disarm,Not ready";
//
//      //SendToArduino("start,leds,ready,off,end");
////      SendToArduinoKeypad("start,leds,arm,off,end");
////      SendToArduinoKeypad("start,leds,alarm,on,end");
////      //label2.ForeColor = Color.Red;
////      setState(() {
////        current_icon = Icon(
////          Icons.lock_open,
////          color: Colors.green,
////          size: 76,
////        );
////        arm_state = "Disarm";
////        ready_state = "Not ready";
////        if (GlobalParameters.bypass_or_not == false)
////        {
////          ready_not_ready = false;
////        }
////        alarm_current_color = Colors.red;
////        alarm_state = "Alarm";
////      });
//    }
//    if ((lineParts[1] == "contact") &&
//        (lineParts[3] == "opened") &&
//        (arm_state == "Disarm") &&
//        (ready_state == "Ready")) {
//      if (GlobalParameters.notReadyParts.contains("Contact Opened") == false) {
//        setState(() {
//          current_icon = Icon(
//            Icons.lock_open,
//            color: Colors.green,
//            size: 76,
//          );
//          GlobalParameters.notReadyParts.add("Contact Opened");
//
//          GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));
//
//          GlobalParameters.contact_state = Text("Open",
//            style: TextStyle(
//                color: Colors.redAccent
//            ),
//          );
//        });
//
//        SendToArduinoKeypad("start,leds,ready,off,end");
//        SendToArduinoKeypad("start,leds,contact,on,end");
//      }
//
//      setState(() {
//        arm_state = "Disarm";
//        ready_state = "Not ready";
//        if (GlobalParameters.bypass_or_not == false)
//        {
//          ready_not_ready = false;
//        }
//      });
//      //label2.Text = "Disarm,Not ready";
//
//      //SendToArduino("start,leds,ready,off,end");
//      SendToArduinoKeypad("start,leds,arm,off,end");
//      //label2.ForeColor = Color.Red;
//
//    }
//    if ((lineParts[1] == "detectors") && (lineParts[3] == "tamper_closed")) {
//      //turn off the tamper led
//      SendToArduinoKeypad("start,leds,trouble,off,end");
//
//      //update the ready list and led
//      setState(() {
//        update_ready_list("Tamper Opened");
//      });
//    }
//    if ((lineParts[1] == "contact") && (lineParts[3] == "closed")) {
//      //turn off the contact led
//      SendToArduinoKeypad("start,leds,contact,off,end");
//
//      //update the ready list and led
//      setState(() {
//        update_ready_list("Contact Opened");
//        GlobalParameters.contact_state = Text("Close",
//          style: TextStyle(
//              color: Colors.lightGreen
//          ),
//        );
//      });
//    }
    if (GlobalParameters.memory.length != 0)
      {
        setState(() {
          GlobalParameters.shortcuts.add(MainShourtcut(GlobalParameters.memory.length.toString(),Icon(Icons.notifications_active,color: Colors.redAccent,size: 35),"memory"));
        });
      }
  }

  void ReceiverProcessData(String value) {
    var lineParts = value.split(',');
    if (lineParts.length < 5) {
      return;
    }
    if (lineParts[3] == "arm")//build pach for the keyfob //TODO: fix in the future
    {
      lineParts[3] = "arm_away";
    }
    //List<String> notReadyParts = new List<String>();
    //string[] notReadyParts;

    ////////////////////////////////////////////////////////////
    if (lineParts[3] == "arm_away") {
      arm_activity(lineParts[3],CallingSource.keyfob);
    }
    if (lineParts[3] == "arm_home")  {
      arm_activity(lineParts[3],CallingSource.keyfob);
    }
    if ((lineParts[3] == "arm_home") && (ready_not_ready == false) ||
        (lineParts[3] == "arm_away") && (ready_not_ready == false)) {
      SendToArduinoKeypad("start,buzzer,1,fail,5000,end");
    }
    if (lineParts[3] == "disarm") {
      arm_activity("Disarm", CallingSource.keyfob);
      //label1.Text = "-----";
      //label1.ForeColor = Color.Black;
      //label2.ForeColor = Color.Green;
    }
    ////////////////////////////////////////////////////////////
    if ((lineParts[1] == "pir") && (arm_state == "Arm away")) {
      //label1.Text = "Alarm";
      //label1.ForeColor = Color.Red;
      //SendToArduinoKeypad("start,leds,alarm,on,end");
      //SendToArduinoKeypad("start,leds,pir,pulse,2000,end");
      //port.WriteLine("start,leds,alarm,on,end");
      alarm_process(AlarmCallingSource.pir, arm_state);
//      setState(() {
//
//        alarm_current_color = Colors.red;
//        alarm_state = "Alarm";
//
//      });



//      var log_key = UniqueKey();
//      _downloadAndSavePhoto(encodedCredentials,
//          'http://10.0.0.21/ISAPI/Streaming/channels/1/picture',log_key , true);
//      var my_event = add_event("PIR Alarm!!",true,log_key);

           //_downloadAndSavePhoto(encodedCredentials,'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
    }
    if (lineParts[1] == "pir") {
      SendToArduinoKeypad("start,leds,pir,pulse,2,end");
      GlobalParameters.pir_event = Text("Detected");
      startPirEvent();
    }


    if (((lineParts[1] == "contact") &&
        (lineParts[3] == "opened") &&
        (arm_state == "Arm away"))
        ||
        ((lineParts[1] == "contact") &&
            (lineParts[3] == "opened") &&
            (arm_state == "Arm home"))) {

      alarm_process(AlarmCallingSource.contact, arm_state);
     // activate_alarm(arm_state);

    }
    if ((lineParts[1] == "contact") &&
        (lineParts[3] == "opened") &&
        (arm_state != "Arm away") &&
        (arm_state != "Arm home"))
    {
      SendToArduinoKeypad("start,leds,contact,on,end");
      SendToArduinoKeypad("start,leds,ready,off,end");
      setState(() {
        current_icon = Icon(
          Icons.lock_open,
          color: Colors.green,
          size: 76,
        );
        if (GlobalParameters.bypass_or_not == false)
        {
          ready_not_ready = false;
        }
        GlobalParameters.notReadyParts.add("Contact Opened");
        GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));
        GlobalParameters.contact_state = Text("Open",
            style: TextStyle(
            color: Colors.redAccent
          ),
        );
        audio_producer(); ///////////////////////////////////////////////////////////////////////
        _show_snack_bar();
        print("snack bar enabled");
        //downloadAndSavePhoto(encodedCredentials,
         //   'http://10.0.0.21/ISAPI/Streaming/channels/1/picture');
        active_chime();
      });
    }

    if ((lineParts[1] == "detectors") &&
        (lineParts[3] == "tamper_opened") &&
        (arm_state == "Arm away")) {
      //label1.Text = "Alarm";
      //label1.ForeColor = Color.Red;
      SendToArduinoKeypad("start,leds,alarm,on,end");
      setState(() {
        alarm_current_color = Colors.red;
        alarm_state = "Alarm";
      });
    }
    ////////////////////////////////////////////////////////////
    if ((lineParts[1] == "detectors") &&
        (lineParts[3] == "tamper_opened") &&
        (arm_state == "Disarm") &&
        (ready_state == "Ready")) {
      if (GlobalParameters.notReadyParts.contains("Tamper Opened") == false) {
        setState(() {
          ready_state = "Not ready";
          current_icon = Icon(
            Icons.lock_open,
            color: Colors.green,
            size: 76,
          );
          GlobalParameters.notReadyParts.add("Tamper Opened"); /////////////////////////////////////////
          GlobalParameters.troubles.add(TroubleCell("Tamper Opened",Icon(Icons.warning,color: Colors.redAccent,),"tamper opened"));
        });
        SendToArduinoKeypad("start,leds,trouble,on,end");
        SendToArduinoKeypad("start,leds,ready,off,end");
      }
      //textBox2.Text = "";
      for (int i = 0; i < GlobalParameters.notReadyParts.length; i++) {
        //textBox2.Text += notReadyParts[i].ToString() + "\n";
      }
      //textBox2.Text = notReadyParts.ToString();
      //label2.Text = "Disarm,Not ready";

      //SendToArduino("start,leds,ready,off,end");
//      SendToArduinoKeypad("start,leds,arm,off,end");
//      SendToArduinoKeypad("start,leds,alarm,on,end");
//      //label2.ForeColor = Color.Red;
//      setState(() {
//        current_icon = Icon(
//          Icons.lock_open,
//          color: Colors.green,
//          size: 76,
//        );
//        arm_state = "Disarm";
//        ready_state = "Not ready";
//        if (GlobalParameters.bypass_or_not == false)
//        {
//          ready_not_ready = false;
//        }
//        alarm_current_color = Colors.red;
//        alarm_state = "Alarm";
//      });
    }
    if ((lineParts[1] == "contact") &&
        (lineParts[3] == "opened") &&
        (arm_state == "Disarm") &&
        (ready_state == "Ready")) {
      if (GlobalParameters.notReadyParts.contains("Contact Opened") == false) {
        setState(() {
          current_icon = Icon(
            Icons.lock_open,
            color: Colors.green,
            size: 76,
          );
          GlobalParameters.notReadyParts.add("Contact Opened");

          GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));

          GlobalParameters.contact_state = Text("Open",
            style: TextStyle(
                color: Colors.redAccent
            ),
          );
        });

        SendToArduinoKeypad("start,leds,ready,off,end");
        SendToArduinoKeypad("start,leds,contact,on,end");
      }

      setState(() {
        arm_state = "Disarm";
        ready_state = "Not ready";
        if (GlobalParameters.bypass_or_not == false)
        {
          ready_not_ready = false;
        }
      });
      //label2.Text = "Disarm,Not ready";

      //SendToArduino("start,leds,ready,off,end");
      SendToArduinoKeypad("start,leds,arm,off,end");
      //label2.ForeColor = Color.Red;

    }
    if ((lineParts[1] == "detectors") && (lineParts[3] == "tamper_closed")) {
      //turn off the tamper led
      SendToArduinoKeypad("start,leds,trouble,off,end");

      //update the ready list and led
      setState(() {
        update_ready_list("Tamper Opened");
      });
    }
    if ((lineParts[1] == "contact") && (lineParts[3] == "closed")) {
      //turn off the contact led
      SendToArduinoKeypad("start,leds,contact,off,end");

      //update the ready list and led
      setState(() {
        update_ready_list("Contact Opened");
        GlobalParameters.contact_state = Text("Close",
          style: TextStyle(
              color: Colors.lightGreen
          ),
        );
      });
    }
  }
  void activate_alarm(String event)
  {

    SendToArduinoKeypad("start,leds,alarm,on,end");
    SendToArduinoKeypad("start,leds,contact,on,end");
    SendToArduinoKeypad("start,leds,ready,off,end");
    setState(() {
      if (event == "Arm away")
      {
        current_icon = Icon(
          Icons.lock,
          color: Colors.redAccent,
          size: 76,
        );
      }
      else if (event == "Arm home")
      {
        current_icon = Icon(
          Icons.home,
          color: Colors.redAccent,
          size: 76,
        );
      }
//      alarm_current_color = Colors.red;
//      alarm_state = "Alarm";
      if (GlobalParameters.bypass_or_not == false)
      {
        ready_not_ready = false;
      }

      GlobalParameters.notReadyParts.add("Contact Opened");

      GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));

      GlobalParameters.contact_state = Text("Open",
        style: TextStyle(
            color: Colors.redAccent
        ),
      );
      var log_key = UniqueKey();
      _downloadAndSavePhoto(encodedCredentials,
          'http://10.0.0.21/ISAPI/Streaming/channels/1/picture',log_key ,true);
      var my_event = add_event("Contact Alarm!!",true,log_key);
    });
  }
  static Future<Map> siren_command(String device_id, String siren_command) async {
    List<int> argument = new List<int>();
//    argument.add(command);
    List<Commands> commands = new List<Commands>();
    Commands command = new Commands(
        capability: "alarm",
        component: "main",
        command: "$siren_command",
        arguments: argument
    );
    commands.add(command);
    SirenCommand send_command = new SirenCommand(commands: commands);
    Map<String, dynamic> json_command = send_command.toJson();
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
  void alarm_process(AlarmCallingSource source, String event)
  {
    var log_key = UniqueKey();
    switch (source)
    {
      case AlarmCallingSource.pir:
      {
        //SendToArduinoKeypad("start,leds,pir,pulse,2,end");
        add_event("PIR Alarm!!",true,log_key);

      }
      break;
      case AlarmCallingSource.contact:
      {
        SendToArduinoKeypad("start,leds,contact,on,end");
        GlobalParameters.notReadyParts.add("Contact Opened");
        setState(() {
          GlobalParameters.troubles.add(TroubleCell("Contact Opened",Icon(Icons.warning,color: Colors.redAccent,),"contact opened"));
        });


        GlobalParameters.contact_state = Text("Open",
          style: TextStyle(
              color: Colors.redAccent
          ),
        );
        add_event("Contact Alarm!!",true,log_key);
      }
      break;

    }
    siren_command("e39164fb-5c02-4c4d-8577-95eba87786ef", "both");
    SendToArduinoKeypad("start,leds,alarm,on,end");
    SendToArduinoKeypad("start,leds,ready,off,end");
    setState(() {
      if (event == "Arm away")
      {
        current_icon = Icon(
          Icons.lock,
          color: Colors.redAccent,
          size: 76,
        );
      }
      else if (event == "Arm home")
      {
        current_icon = Icon(
          Icons.home,
          color: Colors.redAccent,
          size: 76,
        );
      }
      alarm_current_color = Colors.red;
      alarm_state = "Alarm";
      if (GlobalParameters.bypass_or_not == false)
      {
        ready_not_ready = false;
      }

      //
      SendToArduinoReceiver("start,siren,0,on,${GlobalParameters.sirenSelectedLocation},end");
      _downloadAndSavePhoto(encodedCredentials,
          'http://10.0.0.21/ISAPI/Streaming/channels/1/picture',log_key ,true);

    });
  }
  void disarm_alarm_process()
  {
    //send to receiver
    siren_command("e39164fb-5c02-4c4d-8577-95eba87786ef", "off");
    SendToArduinoReceiver("start,siren,0,off,end");
    //
  }
  void KeypadProcessData(String value) {
//    print(value);
//    var lineParts = value.split(',');
//    int lines_counter = 0;
//    List<int> indexes_of_start = new List<int>();
//    if (lineParts.length < 5)
//    {
//      return;
//    }
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(value);

    for (int i = 0; i < lines.length; i++) {
      message_proccesing(lines[i]);
    }
//    for (int i = 0;i < indexes_of_start.length;i ++)
//    {
//      var message = value.split("\n");
//
//      message_proccesing(message.toString());
//    }

//    print(lineParts[1]);
//    if (lineParts[1] == "KeyPadCode")
//    {
//      print("code");
//      user_code = lineParts[3];
//      print("user code: " + user_code);
//    }
    //List<String> notReadyParts = new List<String>();
    //string[] notReadyParts;
  }

  void arm_activity(String event,CallingSource source)
  {
    switch (source) {
      case CallingSource.keyfob:
        print("keyfob source");
        break;
      case CallingSource.keypad:
        print("keypad source");
        break;
      case CallingSource.smartphone_button:
        print("smartphone button source");
        break;
      default:
        break;
    }
    if ((event == "Disarm") && (arm_state != "Disarm"))
    {
      current_icon = Icon(
        Icons.lock_open,
        color: Colors.green,
        size: 76,
      );
      setState(() {
        if (source == CallingSource.keyfob)
          GlobalParameters.keyfob_last_event = Text("Last Pressed: Disarm");
        GlobalParameters.ByPassList.clear();
        ready_or_not();
        alarm_current_color = Colors.lightGreen;
        alarm_state = "";
        current_speak_text = "System disarmed";
        _speak(current_speak_text);
        add_event("System disarmed",false);
        if (secondsPassed != 0)
        {
          secondsPassed = 0;
          sub.cancel();
        }

      });

      SendToArduinoKeypad("start,timer,off,15,end");

      SendToArduinoKeypad("start,buzzer,1,stop,end");

      SendToArduinoKeypad("start,leds,arm,off,end");
      //update alarm
     disarm_alarm_process();

      SendToArduinoKeypad("start,leds,alarm,off,end");
    }
    if (event == "arm_away")
    {
      if  ((ready_not_ready == true) || (listEquals(GlobalParameters.ByPassList, GlobalParameters.notReadyParts) == true))
      {

        setState(() {
          if (source == CallingSource.keyfob)
            GlobalParameters.keyfob_last_event = Text("Last Pressed: Arm away");
          current_icon = Icon(
            Icons.lock,
            color: Colors.redAccent,
            size: 76,
          );
          arm_state = "Arm away";
          ready_state = "";
          current_speak_text = "Arming away please exit now";
          _speak(current_speak_text);
          add_event("System armed away",false);
        });
        SendToArduinoKeypad("start,leds,arm,on,end");
        if (GlobalParameters.exitSelectedLocation != null)
        {
          List<String> items = GlobalParameters.exitSelectedLocation.split(' ');
          String exit_time = items[0];
          if (exit_time != "Disabled")
          {
            SendToArduinoKeypad("start,buzzer,1,long_beep," + exit_time + ",end");
            String timer_command = "";

            GlobalParameters.current_delay_time = int.parse(exit_time);
            timer_command = "start,timer,on," + exit_time + ",end";
            SendToArduinoKeypad(timer_command);
          }
        }


        //start the exit delay window
        secondsPassed = GlobalParameters.current_delay_time;
        if (GlobalParameters.current_delay_time != 0) {
          _start = GlobalParameters.current_delay_time;
          startExitDelayTimer();
        }

      }
      else
      {
        sleep(const Duration(milliseconds: 100));
        SendToArduinoKeypad("start,buzzer,1,fail,end");
      }
    }
    else if (event == "arm_home")
    {
      if ((ready_not_ready == true) || (listEquals(GlobalParameters.ByPassList, GlobalParameters.notReadyParts) == true))
      {
        setState(() {
          current_icon = Icon(
            Icons.home,
            color: Colors.orange,
            size: 76,
          );
          arm_state = "Arm home";
          ready_state = "";
          current_speak_text = "Arming home";
          _speak(current_speak_text);

          add_event("System armed home",false);
        });
      }
      else
      {
        sleep(const Duration(milliseconds: 100));
        SendToArduinoKeypad("start,buzzer,1,fail,end");
      }

      //SendToArduinoKeypad("start,buzzer,1,long_beep,11000,end");
      //SendToArduinoKeypad("start,leds,arm,on,end");
    }
  }



  void message_proccesing(String message) {
    var lineParts = message.split(',');
    String timer_command = "";
    if (lineParts.length < 5) {
      return;
    }
    print(lineParts[1]);

    if (lineParts[3] == "Arm_away") {
      arm_activity("arm_away", CallingSource.keypad);
    }
    else if (lineParts[3] == "Disarm") {
      _speak("Please enter code");
    }



    if (lineParts[1] == "KeyPadCode") {
      print("code");
      user_code = lineParts[3];
      print("user code: " + user_code);
      if (user_code == GlobalParameters.user_default_code) {
        SendToArduinoKeypad("start,buzzer,1,success,end");
        //SendToArduinoKeypad("start,timer,off,15,end");
        arm_activity("Disarm", CallingSource.keypad);
      } else {
        sleep(const Duration(milliseconds: 100));
        SendToArduinoKeypad("start,buzzer,1,fail,end");
      }
    }
  }

  void active_chime() {
    switch (GlobalParameters.chimeSelectedLocation) {
      case "Happy beep":
        {
          SendToArduinoKeypad("start,buzzer,1,success,end");
        }
        break;
      case "Door opened":
        {
          _speak(GlobalParameters.chimeSelectedLocation);
        }
        break;
      case "Ding dong":
        {}
        break;
      default:
        {}
        break;
    }
  }

  void update_ready_list(String cause) {
    for (int i = 0; i < GlobalParameters.notReadyParts.length; i++) {
      if (GlobalParameters.notReadyParts[i] == cause) {
        GlobalParameters.notReadyParts.remove(GlobalParameters.notReadyParts[i]);
        //textBox2.Text = "";
        for (int j = 0; j < GlobalParameters.notReadyParts.length; j++) {
          //textBox2.Text += notReadyParts[j].ToString();
          //textBox2.Text += "\n";
        }
        //2. update the ready list and led
        ready_or_not();
      }
    }
  }

  LogEvent add_event(String current_event,bool has_image,[var log_key])  {

    DateTime now = new DateTime.now();
    //String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    String formattedDate = DateFormat('yyyy.MM.dd , HH:mm:ss ').format(now);
    var my_log_key = UniqueKey();

    String filePathAndName = "";
    if (has_image == true)
    {
      my_log_key = log_key;
      filePathAndName = GlobalParameters.documentDirectory.path + '/images/pic_${my_log_key}.jpg';
    }

    LogEvent event = new LogEvent(formattedDate, current_event, my_log_key, has_image, filePathAndName);
    LogEvent.LogEvents.add(event);
    return event;
  }

  void ready_or_not() {
    if (GlobalParameters.notReadyParts.length == 0) {
      //label2.Text = "Disarm,Ready";
      arm_state = "Disarm";
      ready_state = "Ready";
      SendToArduinoKeypad("start,leds,ready,on,end");
      //label2.ForeColor = Color.Green;
      ready_not_ready = true;
    }
    else if (GlobalParameters.notReadyParts.length != 0) {
      //label2.Text = "Disarm,Ready";
      arm_state = "Disarm";
      ready_state = "Not Ready";
      SendToArduinoKeypad("start,leds,ready,off,end");
      //label2.ForeColor = Color.Green;
      ready_not_ready = false;
    }
  }

  void SendToArduinoTestReceiver(String protocol) async {
    String data = protocol + "\r\n";
    receiver_test_socket.write(protocol + "\n");
    print(protocol);
    //await _port.write(Uint8List.fromList(data.codeUnits));
  }

  void SendToArduinoReceiver(String protocol) async {
    String data = protocol + "\r\n";
    receiver_socket.write(protocol + "\n");
    print(protocol);
    //await _port.write(Uint8List.fromList(data.codeUnits));
  }

  void SendToArduinoKeypad(String protocol) async {
    String data = protocol + "\r\n";
    print(protocol);
    keypad_socket.write(protocol + "\n");
    //await _port.write(Uint8List.fromList(data.codeUnits));
  }

  Future _speak(String speak_text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.6);

    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    var result = await flutterTts.speak(speak_text);
    //if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _show_snack_bar() {
    snackBar = new SnackBar(
      content: Text("Contact opened!"),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

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

  Widget state_container() {
    var container_item = Container(
        //height: 5,
        alignment: Alignment.centerRight,
        padding: new EdgeInsets.symmetric(),
        child: new ListTile(
          leading: current_icon,
          title: Text(arm_state,
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: 1.0, color: Colors.black)),
          //style: TextStyle(fontSize: 16.0,,color: Colors.green,fontWeight: FontWeight.bold)),
          subtitle: Text(ready_state,
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: 1.0, color: Colors.black)),
        ));

    return container_item;
  }

  List<String> getListElements() {
    var items = List<String>.generate(10, (counter) => "Item $counter");
    return items;
  }

  Widget ready_container() {
    var container_item = Container(
      height: 100.0,
      alignment: Alignment.centerRight,
      padding: new EdgeInsets.symmetric(),
      child: getListView(),
    );
//    var not_ready_item_card = Card(
//        child: ListTile(
//          //leading: Text(card.event_name),
//          title: Text(getListView[),
//          //trailing: card.has_image == true ? ImageIconButton(context, card.u_key) : null,
//          //
//          subtitle: Padding(
//            padding: const EdgeInsets.only(top: 10),
//            child: Text(card.event_time, style: new TextStyle(fontSize: 15.0)),
//          ),
//        )),
    return container_item;
  }

  Widget getListView() {
    var listItems = GlobalParameters.notReadyParts;
    var listView = ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text(listItems[index]),
          );
        });
    return listView; //////////////////////////////////////////////////////////////////////////////////////////
  }

  void startPirEvent() {
    countDownTimer = new CountdownTimer(
      new Duration(seconds: 8),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      //setState(() { _current = _start - duration.elapsed.inSeconds; });secondsPassed
      setState(() {
        secondsPassed = _start - duration.elapsed.inSeconds;
      });
      print(secondsPassed.toString());
    });

    sub.onDone(() {
      //print("Done");
      setState(() {
        GlobalParameters.pir_event = Text("");
      });
      sub.cancel();
    });
  }

  //from https://stackoverflow.com/questions/54610121/flutter-countdown-timer

  //example:countDownTimer
  int _start = 0;

  //int _current = 10;
  void startExitDelayTimer() {
    countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      //setState(() { _current = _start - duration.elapsed.inSeconds; });secondsPassed
      setState(() {
        secondsPassed = _start - duration.elapsed.inSeconds;
      });
      print(secondsPassed.toString());
    });

    sub.onDone(() {
      if (GlobalParameters.entry_delay_time == true)
        {
          alarm_process(AlarmCallingSource.contact, arm_state);
          GlobalParameters.entry_delay_time = false;
        }
      print("Done");

      sub.cancel();
    });
  }

  Widget ShowExitDelayTimer() {
    final String label = "SEC";

    if (secondsPassed == 0)
    //if ((label == "") && (secondsPassed.toString() == ""))
    {
      return Container(
//        margin: EdgeInsets.symmetric(horizontal: 5),
//        padding: EdgeInsets.all(),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.teal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$secondsPassed', //secondsPassed.toString(),//'$secondsPassed',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10
            ),
          ),
        ],
      ),
    );
  }


  /////////////////////////

  Future<Map> _st_get_devices_test() async {
    Map data;
//    HttpClient client = new HttpClient();
//    String myUrl = "https://api.smartthings.com/v1/devices";
//    client.getUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
//      request.headers.add(HttpHeaders.authorizationHeader,
//          ""); //removeAll(HttpHeaders.acceptEncodingHeader);
//      return request.close(); //.timeout(const Duration(seconds: 8));
//    }).then((HttpClientResponse response) async {
//      print(response.headers.toString());
//      print(response.statusCode.toString());
//      var responseBody = await response.transform(utf8.decoder).join();
//      Map data = await json.decode(responseBody);
//      print(data);
//      return data;
//
//
//    });


    HttpClient client = new HttpClient();
    String myUrl = "https://api.smartthings.com/v1/devices";
    await client.getUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
      request.headers.add(HttpHeaders.authorizationHeader,
          "YOUR TOKEN HERE");
      return request.close();
    }).then((HttpClientResponse response) async {
      print(response.headers.toString());
      print(response.statusCode.toString());
      var responseBody = await response.transform(utf8.decoder).join();
      data = json.decode(responseBody);
      //return "dandan";
    });


    return data;
//    Future.delayed(
//      Duration(seconds: 0),
//
//    );
    //return "dandan";
  }
  void st_collect_all_devices_status() async
  {
    var devices;
    //get devices(json)
    devices = await _st_get_devices_test();

    //converts the json to a list(DevicesList)
    await Device.st_devices(devices);

    //get status to every device in DevicesList
    for (int i = 0;i < Device.DevicesList.length;i ++)
    {
      var status;
      var _pmt = await get_device_status(Device.DevicesList[i].deviceId,i);
      if (_pmt != null)
        {
          status = Components.fromJson(_pmt["components"]);
        }
      await set_status(i,status);
      print("device data: $_pmt, $i, ${Device.DevicesList[i].label},${Device.DevicesList[i].deviceId}");
      //print("status: ${Device.DevicesList[index].status.main.contactSensor.contact.value}");
//      if (Device.DevicesList[i].status != null) {
//        if (Device.DevicesList[i].capabilities.contains("contactSensor")) {
//          if (Device.DevicesList[i].status.main.contactSensor.contact.value !=
//              GlobalParameters
//                  .last_contact_device_val) //GlobalParameters.LastDevicesList[index].status.main.contactSensor.contact.value)
//              {
//            DeviceReceiverProcessData(Device.DevicesList[i]);
//          }
//        }
//        if (Device.DevicesList[i].capabilities.contains("motionSensor")) {
//          if (Device.DevicesList[i].status.main.motionSensor.motion.value !=
//              GlobalParameters
//                  .last_pir_device_val) //GlobalParameters.LastDevicesList[index].status.main.contactSensor.contact.value)
//              {
//            DeviceReceiverProcessData(Device.DevicesList[i]);
//          }
//        }
//      }
//      print("Device id: ${Device.DevicesList[i].deviceId}");
//      print("end get_device_status");
    }
    print('end of get status');
    update_low_battery();
    for (int i = 0; i < Device.DevicesList.length; i ++) {
      if (Device.DevicesList[i].capabilities.contains("contactSensor") == true)
        {
          GlobalParameters.contact_devices.add(Device.DevicesList[i]);
        }
      else if (Device.DevicesList[i].capabilities.contains("motionSensor") == true)
      {
        GlobalParameters.pir_devices.add(Device.DevicesList[i]);
      }
      else if (Device.DevicesList[i].capabilities.contains("presenceSensor") == true)
      {
        GlobalParameters.arrival_devices.add(Device.DevicesList[i]);
      }
      else if (Device.DevicesList[i].capabilities.contains("alarm") == true)
      {
        GlobalParameters.siren_devices.add(Device.DevicesList[i]);
      }
      else if (Device.DevicesList[i].capabilities.contains("light") == true)
      {
        GlobalParameters.light_devices.add(Device.DevicesList[i]);
      }
      else if (Device.DevicesList[i].capabilities.contains("button") == true)
      {
        GlobalParameters.keyfob_devices.add(Device.DevicesList[i]);
      }


//      switch (Device.DevicesList[i].detector_section) {
//        case "motion":
//          {
//            GlobalParameters.pir_devices.add(Device.DevicesList[i]);
//          }
//          break;
//        case "contact":
//          {
//            GlobalParameters.contact_devices.add(Device.DevicesList[i]);
//          }
//          break;
//      }

    }
    sort_devices();
    print("sorted");
  }
  void sort_devices()
  {
    GlobalParameters.contact_devices.forEach((device) => GlobalParameters.SortedDevicesList.add(device));
    GlobalParameters.pir_devices.forEach((device) => GlobalParameters.SortedDevicesList.add(device));
    GlobalParameters.siren_devices.forEach((device) => GlobalParameters.SortedDevicesList.add(device));
    GlobalParameters.keyfob_devices.forEach((device) => GlobalParameters.SortedDevicesList.add(device));
    GlobalParameters.arrival_devices.forEach((device) => GlobalParameters.SortedDevicesList.add(device));
    GlobalParameters.light_devices.forEach((device) => GlobalParameters.SortedDevicesList.add(device));
    Device.DevicesList = GlobalParameters.SortedDevicesList;
//    for (int i = 0;i < GlobalParameters.contact_devices.length;i ++)
//    {
//      GlobalParameters.SortedDevicesList.add(GlobalParameters.contact_devices[i]);
//    }
//    for (int i = 0;i < GlobalParameters.pir_devices.length;i ++)
//    {
//      GlobalParameters.SortedDevicesList.add(GlobalParameters.pir_devices[i]);
//    }
//    for (int i = 0;i < GlobalParameters.arrival_devices.length;i ++)
//    {
//      GlobalParameters.SortedDevicesList.add(GlobalParameters.pir_devices[i]);
//    }
//    for (int i = 0;i < GlobalParameters.pir_devices.length;i ++)
//    {
//      GlobalParameters.SortedDevicesList.add(GlobalParameters.pir_devices[i]);
//    }
//    for (int i = 0;i < GlobalParameters.pir_devices.length;i ++)
//    {
//      GlobalParameters.SortedDevicesList.add(GlobalParameters.pir_devices[i]);
//    }
//    for (int i = 0;i < Device.DevicesList.length;i ++)
//    {
//      for (int j = 0;j < GlobalParameters.SortedDevicesList.length;j ++)
//      {
//        if (Device.DevicesList[i] != GlobalParameters.SortedDevicesList[j])
//          {
//
//          }
//        if (GlobalParameters.SortedDevicesList.contains(Device.DevicesList[i]) == false)
//        {
//          GlobalParameters.SortedDevicesList.add(GlobalParameters.pir_devices[i]);
//        }
//      }
//    }
  }
  /////////////////////////
  void update_low_battery()
  {
    String str_low_battery_precentege = GlobalParameters.selected_low_battery_percent.replaceAll("%","");
    int low_battery_precentege = int.parse(str_low_battery_precentege);
    for (int i = 0;i < Device.DevicesList.length;i ++) {
      if (Device.DevicesList[i].capabilities.contains("battery")) {
        if (Device.DevicesList[i].status == null) {
          print("there is no status to ${Device.DevicesList[i].deviceId}");
        }
        else {
          if (Device.DevicesList[i].status.main.battery.battery.value <=
              low_battery_precentege) {
            //TODO: send notification
            setState(() {
              GlobalParameters.troubles.add(TroubleCell(
                  "Low battery to ${Device.DevicesList[i].label}",
                  Icon(Icons.battery_alert, color: Colors.redAccent),
                  "low battery"));
            });
            DateTime now = new DateTime.now();
            String formattedDate = DateFormat('yyyy.MM.dd , HH:mm:ss ')
                .format(now);
            var my_log_key = UniqueKey();
            LogEvent event = new LogEvent(formattedDate,
                "Low battery to ${Device.DevicesList[i].label}", my_log_key,
                false, "");
            LogEvent.LogEvents.add(event);
          }
        }
      }
    }
  }
  Future<Map> _st_get_devices() async {
//    var myHeaders = new Headers();
//    myHeaders.append("Authorization", "");
//
//    var requestOptions = {
//      method: 'GET',
//      headers: myHeaders,
//      redirect: 'follow'
//    };
//
//    fetch("https://api.smartthings.com/v1/devices", requestOptions)
//        .then(response => response.text())
//        .then(result => console.log(result))
//        .catch(error => console.log('error', error));
//


  //python
//    import http.client
//    import mimetypes
//    conn = http.client.HTTPSConnection("api.smartthings.com")
//    payload = ''
//    headers = {
//      'Authorization': ''
//    }
//    conn.request("GET", "/v1/devices", payload, headers)
//    res = conn.getresponse()
//    data = res.read()
//    print(data.decode("utf-8"))

    HttpClient client = new HttpClient();

    //client.runtimeType = const Type(dart:);

//    var request = await HttpClient().getUrl(Uri.parse(url))
//        .then((HttpClientRequest request) {
//      //request.headers.authorizationHeader: "Basic $encodedCredentials",
//      request.headers.add(HttpHeaders.authorizationHeader, "Basic $encodedCredentials");//removeAll(HttpHeaders.acceptEncodingHeader);
//
//      var response = request.close();
//      await for (var contents in response.listen((d) => _downloadData.addAll(d),
//          onDone: () {
//            fileSave.writeAsBytes(_downloadData);
//            setState(() {
//              // When the data is available, display it
//              imageData = filePathAndName;
//              dataLoaded = true;
//            });
//          }
//      );
    String myUrl = "https://api.smartthings.com/v1/devices";
    //var _downloadData = List<int>();
    client.getUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {

      //request.headers.authorizationHeader: "Basic $encodedCredentials",
      request.headers.add(HttpHeaders.authorizationHeader,
      "YOUR TOKEN HERE"); //removeAll(HttpHeaders.acceptEncodingHeader);
      //request.co
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      return request.close(); //.timeout(const Duration(seconds: 8));
    }).then((HttpClientResponse response) async {
      // Process the response.
      //response.headers.forEach((k,v) => print (k+" : "+v));
      print(response.headers.toString());
      print(response.statusCode.toString());
      //final body
      //response.transform(Utf8Decoder()).listen(print);
      //response.transform(utf8.decoder /*5*/).forEach(print);
      var responseBody = await response.transform(utf8.decoder).join();
      //var responseBody = await response.transform(Utf8Decoder()).join();
      //print(responseBody);
      Map data = json.decode(responseBody);

      //List<String> st_devices_name = new List<String>();
      print(data);
      //st_devices_name.add(data["items"][0]['name']);
      //Map mydata = data["items"].length;
      print(data);
      //return data;
      //int len = mydata.length

      print("start Device.st_devices");
      await Device.st_devices(data);
      print("end Device.st_devices");
      int len = Device.DevicesList.length;
      for (int i = 0;i < len;i ++)
      {
        //print("start get_device_status");
        get_device_status(Device.DevicesList[i].deviceId,i);
        print("Device id: ${Device.DevicesList[i].deviceId}");
//        if (Device.DevicesList[i].capabilities.contains("contactSensor") == true)
//        {
//          print("Contact status: ${Device.DevicesList[i].status.main.contactSensor.contact.value}");
//        }
        print("end get_device_status");
        //Map values = device_status["components"]["main"][Device.capabilities_status[i]];
      }

      print('end of get status');

      for (int i = 0;i < Device.DevicesList.length;i ++)
      {
        switch(Device.DevicesList[i].detector_section)
        {
          case "motion":
            {
              GlobalParameters.pir_devices.add(Device.DevicesList[i]);
            }
            break;
          case "contact":
            {
              GlobalParameters.contact_devices.add(Device.DevicesList[i]);
            }
            break;
        }
      }
//      for (int i = 0; i < data["items"].length;i ++)
//      {
//        st_devices_name.add(data["items"][i]['name']);
//      }
      //String json = EntityUtils.toString(response.getEntity());
      //JSONObject jsonObj = new JSONObject("yourJsonString");
      //final body = jsonDecode(utf8.decode(await response.first));
      //String MyJson = response.transform(utf8.decoder /*5*/);//.forEach(print);

      //response.transform(Utf8Decoder()).listen(print);
//      Stream res_stream = response.transform(Utf8Decoder());
//      for (var data in res_stream)
//        {
//          print(data);
//        }

      //print(response.);
//      response.listen((d) => _downloadData.addAll(d), onDone: () {
//
//      });
      //response.listen((d) => _downloadData.addAll(d), onDone: () {
       // fileSave.writeAsBytes(_downloadData);
//        setState(() {
//          // When the data is available, display it
//          imageDataPath = filePathAndName;
//          dataLoaded = true;
//        });
      });
  }
  Future<Map> get_device_status(String device_id, int index) async {
    //Components pmt;
    Map data;
    HttpClient client = new HttpClient();
    String myUrl = "https://api.smartthings.com/v1/devices/" + device_id + "/status";

    print('url path:');
    print('----------------');
    print(myUrl);
    print('index $index');

    await client.getUrl(Uri.parse(myUrl)).then((HttpClientRequest request) {
      request.headers.add(HttpHeaders.authorizationHeader,
          "YOUR TOKEN HERE");
      //request.headers.add(HttpHeaders.acceptHeader, "*/*");
      //request.headers.add(HttpHeaders.acceptEncodingHeader, "gzip, deflate, br");
      //request.headers.add(HttpHeaders.acceptHeader, "*/*");
      //request.headers.add(HttpHeaders.connectionHeader, "keep-alive");
      //request.headers.add(HttpHeaders.userAgentHeader, "PostmanRuntime/7.24.1");


//      print('request Headers:');
//      print('----------------');
//
//      request.headers.forEach((k, v) {
//        print('Header: $k, value: $v');
//      });


      //print("Device request is: ${request.headers.value(HttpHeaders.userAgentHeader)}");//removeAll(HttpHeaders.acceptEncodingHeader);
      return request.close(); //.timeout(const Duration(seconds: 8));
    }).then((HttpClientResponse response) async {

//      print('response Headers:');
//      print('----------------');
//      response.headers.forEach((k, v) {
//        print('Header: $k, value: $v');
//      });
//

      print(response.headers.toString());
      //print(response.statusCode.toString());
      var responseBody = await response.transform(utf8.decoder).join();
      data = json.decode(responseBody);

    //if(device_id == 'd891ebe2-a1ef-4404-8e02-f5002065f984') {
      //var parsedJson = json.decode(responseBody);

      //final pmt = await set_pmt(Components.fromJson(data["components"]));
//      if (data != null)
//        {
//          pmt = Components.fromJson(data["components"]);//["main"]
//        }


      //setState(() {
      //print("pmt: ${pmt.main.contactSensor.contact.value}");
//      set_status(index,pmt);
//
//      //print("status: ${Device.DevicesList[index].status.main.contactSensor.contact.value}");
//      if (Device.DevicesList[index].status != null)
//        {
//          if (Device.DevicesList[index].capabilities.contains("contactSensor"))
//          {
//            if (Device.DevicesList[index].status.main.contactSensor.contact.value != GlobalParameters.last_contact_device_val)//GlobalParameters.LastDevicesList[index].status.main.contactSensor.contact.value)
//                {
//              DeviceReceiverProcessData(Device.DevicesList[index]);
//            }
//          }
//          if (Device.DevicesList[index].capabilities.contains("motionSensor"))
//          {
//            if (Device.DevicesList[index].status.main.motionSensor.motion.value != GlobalParameters.last_pir_device_val)//GlobalParameters.LastDevicesList[index].status.main.contactSensor.contact.value)
//                {
//              DeviceReceiverProcessData(Device.DevicesList[index]);
//            }
//          }
//        }

//      if (Device.DevicesList.length-1 == index)
//        {
//          for (int i = 0;i < Device.DevicesList.length;i ++)
//          {
//            if (Device.DevicesList[i] != GlobalParameters.LastDevicesList[i])
//            {
//              DeviceReceiverProcessData(Device.DevicesList[i]);
//            }
//          }
//        }
//      for (int i = 0;i < Device.DevicesList.length;i ++)
//        {
//          if (Device.DevicesList[i].capabilities.contains("contactSensor"))
//            {
//              Device.DevicesList[i].status = pmt;
//            }
//        }
      //});
//      data.entries.map((entry) => "${entry.key} + ${entry.value}").toList();
     // Map parsed = json.decode(responseBody).cast<Map<dynamic, dynamic>>();
      //parsed.map<contactDetector>((json) => contactDetector.fromJson(json)).toList();

      //var data = contactDetector(parsedJson);
      //print("Device data: $data");
    //}
      print(data);

//     print(data);
      //var a = data["components"]["main"]["switch"]["value"];
      //return data;
      //return data;
    });
    return data;
  }
  Future<Null> set_pmt(var pmt_val)
  {
    var pmt = pmt_val;
    return pmt;
  }
  Future<void> set_status(int index,var pmt) async
  {
    GlobalParameters.LastDevicesList.clear();
    if (Device.DevicesList.length-1 == index)
      {
        GlobalParameters.last_device_update = true;
      }
    else if (GlobalParameters.last_device_update == true)
    {
      if (Device.DevicesList[index].capabilities.contains("motionSensor"))
      {
        GlobalParameters.last_pir_device_val = Device.DevicesList[index].status.main.motionSensor.motion.value;
      }
      if (Device.DevicesList[index].capabilities.contains("contactSensor"))
      {
        GlobalParameters.last_contact_device_val = Device.DevicesList[index].status.main.contactSensor.contact.value;
      }
    }
//    else if (GlobalParameters.last_device_update == true)
//    {
//      if (Device.DevicesList[index].capabilities.contains("motionSensor"))
//      {
//        GlobalParameters.last_pir_device_val = Device.DevicesList[index].status.main.motionSensor.motion.value;
//      }
//      if (Device.DevicesList[index].capabilities.contains("contactSensor"))
//      {
//        GlobalParameters.last_contact_device_val = Device.DevicesList[index].status.main.contactSensor.contact.value;
//      }
//
//    }

//    if (GlobalParameters.last_device_update == false)
//      {
//        GlobalParameters.last_device_update = true;
//      }
//    else if (GlobalParameters.last_device_update == true)
//    {
//      if (Device.DevicesList[index].capabilities.contains("motionSensor"))
//      {
//        GlobalParameters.last_pir_device_val = Device.DevicesList[index].status.main.motionSensor.motion.value;
//      }
//      if (Device.DevicesList[index].capabilities.contains("contactSensor"))
//      {
//        GlobalParameters.last_contact_device_val = Device.DevicesList[index].status.main.contactSensor.contact.value;
//      }
//
//    }


//    GlobalParameters.LastDevicesList = List.from(Device.DevicesList);
//    for (int i = 0;i<Device.DevicesList.length;i ++)
//    {
//      var temporary_var = Device.DevicesList[i];
//      GlobalParameters.LastDevicesList.add(temporary_var);
//
//    }

    await device_status(index,pmt);
    print("Device ${Device.DevicesList[index].deviceId} status updated");
  }
  int _counter = 0;
  Future<Null> device_status(int index,var pmt)
  {
    Device.DevicesList[index].status = pmt;
  }
  _downloadAndSavePhoto(String authEncoded, String url, var my_key, bool use_my_key) async {
    HttpClient client = new HttpClient();

    //client.runtimeType = const Type(dart:);
    var _downloadData = List<int>();
    //var fileSave = new File('./logo.png');
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images"; //%%%
    //You'll have to manually create subdirectories
    await Directory(firstPath).create(recursive: true); //%%%
    // Name the file, create the file, and save in byte form.
    var u_key;
    if (use_my_key == true)
    {
      u_key = my_key;
    }
    else
    {
      u_key = UniqueKey();
    }

    var current_time = new DateTime.now();
    String formattedDate = DateFormat('yyyy.MM.dd , HH:mm:ss ').format(current_time);
    var filePathAndName = documentDirectory.path + '/images/pic_${u_key}.jpg';
    filePathImagesDirectory = documentDirectory.path + '/images/';
    File fileSave = new File(filePathAndName);
    pictures_pathes.add(fileSave);
    //DirectoryPath = documentDirectory.path + '/images/';
    _counter++;
    path_counter++;
//    var request = await HttpClient().getUrl(Uri.parse(url))
//        .then((HttpClientRequest request) {
//      //request.headers.authorizationHeader: "Basic $encodedCredentials",
//      request.headers.add(HttpHeaders.authorizationHeader, "Basic $encodedCredentials");//removeAll(HttpHeaders.acceptEncodingHeader);
//
//      var response = request.close();
//      await for (var contents in response.listen((d) => _downloadData.addAll(d),
//          onDone: () {
//            fileSave.writeAsBytes(_downloadData);
//            setState(() {
//              // When the data is available, display it
//              imageData = filePathAndName;
//              dataLoaded = true;
//            });
//          }
//      );

    client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      //request.headers.authorizationHeader: "Basic $encodedCredentials",
      request.headers.add(HttpHeaders.authorizationHeader,
          "Basic $encodedCredentials"); //removeAll(HttpHeaders.acceptEncodingHeader);
      //request.co
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      return request.close(); //.timeout(const Duration(seconds: 8));
    }).then((HttpClientResponse response) {
      // Process the response.
      //response.headers.forEach((k,v) => print (k+" : "+v));
      print(response.headers.toString());
      print(response.statusCode.toString());
      response.listen((d) => _downloadData.addAll(d), onDone: () {
      fileSave.writeAsBytes(_downloadData);
        setState(() {
          // When the data is available, display it
          imageDataPath = filePathAndName;
          dataLoaded = true;
        });
      });
      //response.transform(utf8.decoder).listen((contents) => print(contents));
      /*
      if (response.statusCode == 200) {
          print("Sucsess : " + response.statusCode.toString());

          // Get file from internet
          //var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; //%%%
          //var response = await get(url); //%%%
          // documentDirectory is the unique device path to the area you'll be saving in
          var documentDirectory = getApplicationDocumentsDirectory();
          var firstPath = documentDirectory.path + "/images"; //%%%
          //You'll have to manually create subdirectories
          Directory(firstPath).create(recursive: true); //%%%
          // Name the file, create the file, and save in byte form.
          var filePathAndName = documentDirectory.path + '/images/pic.jpg';


          File file = new File(filePathAndName);

          if (file.existsSync()) {
            print('file already exist');
            print('lastModifiedsync:' + file.lastModifiedSync().toString());
            //var image = await file.readAsBytes();
            //return image;
          } else {
            print('file not found downloading from server');
            //var request = await http.get(url,);
            //var bytes = await request.bodyBytes;//close();
            //await file.writeAsBytes(bytes);
            //print(file.path);
            //return bytes;
          }


          //option 1: (from other place)
          file.create(recursive: true).then((val) async {
            if (await val
                .exists()) { //just protect if the file is not exsist...
              print('file over write');
              await file.writeAsBytesSync(response.body);//.bodyBytes);
            }
          });

          //option 2: orginal , over write every time
          //file.writeAsBytesSync(response.bodyBytes); //%%%

          setState(() {
            // When the data is available, display it
            imageData = filePathAndName;
            dataLoaded = true;
          });
        }
*/
    });

//    var response = await HttpClient.get(url,
//      header:{
//        'authorization' : 'Basic $authEncoded'
//        //'content-type':'application/json'
//      },
//      )// produces a request object
//        .then((request) => request.close()) // sends the request
//        .then((response) =>
//        response.transform(Utf8Decoder()).listen(print)); // t

//    final response = await http.get(url,
//      headers: {
//        HttpHeaders.authorizationHeader: 'Basic ' + authEncoded
//        // Do same with your authentication requirement
//      },
//      //body: param,
//    ).then((request).);
/*
    var client = http.Client();
    try {
      final response = await client.get(url,
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ' + authEncoded
          // Do same with your authentication requirement
        },
        //body: param,
      );//.then((request).);
      //print(await client.get(response.bodyFields['uri']));
      response.headers.forEach((k,v) => print (k+" : "+v));
      print(response.statusCode.toString());
//      var uriResponse = await client.post('https://example.com/whatsit/create',
//          body: {'name': 'doodle', 'color': 'blue'});
//      print(await client.get(uriResponse.bodyFields['uri']));
    } finally {
      print("client.close();");
      client.close();
    }

 */
    /*
    response.headers.forEach((k,v) => print (k+" : "+v));

    if(response.statusCode==200) {
      print("Sucsess : " + response.statusCode.toString());

      // Get file from internet
      //var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; //%%%
      //var response = await get(url); //%%%
      // documentDirectory is the unique device path to the area you'll be saving in
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images"; //%%%
      //You'll have to manually create subdirectories
      await Directory(firstPath).create(recursive: true); //%%%
      // Name the file, create the file, and save in byte form.
      var filePathAndName = documentDirectory.path + '/images/pic.jpg';


      File file = new File(filePathAndName);

      if (file.existsSync()) {
        print('file already exist');
        print('lastModifiedsync:'+file.lastModifiedSync().toString());
        //var image = await file.readAsBytes();
        //return image;
      } else {
        print('file not found downloading from server');
        //var request = await http.get(url,);
        //var bytes = await request.bodyBytes;//close();
        //await file.writeAsBytes(bytes);
        //print(file.path);
        //return bytes;
      }



      //option 1: (from other place)
      file.create(recursive: true).then((val) async {
        if (await val.exists()) { //just protect if the file is not exsist...
          print('file over write');
          await file.writeAsBytesSync(response.bodyBytes);
        }
      });

      //option 2: orginal , over write every time
      //file.writeAsBytesSync(response.bodyBytes); //%%%

      setState(() {
        // When the data is available, display it
        imageData = filePathAndName;
        dataLoaded = true;
      });
    }


   */
  }
}

class MyTabs {
  final String title;
  final Color color;

  MyTabs({this.title, this.color});
}
class ChangeWallpaper extends StatefulWidget
{
  @override
  _ChangeWallpaper createState() => _ChangeWallpaper();
}
var last_index;
class _ChangeWallpaper extends State<ChangeWallpaper> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpapers"),
      ),
      body: new ListView.builder(
          itemCount: wallpapers_list.length,
          itemBuilder: (BuildContext context, int index) => buildCard(context, index)),
    );
  }
  Widget buildCard(BuildContext context, int index) {
    //https://stackoverflow.com/questions/58115148/how-to-change-height-of-a-card-in-flutter
    //last_index = index;

    if (index %3 == 0)
    {
      return Column(
        children: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 110,
                    height: 200,
                    child: GestureDetector(
                      child: FittedBox(
                        child: Image.asset(wallpapers_list[index]),
                        fit: BoxFit.fill,
                      ),
                      onTap: (){
                        setState(() {
                          current_wallpaper = wallpapers_list[index];
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
                                  child: Text("Wallpaper changed!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                                ),
                                content: FlatButton(
                                  child: Text("Close"),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            }

                          );
                        });
//                        if (s == true)
//                        {
//                          Navigator.pop(context);
//                        }
                      },
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 110,
                    height: 200,
                    child: GestureDetector(
                      child: FittedBox(
                        child: Image.asset(wallpapers_list[index+1]),
                        fit: BoxFit.fill,
                      ),
                      onTap: (){
                        setState(() {
                          current_wallpaper = wallpapers_list[index+1];
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
                                      child: Text("Wallpaper changed!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                                  ),
                                  content: FlatButton(
                                    child: Text("Close"),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              }

                          );
                        });

                      },
                    ),
                  ),
                ),
               Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 110,
                    height: 200,
                    child: GestureDetector(
                      child:FittedBox(
                        child: Image.asset(wallpapers_list[index+2]),
                        fit: BoxFit.fill,
                      ),
                      onTap: (){
                        setState(() {
                          current_wallpaper = wallpapers_list[index+2];
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
                                      child: Text("Wallpaper changed!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                                  ),
                                  content: FlatButton(
                                    child: Text("Close"),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              }

                          );
                        });

                      },
                    ),
                  ),
                ),

//                GestureDetector(
//                  child: Image.asset(wallpapers_list[index+1]),
//                  onTap: (){
//                    setState(() {
//                      current_wallpaper = wallpapers_list[index+1];
//                    });
//                  },
//                ),
//
////              Padding(
////                padding: const EdgeInsets.all(5.0),
//                GestureDetector(
//                  child: Image.asset(wallpapers_list[index+2]),
//                  onTap: (){
//                    setState(() {
//                      current_wallpaper = wallpapers_list[index+2];
//                    });
//                  },
//                ),
              //),
//            Image.file(
//              File(wallpapers_list[index+1]),
//              fit: BoxFit.cover,
//            ),
//            Image.file(
//              File(wallpapers_list[index+2]),
//              fit: BoxFit.cover,
//            ),
            ],
          ),
        ],
      );
    }
//    else if ((index % 2 == 0) && (index % 2 != 0))
//    {
//
//    }
    return Text("");
  }
}
//class LabelText extends StatelessWidget {
//  LabelText({this.label, this.value});
//
//  final String label;
//  final String value;
//
//  @override
//  Widget build(BuildContext context) {
//    if ((label == "") && (value == ""))
//    {
//      return Container(
//        margin: EdgeInsets.symmetric(horizontal: 5),
//        padding: EdgeInsets.all(40),
//      );
//    }
//
//
//    return Container(
//      margin: EdgeInsets.symmetric(horizontal: 5),
//      padding: EdgeInsets.all(20),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(25),
//        color: Colors.teal,
//      ),
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Text(
//            '$value',
//            style: TextStyle(
//                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
//          ),
//          Text(
//            '$label',
//            style: TextStyle(
//              color: Colors.white70,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
