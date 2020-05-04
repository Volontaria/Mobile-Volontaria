import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volontaria/data/event.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/models/registration.dart';
import 'package:volontaria/screens/customs.layout/screens.layouts.dart';
import 'package:volontaria/screens/customs.widget/customDialog.dart';
import 'package:volontaria/services/participationService.dart';
import 'package:volontaria/utils/constants.dart';

class EventDetailsPage extends StatefulWidget {

  Registration _registration;

  EventDetailsPage(Registration registration){
    this._registration = registration;
  }

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState(_registration);
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  num _index = 2.2;

  // Data for screen
  Registration _currentRegistration;
  Auth _currentAuth;
  Event _contextEvent;

  _EventDetailsPageState(Registration registration){
    this._currentRegistration = registration;
    this._currentAuth = _currentRegistration.auth;
    this._contextEvent = _currentRegistration.event;
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

    // Function for the registrer button
    void _registerButtonAction(){
      CustomDialog.validationDialog(context, registrationDialogTitle, registrationDialogDescription).then((confirmed) async{
        if (confirmed){
          ParticipationService().createParticipation(_currentAuth, _contextEvent, _contextEvent.isVolunteersFull()).then((onValue) {
            Fluttertoast.showToast(
                msg: "Inscription réussie. Merci !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
            );
            Navigator.pushNamedAndRemoveUntil(context, '/app/home', (Route<dynamic> route) => false, arguments: null);
          });
        }
      });
    }

    // Text for the registrer button
    Widget _registerButtonText(){
      return Text(_contextEvent.isVolunteersFull() ? "M'inscrire en tant que remplaçant" : "M'inscrire en tant que bénévole", style: Theme.of(context).textTheme.button);
    }

    // Registrer button
    Widget _registerButton(){
      return RaisedButton(
          elevation: 0.0,
          color: Theme.of(context).accentColor,
          child: _registerButtonText(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () {
            _registerButtonAction();
          }
      );
    }

    // Container for the registrer button
    Widget _registerButtonContainer(){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: _registerButton(),
      );
    }

    // Details of event
    Widget _eventsDetails() {
      return Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              _listTile(Icons.date_range, "Début : " + _contextEvent.getStartTimeDisplay() + "\nFin : " + _contextEvent.getEndTimeDisplay()),
              _listTile(Icons.spa, "Activité : " + _contextEvent.taskType.name),
              _listTile(Icons.place, "Lieu : " + _contextEvent.cell.address.getAddressDisplay()),
              _registerButtonContainer(),
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
            ScreenLayouts.topPageTitle(context, "Détails de l'événement"),
            _eventsDetails(),
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


