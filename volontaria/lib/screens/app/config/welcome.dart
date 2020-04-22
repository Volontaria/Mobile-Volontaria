import 'package:flutter/material.dart';
import 'package:volontaria/screens/customs.layout/config.layouts.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    // Methods for screen builder
    // Headline text
    Widget _headlineText(){
      return Text("Bienvenue !",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline
      );
    }

    // Title text
    Widget _titleText(){
      return Text("Commençons par configurer l'application pas à pas.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title
      );
    }

    // Ok button
    Widget _okButton(){
      return RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/config/addServer');
        },
        color: Theme.of(context).buttonColor,
        child: Text("OK !", style: Theme.of(context).textTheme.button),
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

    // Body section
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
}