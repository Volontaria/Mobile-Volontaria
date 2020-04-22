import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/screens/app/config/addServerForm.dart';
import 'package:volontaria/screens/app/profile.dart';
import 'package:volontaria/screens/app/settings.dart';
import 'package:volontaria/screens/customs.layout/config.layouts.dart';
import 'package:volontaria/screens/app/config/validation.dart';
import 'package:volontaria/screens/app/home.dart';
import 'package:volontaria/screens/app/config/login.dart';
import 'package:volontaria/screens/app/config/welcome.dart';
import 'package:volontaria/screens/app/register/cellPicker.dart';
import 'package:volontaria/screens/app/register/eventDetails.dart';
import 'package:volontaria/screens/app/register/eventPicker.dart';
import 'package:volontaria/app/constants.dart';

void main() => runApp(VolontariaApp());

class VolontariaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
          case '/': return MaterialPageRoute(builder: (context) => MainPage());
          case '/config/welcome': return MaterialPageRoute(builder: (context) => WelcomePage());
          case '/config/addServer': return MaterialPageRoute(builder: (context) => AddServerFormPage());
          case '/config/validation': return MaterialPageRoute(builder: (context) => ValidationPage());
          case '/app/login': return MaterialPageRoute(builder: (context) => LoginPage());
          case '/app/home': return MaterialPageRoute(builder: (context) => HomePage());
          case '/app/cell': return MaterialPageRoute(builder: (context) => CellPickerPage(arguments));
          case '/app/events': return MaterialPageRoute(builder: (context) => EventPickerPage(arguments));
          case '/app/eventDetails': return MaterialPageRoute(builder: (context) => EventDetailsPage(arguments));
          case '/app/profile': return MaterialPageRoute(builder: (context) => ProfilePage(arguments));
          case '/app/settings': return MaterialPageRoute(builder: (context) => SettingsPage(arguments));
          default: return MaterialPageRoute(builder: (context) => MainPage());
        }
      },
      navigatorKey: NavigationService.navigationKey,
      themeMode: ThemeMode.system,
      title: "Volontaria",
      theme: ThemeData(
        accentColor: defaultAccentColor,
        accentTextTheme: TextTheme(
          body1: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          body2: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: defaultAccentTextThemeTextStyleColor
          ),
          button: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: defaultAccentTextThemeTextStyleColor
          ),
          caption: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          display1: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 34.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          display2: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 45.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          display3: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 56.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          display4: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 112.0,
              fontWeight: FontWeight.w100,
              color: defaultAccentTextThemeTextStyleColor
          ),
          headline: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          overline: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          subhead: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          subtitle: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: defaultAccentTextThemeTextStyleColor
          ),
          title: TextStyle(
              fontFamily: defaultFontFamily,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: defaultAccentTextThemeTextStyleColor
          )
        ),
        appBarTheme: AppBarTheme(
          color: defaultBackgroundColor,
        ),
        backgroundColor: defaultBackgroundColor,
        bottomAppBarTheme: BottomAppBarTheme(
          color: defaultBackgroundColor,
          elevation: 50.0,
        ),
        brightness: Brightness.light,
        buttonColor: defaultButtonColor,
        cardColor: defaultCardColor,
        cursorColor: defaultCursorColor,
        dialogBackgroundColor: defaultDialogBackgroundColor,
        errorColor: defaultErrorColor,
        fontFamily: defaultFontFamily,
        iconTheme: IconThemeData(
          color: defaultIconThemeColor,
        ),
        hintColor: defaultHintColor,
        primaryColor: defaultPrimaryColor,
        textTheme: TextTheme(
            body1: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            body2: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: defaultTextThemeTextStyleColor
            ),
            button: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: defaultTextThemeTextStyleColor
            ),
            caption: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            display1: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 34.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            display2: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 45.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            display3: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 56.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            display4: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 112.0,
                fontWeight: FontWeight.w100,
                color: defaultTextThemeTextStyleColor
            ),
            headline: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            overline: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            subhead: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            subtitle: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: defaultTextThemeTextStyleColor
            ),
            title: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: defaultTextThemeTextStyleColor
            )
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
  }

  _checkServerStatus() async {
    // Check if the server has been registered by the user
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.getString("apiURL") == null) {
      // If not, push the screen to configure it
      Navigator.pushNamedAndRemoveUntil(context, '/config/welcome', (Route<dynamic> route) => false);
    } else {
      // If yes, check the login status
      _checkLoginStatus();
    }
  }

  _checkLoginStatus() async {
    // Check if the user is already connected with a token
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.getString("token") == null) {
      // If not, push the screen to login
      Navigator.pushNamedAndRemoveUntil(context, '/app/login', (Route<dynamic> route) => false);
    } else {
      // If yes, push the home screen
      Navigator.pushNamedAndRemoveUntil(context, '/app/home', (Route<dynamic> route) => false);
    }
  }

  // Loading screen during process //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ConfigLayouts.boxDecoration(context)
      ),
    );
  }
}