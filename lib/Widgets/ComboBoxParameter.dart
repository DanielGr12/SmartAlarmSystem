import 'package:flutter/material.dart';


class ComboBoxParameter extends StatefulWidget {
  final Function(String) onExitDelayTimeChanged;
  final String parameterName;
  final List<String> locations;//= ["Disable",'5 sec', '15 sec', '30 sec', '45 sec']
  var delay_time;
  //final String default_chime;
  ComboBoxParameter({
    this.onExitDelayTimeChanged,
    this.parameterName,
    this.locations,
    this.delay_time
  });

  @override
  _ComboBoxParameterState createState() => _ComboBoxParameterState();
}

class _ComboBoxParameterState extends State<ComboBoxParameter> {

  String _SelectedLocation;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
//      new Padding(padding: new EdgeInsets.all(15.00)),
      Text(widget.parameterName,//'Entry delay time',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )
      ),

      //new Text("Exit delay time "),
      new Container(
        padding: new EdgeInsets.all(10.0),
      ),
      new  DropdownButton(
        hint: Text('Default:' + widget.delay_time.toString()), // Not necessary for Option 1

        value: _SelectedLocation,
        onChanged: (newValue) {
          setState(() {
            _SelectedLocation = newValue;
          });
//          setState(() {
//            _entrySelectedLocation = newValue;
//          }
          widget.onExitDelayTimeChanged(newValue);
            //_entrySelectedLocation = newValue;
            //print(_entrySelectedLocation);
          //});
        },
        items: widget.locations.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
    ]);
  }
}