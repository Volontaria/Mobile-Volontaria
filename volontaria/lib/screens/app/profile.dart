import 'package:flutter/material.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/screens/customs.layout/screens.layouts.dart';

class ProfilePage extends StatefulWidget {

  Auth _auth;

  ProfilePage(Auth auth){
    this._auth = auth;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState(_auth);
}

class _ProfilePageState extends State<ProfilePage> {

  num _index = 3;

  // Data for screen
  Auth _currentAuth;

  _ProfilePageState(Auth auth){
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
    // Constructor for each detail
    Widget _listTile(IconData iconData, String text){
      return ListTile(
        leading: Icon(iconData, color: Theme.of(context).iconTheme.color),
        title: Text(text, style: Theme.of(context).textTheme.body1),
      );
    }

    // Details of profile
    Widget _profileDetails() {
      return Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              _listTile(Icons.person, _currentAuth.user.firstName + " " + _currentAuth.user.lastName),
              _listTile(Icons.mail, _currentAuth.user.email),
              _listTile(Icons.phone, _currentAuth.user.phone == null ? "-" : _currentAuth.user.phone.isNotEmpty ? _currentAuth.user.phone : '-'),
              _listTile(Icons.phone_android, _currentAuth.user.mobile == null ? "-" : _currentAuth.user.mobile.isNotEmpty ? _currentAuth.user.mobile : '-'),
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
          children: <Widget>[
            ScreenLayouts.topPageTitle(context, "Mon profil"),
            _currentAuth != null ? _profileDetails() : Center(child: Text('Pas de données à afficher')),
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


