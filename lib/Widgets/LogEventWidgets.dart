import 'dart:io';

import 'package:flutter/material.dart';
import '../Classes/log.dart';
import 'package:path_provider/path_provider.dart';
class LogEventWidgets extends StatelessWidget {
  final VoidCallback onButtonSelected;

  LogEventWidgets({
    this.onButtonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount: LogEvent.LogEvents.length,
          itemBuilder: (BuildContext context, int index) =>
              buildCard(context, index)),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    //https://stackoverflow.com/questions/58115148/how-to-change-height-of-a-card-in-flutter
    final card = LogEvent.LogEvents[index];
    return new Container(
      height: 80,
      child: Card(
          color: Colors.white70,
        //color: Colors.transparent.value,
          child: ListTile(
        //leading: Text(card.event_name),
        title: Text(card.event_name, style: new TextStyle(fontSize: 20.0)),
        trailing: card.has_image == true ? ImageIconButton(context, card.u_key) : null,
        //
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(card.event_time, style: new TextStyle(fontSize: 15.0)),
        ),
      )),
    );
    // );
  }

  Widget ImageIconButton(BuildContext context, var u_key) {
    var filePathAndName;
    return IconButton(
      onPressed: () async{
        {
          var documentDirectory = await getApplicationDocumentsDirectory();
          filePathAndName = documentDirectory.path + '/images/pic_${u_key}.jpg';
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute(filePathAndName)),
        );
      },
      icon: Icon(
        Icons.image,
        color: Colors.blue,
        size: 30,
      ),
    );
  }

}

class SecondRoute extends StatelessWidget {
  var image_path;

  SecondRoute (this.image_path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event image"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //height: 400.0,
        child: new Center(
          child: new Column(
            children: <Widget>[
              Text(image_path),
              Image.file(
                File(image_path),
                fit: BoxFit.cover,
                //width: 600.0,
                //height: 290.0
              ),
            ],
          ),
        ),
      ),
    );
  }

 // Widget image_path
}
/* old code for future use for DataTable

  Widget Log_1() {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DataTable(
          columns: [
            DataColumn(label: Text("Event")),
            DataColumn(label: Text("Time")),
          ],
          rows: LogEvent.LogEvents.map(
            (itemRow) => DataRow(
              cells: [
                DataCell(
                  Text(itemRow.event_name),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(itemRow.event_time),
                  showEditIcon: false,
                  placeholder: false,
                  //onTap: {},
                ),
              ],
            ),
          ).toList(),
        ),
      ],
    ));
  }

  Widget log2(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: [
              const Text('Log events'),
              Container(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("Event")),
                        DataColumn(label: Text("Time")),
                      ],
                      rows: LogEvent.LogEvents.map(
                        (itemRow) => DataRow(
                          cells: [
                            DataCell(
                              Text(itemRow.event_name),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(itemRow.event_time),
                              showEditIcon: false,
                              placeholder: false,
                              //onTap: {},
                            ),
                          ],
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


// row and columns

//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10.0),
//        ),
//        elevation: 5,
//        child: Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(top: 3.0,bottom: 3.0),
//              child: Row(children: <Widget>[
//                Text(card.event_name,style: new TextStyle(fontSize: 20.0),),
//                Spacer(),
//                SizedBox(
//                  width: 100.0,
//                  height: 100.0,
//                  child: FlatButton(
//                    child: Icon(
//                      Icons.image,
//                      color: Colors.white,
//                    ),
//                    color: Color.fromRGBO(68, 153, 213, 1.0),
//                    shape: CircleBorder(),
//                    onPressed: () {},
//                  ),
//                ),
//              ],)
//            ),
//            Text(card.event_time,style: new TextStyle(fontSize: 15.0)),
//          ],
//        ),


 */
