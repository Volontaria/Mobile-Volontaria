import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'package:volontaria/screens/customs.layout/config.layouts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServerFormPage extends StatefulWidget {
  @override
  _AddServerFormPageState createState() => _AddServerFormPageState();
}

class _AddServerFormPageState extends State<AddServerFormPage> {

  bool _isLoading = false;

  final TextEditingController _serverURLController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    // Methods for screen builder
    // Manual input for API url
    Widget _APIUrlInput(){
      return TextFormField(
        controller: _serverURLController,
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          icon: Icon(Icons.cloud_queue, color: Theme.of(context).iconTheme.color),
          hintText: "URL du serveur",
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
      );
    }

    // Button for manual input of API url
    Widget _APIUrlInputButton(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: RaisedButton(
          onPressed: _serverURLController.text == "" ? null : () {
            _saveServerName(_serverURLController.text);
          },
          color: Theme.of(context).buttonColor,
          child: Text("Ajouter le serveur", style: Theme.of(context).textTheme.body1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      );
    }

    // Function for QR code scanning
    void _APIUrlQRCodeAction() async {
      String code = await MajaScan.startScan(
        title: "Scan du QR code",
        titleColor: Colors.white,
        qRCornerColor: Colors.white,
        qRScannerColor: Colors.white,
        flashlightEnable: true,
      );
      _saveServerName(jsonDecode(code)["instanceAPIUrl"]);
    }

    // Description text for QR code input of API url
    Widget _APIUrlQRCodeText(){
      return Text("Ou scannez le QR code de votre organisation !", style: Theme.of(context).textTheme.body1);
    }

    // QR code input for API url
    Widget _APIUrlQRCodeButton(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: RaisedButton(
          onPressed: () async {
            await _APIUrlQRCodeAction();
          },
          color: Theme.of(context).buttonColor,
          child: Text("Démarrer le scan", style: Theme.of(context).textTheme.body1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
            _APIUrlInput(),
            _APIUrlInputButton(),
            SizedBox(height: 50.0),
            _APIUrlQRCodeText(),
            _APIUrlQRCodeButton(),
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
  _saveServerName(String serverName) async {
    // Save the the server URL in local storage
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("apiURL", serverName);
    Navigator.pushNamedAndRemoveUntil(context, '/config/validation', (Route<dynamic> route) => false);
  }
}

