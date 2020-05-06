import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volontaria/screens/customs.layout/config.layouts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/screens/customs.widget/customDialog.dart';
import 'package:volontaria/services/userService.dart';
import 'package:volontaria/utils/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = true;

  bool _isSwitched;

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _load();
    });
  }

  @override
  Widget build(BuildContext context) {

    // Methods for screen builder
    // Username input
    Widget _inputUsername(){
      return TextFormField(
        controller: _usernameController,
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
          hintText: "Nom d'utilisateur ou Mail",
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          hintStyle: Theme.of(context).textTheme.body1.copyWith(color: Colors.white70),
        ),
      );
    }

    // Password input
    Widget _inputPassword(){
      return TextFormField(
        controller: _passwordController,
        cursorColor: Theme.of(context).cursorColor,
        obscureText: true,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
          hintText: "Mot de passe",
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
          hintStyle: Theme.of(context).textTheme.body1.copyWith(color: Colors.white70),
        ),
      );
    }

    // "Remember me" switch
    Widget _rememberMeSwitch(){
      return Switch(
        value: _isSwitched,
        onChanged: (value) {
          setState(() {
            _isSwitched = value;
          });
        },
        activeTrackColor: Theme.of(context).backgroundColor,
        activeColor: Theme.of(context).accentColor,
      );
    }

    Widget _rememberMeText(){
      return Text("Se souvenir de moi", style: Theme.of(context).textTheme.body1);
    }

    // "Remember me" row
    Widget _rememberMeRow(){
      return Row(
        children: <Widget>[
          _rememberMeSwitch(),
          _rememberMeText(),
        ],
      );
    }

    // Login button
    Widget _logInButton(){
      return RaisedButton(
        onPressed: _usernameController.text == "" || _passwordController.text == "" ? null : () async {
          setState(() {
            _isLoading = true;
          });
          // Try to sign in the user with provided credentials
          await _signIn(_usernameController.text, _passwordController.text);
        },
        color: Theme.of(context).buttonColor,
        child: Text("Se connecter", style: Theme.of(context).textTheme.body1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      );
    }

    // Button container
    Widget _logInButtonContainer(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: _logInButton(),
      );
    }

    // Fields container
    Widget _fieldsContainer(){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            _inputUsername(),
            SizedBox(height: 30.0),
            _inputPassword(),
          ],
        ),
      );
    }

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
          color: Theme.of(context).buttonColor,
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

    // Body section
    Widget _bodySection() {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            _fieldsContainer(),
            _rememberMeRow(),
            _logInButtonContainer(),
            _changeInstanceButtonContainer(),
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
  _load() async {
    _isSwitched = false;
    // Check if there is any username stored in local storage
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isSwitched = sharedPreferences.getBool("rememberMe");
    if (_isSwitched != null && _isSwitched){
      String username = sharedPreferences.getString("username");
      if (username!= null && username.isNotEmpty){
        // Prefill the username
        _usernameController.text = username;
      }
    } else {
      _isSwitched = false;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signIn(String username, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserService().login(username, password).then((value) {

      // Authentication is ok
      // Save the token in local storage
      sharedPreferences.setString("token", value);

      // Save additional features
      sharedPreferences.setBool("rememberMe", _isSwitched);
      sharedPreferences.setString("username", username);

      // Then go to home page
      Navigator.pushNamedAndRemoveUntil(context, '/app/home', (Route<dynamic> route) => false);
    }).catchError((onError) {

      // Authentication is not ok
      // Show error
      Fluttertoast.showToast(
          msg: "Impossible de se connecter avec les identifiants renseignés.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).errorColor,
          textColor: Theme.of(context).textTheme.body1.color,
          fontSize: Theme.of(context).textTheme.body1.fontSize);

      setState(() {
        _isLoading = false;
      });
    });
  }
}