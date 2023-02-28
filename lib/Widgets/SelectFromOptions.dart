import 'package:flutter/material.dart';
import 'SettingSection.dart';
import '../Globals/GlobalParameters.dart';
class SelectFromOptions extends StatefulWidget {

  final List<SelectOptions> options;
  final Function(String) returned_val;
  final String default_val;
  final String explanation;
  //SelectFromOptions(this.options);
  SelectFromOptions({
    this.returned_val,
    this.options,
    this.default_val,
    this.explanation,
  });
  @override
  _SelectFromOptionsState createState() => _SelectFromOptionsState();
}
class _SelectFromOptionsState extends State<SelectFromOptions> {
  bool first_time = true;
  @override
  Widget build(BuildContext context) {
    
    return Container(
        color: Colors.grey[100],
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.options.length,
            itemBuilder: (BuildContext context, int index) =>
                buildCard(context, index)),
      );

  }
  Widget buildCard(BuildContext context, int index)
  {
    
    return Column(
      children: <Widget>[
            Container(
              color: Colors.white,
              child: Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text(widget.options[index].text),
                  trailing: trailing_val(index),
                  onTap: (){
                    setState(() {
                      widget.options.forEach((option) {
                        if (option.text != widget.options[index].text)
                          {
                            option.is_selected = false;
                          }
                        else
                          {
                            option.is_selected = true;
                            widget.returned_val(option.text);
                          }
                      } );
      //          _show_more_lightsState.random_time = "30 minutes";
      //          GlobalParameters.light_selected_30_min = true;
      //          GlobalParameters.light_selected_1_hour = false;
      //          GlobalParameters.light_selected_2_hours = false;
                    });

                  },
                ),
              ),
            ),

//        ListTile(
//          title: Text(widget.options[index].text),
//          trailing: trailing_val(index),
//          onTap: (){
//            setState(() {
//              widget.options.forEach((option) {
//                if (option.text != widget.options[index].text)
//                  {
//                    option.is_selected = false;
//                  }
//                else
//                  {
//                    option.is_selected = true;
//                    widget.returned_val(option.text);
//                  }
//              } );
////          _show_more_lightsState.random_time = "30 minutes";
////          GlobalParameters.light_selected_30_min = true;
////          GlobalParameters.light_selected_1_hour = false;
////          GlobalParameters.light_selected_2_hours = false;
//            });
//
//          },
//        ),
        Ink(
          color: Colors.white,
            child: Divider(
              color: Colors.grey,
              height: 3,
              endIndent: 20,
              indent: 20,
            )
        ),
        index == widget.options.length-1 ? Container(
            child: Text(widget.explanation),
          padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
        ): SizedBox.shrink(),
      ],
    );
  }
  Widget trailing_val(int index)
  {
    if (first_time == true)
      {
        widget.options.forEach((option) {
          if (widget.default_val == option.text)
          {
            option.is_selected = true;
            first_time = false;
          }
        });
      }

    if (widget.options[index].is_selected == true)
    {
      return Icon(Icons.check,color: Colors.blue[700]);
    }
    return SizedBox.shrink();
  }
}