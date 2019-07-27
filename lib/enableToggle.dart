import 'package:flutter/material.dart';
import 'package:ursa_ds_mobile/domain/communications.dart';

class EnableToggle extends StatefulWidget {
  const EnableToggle({Key key}) : super(key: key);

  @override
  EnableToggleState createState() => EnableToggleState();
}

class EnableToggleState extends State<EnableToggle> {
  Color disabledColor = Colors.red[300];
  Color enabledColor = Colors.green[300];
  Color greyColor = Colors.grey[300];

  String disabledMessage = "DISABLE";
  String enabledMessage = "ENABLE";

  TextStyle buttonStyle =
      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3);

  bool enabled = false;

  void _enable() {
    message.enabled = true;

    setState(() {
      enabled = true;
    });
  }

  void _disable() {
    message.enabled = false;

    setState(() {
      enabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: ButtonTheme(
                minWidth: 120,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: _enable,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)
                        )
                      ),
                      child: Text(
                        enabledMessage + (enabled ? "D" : ""),
                        style: buttonStyle,
                      ),
                      color: enabled ? enabledColor : greyColor,
                    ),
                    RaisedButton(
                      onPressed: _disable,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)
                        )
                      ),
                      child: Text(
                        disabledMessage + (enabled ? "" : "D"),
                        style: buttonStyle,
                      ),
                      color: enabled ? greyColor : disabledColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
