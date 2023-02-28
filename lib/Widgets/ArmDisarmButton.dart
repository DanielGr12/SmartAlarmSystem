import 'package:flutter/material.dart';

class ArmDisarmButton extends StatelessWidget {
  final String ButtonText;
  final Color ButtonColor;
  final Color ButtonSplashColor;
  final IconData ButtonIcon;

  final VoidCallback onButtonSelected;



  ArmDisarmButton({
    @required this.ButtonText,
    @required this.ButtonColor,
    @required this.ButtonSplashColor,
    @required this.ButtonIcon,
    this.onButtonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 80.0,
      width: 100.0,
      //child: new Center(
      child: InkWell(
        splashColor: ButtonSplashColor, // splash color
        onTap: () {
          onButtonSelected();
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Icon(ButtonIcon,
                color: ButtonColor,
                size: 42.0,
              ), // icon
              new Text(ButtonText,
                  style: new TextStyle(
                      color: ButtonColor,
                      //_item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 16.0)
              ),
            ]
        ),
      ),
      //),
      decoration: new BoxDecoration(
        color: Colors.grey[200],
        //color: Colors.white54,
        //? Colors.blueAccent
        //: Colors.transparent,
        border: new Border.all(
          width: 2.0,
          color: Colors.grey[300],
          //? Colors.blueAccent
          //: Colors.grey),
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      ),
    );//,
  }
}


/* !!! another example for buttons that we try
  Widget arm_away_button()
  {
    return SizedBox.fromSize(
      size: Size(86, 86), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.red, // button color
          child: InkWell(
            splashColor: Colors.red[200], // splash color
            onTap: () {
              ReceiverProcessData("start,keyfob,0,arm,end");
              secondsPassed = 15;
              //isActive = !isActive;
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.lock,
                  color: Colors.white,
                ), // icon
                Text("Arm",
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  //color: Colors.white,
                ), // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget disarm_button()
  {
    return SizedBox.fromSize(
      size: Size(86, 86), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.green, // button color
          child: InkWell(
            splashColor: Colors.green[200], // splash color
            onTap: () {
              ReceiverProcessData("start,keyfob,0,disarm,end");
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.lock_open,
                  color: Colors.white,
                ), // icon
                Text("Disarm",
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  //color: Colors.white,
                ), // text
              ],
            ),
          ),
        ),
      ),
    );
  }

 */