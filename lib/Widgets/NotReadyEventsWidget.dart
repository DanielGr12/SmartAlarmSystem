import 'package:flutter/material.dart';
import '../Globals/GlobalParameters.dart';

class NotReadyEventsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
          color: Colors.white60,
          child: ListTile(
            //leading: Text(card.event_name),
            title: GlobalParameters.notReadyParts.length != 0 ? Text(GlobalParameters.notReadyParts[0],
                style: new TextStyle(fontSize: 20.0)) : null,
            trailing: GlobalParameters.notReadyParts.length > 1 ? IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotReadyEvents() ),
                );
              },
              icon: Icon(Icons.navigate_next),
            ) : null,
          )),
    );
  }
  //NotReadyEvents createState() => NotReadyEvents();
}


class NotReadyEvents extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Not ready events"),
        ),
        body: new ListView.builder(
        itemCount: GlobalParameters.notReadyParts.length,
        itemBuilder: (BuildContext context, int index) => buildCard(context, index)),
      );
  }

  Widget buildCard(BuildContext context, int index) {
    //https://stackoverflow.com/questions/58115148/how-to-change-height-of-a-card-in-flutter
    return Container(
        child:
        Card(

          child: ListTile(
            title: Text(GlobalParameters.notReadyParts[index], style: new TextStyle(fontSize: 20.0)),

            trailing: GlobalParameters.bypass_or_not == true ? FlatButton(
              child: Text("ByPass"),

              onPressed: (){
//                setState(() {
                  GlobalParameters.ByPassList.add(GlobalParameters.notReadyParts[index]);
//                });

              },
              color: GlobalParameters.ByPassList.contains(GlobalParameters.notReadyParts[index]) == true ? Colors.lightGreen : Colors.redAccent,
            ) : null,
          )
        ),
    );
  }
}