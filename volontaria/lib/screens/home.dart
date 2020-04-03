import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:volontaria/data/user.dart';
import 'package:volontaria/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/screens/welcome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading = true;
  SharedPreferences sharedPreferences;
  User currentUser;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL  = sharedPreferences.getString("apiURL");
    String profileURL = baseURL + "/profile";

    String token = sharedPreferences.getString("token");

    print("Token : " + token);

    Map <String, String> headars = {
      'Authorization': 'Token ' + token,
    };
    var jsonResponse = null;
    var response = await http.get(profileURL, headers: headars);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        setState(() {
          currentUser = new User.fromJson(jsonResponse);
          _isLoading = false;
        });
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volontaria", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.setString("token",null);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(currentUser.firstName + " " + currentUser.lastName),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(currentUser.email),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(currentUser.phone),
          ),
          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text(currentUser.mobile),
          ),
        ],
      ),
      drawer: Drawer(),
    );
  }
}