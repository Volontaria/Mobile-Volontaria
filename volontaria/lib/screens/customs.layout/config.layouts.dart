import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigLayouts {
  static Container headerSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Volontaria",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1),
    );
  }

  static BoxDecoration boxDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
          colors: [Theme.of(context).backgroundColor, Theme.of(context).accentColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
      ),
    );
  }
}