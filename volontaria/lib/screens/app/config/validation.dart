import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/screens/customs.layout/config.layouts.dart';

class ValidationPage extends StatefulWidget {
  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    // Methods for screen builder
    // Headline text
    Widget _headlineText(){
      return Text("Félicitations !",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1
      );
    }

    // Title text
    Widget _titleText(){
      return Text("Votre application est désormais configurée et prête à l'emploi",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title
      );
    }

    // Ok button
    Widget _okButton(){
      return RaisedButton(
        onPressed: () {
          _checkLoginStatus();
        },
        color: Theme.of(context).buttonColor,
        child: Text("OK !", style: Theme.of(context).textTheme.body1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      );
    }

    // Button container
    Widget _okButtonContainer(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: _okButton(),
      );
    }

    // Text container
    Widget _textContainer(){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            _headlineText(),
            SizedBox(height: 30.0),
            _titleText(),
          ],
        ),
      );
    }

    Widget _bodySection() {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            _textContainer(),
            _okButtonContainer(),
          ],
        ),
      );
    }

    // Screen builder //
    return Scaffold(
      body: Container(
        decoration: ConfigLayouts.boxDecoration(context),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            ConfigLayouts.headerSection(context),
            _bodySection(),
          ],
        ),
      ),
    );
  }

  // Local methods //
  _checkLoginStatus() async {
    // Check if the user is already connected with a token
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.getString("token") == null) {
      // If not, push the screen to login
      Navigator.pushNamedAndRemoveUntil(context, '/app/login', (Route<dynamic> route) => false);
    } else {
      // If yes, push the home screen
      Navigator.pushNamedAndRemoveUntil(context, '/app/home', (Route<dynamic> route) => false);
    }
  }
}