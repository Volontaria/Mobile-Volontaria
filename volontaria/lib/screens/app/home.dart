import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:volontaria/data/event.dart';
import 'package:volontaria/data/participation.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/models/schedule.dart';
import 'package:volontaria/models/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/screens/customs.widget/filtersContainer.dart';
import 'package:volontaria/screens/customs.widget/customDialog.dart';
import 'package:volontaria/screens/customs.layout/screens.layouts.dart';
import 'package:volontaria/services/eventService.dart';
import 'package:volontaria/services/participationService.dart';
import 'package:volontaria/services/userService.dart';
import 'package:volontaria/app/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  num _index = 1;
  bool _isLoading = true;

  // Set volunter filer as default
  bool _volunteerLoaded = true;

  // Data for screen
  SharedPreferences _sharedPreferences;
  Auth _currentAuth;
  List<Schedule> _scheduleListDisplay;
  List<Schedule> _scheduleListAsOnHold;
  List<Schedule> _scheduleListAsVolunteer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _load();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Set the screen to load
        setState(() {
          _isLoading = true;
        });
        // Refresh the content
        WidgetsBinding.instance.addPostFrameCallback((_){
          _load();
        });
        break;
      case AppLifecycleState.inactive:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
      // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    // Methods for screen builder //
    // Maps launcher card
    Widget _cardMaps(Schedule schedule){
      return Card(
        child: ListTile(
          leading: Icon(Icons.place, color: Colors.green),
          title: Text(schedule.event.cell.address.getAddressDisplay(), style: Theme.of(context).textTheme.body1.copyWith(height: 1.5)),
          onTap: (){
            // Launch Maps application
            MapsLauncher.launchQuery(schedule.event.cell.address.getAddressDisplay());
            // Then pop the modal with no modification
            Navigator.pop(context, false);
          },
        ),
      );
    }

    // Cancellation card
    Widget _cardCancellation(Schedule schedule){
      return Card(
        child: ListTile(
          leading: Icon(Icons.cancel, color: Colors.red),
          title: Text('Annuler ma participation'),
          onTap: (){
            // Pop a dialog to confirm the cancellation
            CustomDialog.validationDialog(context, cancellationDialogTitle, cancellationDialogDescription).then((bool confirmed) async {
              // If user validate, that he wants to cancel, then delete the participation
              if (confirmed) {
                ParticipationService().deleteParticipation(_currentAuth, schedule.participation).then((onValue) {
                  // Then pop the with modification
                  Navigator.pop(context, confirmed);
                });
              } else {
                // Pop the modal with no modification
                Navigator.pop(context, false);
              }
            });
          },
        ),
      );
    }
    
    // Modal for contextual actions for a participation to an event
    Future<bool> _contextualModal(Auth auth, Schedule schedule) async {
      return showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context){
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _cardMaps(schedule),
                  _cardCancellation(schedule),
                ],
              ),
            );
          }
      );
    }
    
    // Leading card content
    Widget _leadingCard(Schedule schedule){
      return Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: ScreenLayouts.cardBoxDecoration(context),
        child: Icon(schedule.participation.standBy ? defaultIconStandby : defaultIconVolunteer, color: Theme.of(context).iconTheme.color),
      );
    }

    // Text card content
    Widget _titleCard(Schedule schedule){
      return Text(
        schedule.event.cell.name + " - " + schedule.event.taskType.name,
        style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
      );
    }

    // Text card content
    Widget _subtitleCard(Schedule schedule){
      return Text(
        "Début : " + schedule.event.getStartTimeDisplay() + "\nDurée : " + schedule.event.getDurationDisplay(),
        style: Theme.of(context).textTheme.body1,
      );
    }
    
    // Card content
    Widget _cardContent(Schedule schedule){
      return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: _leadingCard(schedule),
          title: _titleCard(schedule),
          subtitle: _subtitleCard(schedule),
          trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).iconTheme.color, size: 30.0),
          onTap: () {
            // Show the contextual modal
            _contextualModal(_currentAuth, schedule).then((modified) {
              // If content has been modified, refresh the screen
              if (modified != null && modified) {
                setState(() {
                  _isLoading = true;
                });
                _load();
              }
            });
          }
      );
    }

    // Card holder
    Widget _scheduleCard(Schedule schedule) {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _cardContent(schedule),
        ),
      );
    }

    // List of cards
    Widget _listView(){
      return Expanded(
          child: _scheduleListDisplay.length == 0 ? ScreenLayouts.centerText(context, "Aucune future participation à afficher") : Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _scheduleListDisplay != null ? _scheduleListDisplay.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return _scheduleCard(_scheduleListDisplay[index]);
              },
            ),
          )
      );
    }

    // Text description of the filter
    Widget _filterText(String text){
      return Text(text, style: Theme.of(context).textTheme.body1);
    }

    // Button of the filter
    Widget _filterButton(IconData iconData, bool isSelected, bool boolToSet, List<Schedule> listToSet){
      return IconButton(
          icon: Icon(iconData, color: isSelected ? Theme.of(context).accentColor : Theme.of(context).iconTheme.color),
          color: Colors.transparent,
          onPressed: () {
            setState(() {
              // Load volunteer list
              _volunteerLoaded = boolToSet;
              _scheduleListDisplay = listToSet;
            });
          }
      );
    }
    
    // Volunteer filter
    Widget _filterColumnVolunteer(){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _filterButton(defaultIconVolunteer, _volunteerLoaded, true, _scheduleListAsVolunteer),
          _filterText("Volontaire"),
        ],
      );
    }

    // Standby filter
    Widget _filterColumnStandBy(){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _filterButton(defaultIconStandby, !_volunteerLoaded, false, _scheduleListAsOnHold),
          _filterText("Remplaçant"),
        ],
      );
    }

    // Filters container
    Widget _filters() {
      return FiltersContainer([_filterColumnVolunteer(), _filterColumnStandBy()]);
    }

    // Body container
    Widget _body(){
      return Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ScreenLayouts.topPageTitle(context, "Mes participations"),
            _listView(),
            _filters(),
          ],
        ),
      );
    }

    // Screen builder //
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: ScreenLayouts.appBar(context, _currentAuth),
      body: _body(),
      bottomNavigationBar: ScreenLayouts.bottomNavigationBar(context, _currentAuth, _index, _isLoading),
    );
  }

  // Local methods //
  _load() async {
    // Get profile
    _sharedPreferences = await SharedPreferences.getInstance();
    _currentAuth = await UserService().getProfile(Token(_sharedPreferences.getString("token")));

    // Get participations and events linked
    List<Participation> participationsList = await ParticipationService().getParticipations(_currentAuth);
    List<Event> eventsList = await EventService().getEventsVolunteers(_currentAuth);

    // Create complete schedule
    _scheduleListAsOnHold = List();
    _scheduleListAsVolunteer = List();
    for (Event event in eventsList){
      // Check if event is in the future
      if (event.isInFuture()){
        for (Participation participation in participationsList){
          if (event.id == participation.event){
            // Check participation status
            if (participation.standBy){
              _scheduleListAsOnHold.add(Schedule(participation, event));
            } else {
              _scheduleListAsVolunteer.add(Schedule(participation, event));
            }
          }
        }
      }
    }

    // Refresh the screen
    setState(() {
      _scheduleListDisplay = _scheduleListAsVolunteer;
      _isLoading = false;
      _volunteerLoaded = true;
    });
  }
}