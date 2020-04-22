import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/screens/customs.layout/screens.layouts.dart';
import 'package:volontaria/screens/customs.widget/customDialog.dart';
import 'package:volontaria/app/constants.dart';

class SettingsPage extends StatefulWidget {

  Auth _contextAuth;

  SettingsPage(Auth auth){
    this._contextAuth = auth;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState(_contextAuth);
}

class _SettingsPageState extends State<SettingsPage> {

  num _index = 4;

  // Data for screen
  Auth _currentAuth;

  _SettingsPageState(Auth auth){
    this._currentAuth = auth;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
    });
  }

  @override
  Widget build(BuildContext context) {

    // Methods for screen builder //
    // Function for the change instance button
    void _changeInstanceButtonAction(){
      CustomDialog.validationDialog(context, changeInstanceDialogTitle, changeInstanceDialogDescription).then((confirmed) async{
        if (confirmed){
          // If confirmed, delete token and API URL which are stored in the local storage
          SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) => sharedPreferences.setString("apiURL", null));
          SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) => sharedPreferences.setString("token", null));
          // Then go configuration page
          Navigator.pushNamedAndRemoveUntil(context, '/config/welcome', (Route<dynamic> route) => false, arguments: null);
        }
      });
    }

    // Text for the change instance button
    Widget _changeInstanceButtonText(){
      return Text("Changer d'organisation", style: Theme.of(context).textTheme.button);
    }

    // Change instance button
    Widget _changeInstanceButton(){
      return RaisedButton(
          elevation: 0.0,
          color: Theme.of(context).accentColor,
          child: _changeInstanceButtonText(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () {
            _changeInstanceButtonAction();
          }
      );
    }

    // Container for the change instance button
    Widget _changeInstanceButtonContainer(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: _changeInstanceButton(),
      );
    }

    // Details of settings
    Widget _settingsDetails() {
      return Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              _changeInstanceButtonContainer(),
            ],
          )
      );
    }

    // Body container
    Widget _body(){
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ScreenLayouts.topPageTitle(context, "Paramètres"),
            _settingsDetails(),
            ScreenLayouts.settingsFJNR(context),
          ],
        ),
      );
    }

    // Screen builder //
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: ScreenLayouts.appBar(context, _currentAuth),
      body: _body(),
      bottomNavigationBar: ScreenLayouts.bottomNavigationBar(context, _currentAuth, _index, false),
    );
  }
}


