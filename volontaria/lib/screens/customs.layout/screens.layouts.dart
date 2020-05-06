import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volontaria/models/auth.dart';

class ScreenLayouts {

  static Widget bottomNavigationBar(BuildContext context, Auth auth, num index, bool isLoading){

    IconButton _navigationButton(IconData iconData, num indexValue, String route, dynamic args){
      return IconButton(
        icon: Icon(iconData, color: index.floor() == indexValue ? Theme.of(context).accentColor : Theme.of(context).iconTheme.color),
        onPressed: () {
          if (!isLoading && index != indexValue){
            Navigator.pushNamedAndRemoveUntil(context, route, (Route<dynamic> route) => false, arguments: args);
          }
        },
      );
    }

    IconButton _home(){
      return _navigationButton(Icons.home, 1, '/app/home', null);
    }

    IconButton _register(){
      return _navigationButton(Icons.event, 2, '/app/cell', auth);
    }

    IconButton _profile(){
      return _navigationButton(Icons.account_box, 3, '/app/profile', auth);
    }

    IconButton _settings(){
      return _navigationButton(Icons.settings, 4, '/app/settings', auth);
    }

    return Container(
      height: 60.0,
      child: BottomAppBar(
        elevation: Theme.of(context).bottomAppBarTheme.elevation,
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _home(),
            _register(),
            _profile(),
            _settings(),
          ],
        ),
      ),
    );
  }

  static Widget appBar(BuildContext context, Auth auth){

    IconButton _logOut(){
      return IconButton(
        icon: Icon(Icons.exit_to_app, color: Theme.of(context).iconTheme.color),
        onPressed: () {
          if (auth != null){
            auth.token.clearValue();
          }
          Navigator.pushNamedAndRemoveUntil(context, '/app/login', (Route<dynamic> route) => false);
        },
      );
    }

    return AppBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).appBarTheme.color,
      title: Text("Volontaria", style: Theme.of(context).textTheme.title),
      actions: <Widget>[
        _logOut(),
      ],
    );
  }

  static BoxDecoration cardBoxDecoration(BuildContext context) {
    return BoxDecoration(
        border: Border(
            right: BorderSide(
                width: 1.0, color: Colors.white24)
        )
    );
  }

  static Widget topPageTitle(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(title,
      style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  static Widget centerText(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.subhead.copyWith(fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget settingsFJNR(BuildContext context){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: 'Volontaria est un projet en logiciel libre maintenu bénévolement par ', style: Theme.of(context).textTheme.subhead),
                TextSpan(text: 'FJNR', style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()
                    ..onTap = () { launch('http:fjnr.ca');
                    },
                ),
              ],
            ),
        )
    );
  }
}