import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:volontaria/data/cell.dart';
import 'package:volontaria/data/event.dart';
import 'package:volontaria/data/participation.dart';
import 'package:volontaria/data/taskType.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/models/registration.dart';
import 'package:volontaria/screens/customs.layout/screens.layouts.dart';
import 'package:volontaria/screens/customs.widget/customFilterList/filterList.dart';
import 'package:volontaria/screens/customs.widget/filtersContainer.dart';
import 'package:volontaria/services/eventService.dart';
import 'package:volontaria/services/participationService.dart';
import 'package:volontaria/services/taskTypeService.dart';
import 'package:volontaria/app/constants.dart';
import 'package:volontaria/utils/utils.dart';

class EventPickerPage extends StatefulWidget {

  Registration _registration;

  EventPickerPage(Registration registration){
    this._registration = registration;
  }

  @override
  _EventPickerPageState createState() => _EventPickerPageState(_registration);
}

class _EventPickerPageState extends State<EventPickerPage> with WidgetsBindingObserver {

  num _index = 2.1;
  bool _isLoading = true;
  bool _isListLoading = true;

  // Data for screen
  Registration _currentRegistration;
  Auth _currentAuth;
  Cell _currentCell;
  List<Event> _eventsListDisplay;
  List<Event> _eventsList;

  // Filters
  DateTime _startDate;
  DateTime _endDate;
  List<String> _stringTaskTypesList;
  List<String> _selectedTaskTypesList = List();

  _EventPickerPageState(Registration registration){
    this._currentRegistration = registration;
    this._currentAuth = _currentRegistration.auth;
    this._currentCell = _currentRegistration.cell;

    // Init date filters
    _startDate = DateTime.now();
    _endDate = DateTime(_startDate.year, _startDate.month + 1, 0); // Get last day of the current month
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _loadTaskTypes();
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
    // Leading card content
    Widget _leadingCard(Event event){
      return Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: ScreenLayouts.cardBoxDecoration(context),
        child: event.getVolunteersInfos(),
      );
    }

    // Text card content
    Widget _titleCard(Event event){
      return Text(
        event.cell.name + " - " + event.taskType.name,
        style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
      );
    }

    // Text card content
    Widget _subtitleCard(Event event){
      return Text(
        "Début : " + event.getStartTimeDisplay() + "\nDurée : " + event.getDurationDisplay(),
        style: Theme.of(context).textTheme.body1,
      );
    }

    Widget _cardContent(Event event) {
      return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: _leadingCard(event),
          title: _titleCard(event),
          subtitle: _subtitleCard(event),
          trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).iconTheme.color, size: 30.0),
          onTap: () {
            // Check if event do not already start or it's in the past
            if (!event.isInFuture()){
              // If yes, inform the user
              Fluttertoast.showToast(
                msg: "Cet évènement a déjà commencé ou est déjà passé.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
              );
            } else {
              // Check if user is already registered to this event
              if (event.isAlreadyRegistred()){
                // If yes, inform the user
                Fluttertoast.showToast(
                  msg: "Vous êtes déjà inscrit à cette évènement.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              } else {
                // Check if event is full
                if (event.isVolunteersFull() && event.isStandbyFull()){
                  // If yes, inform the user
                  Fluttertoast.showToast(
                    msg: "Cette évènement est déjà complet.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                } else {
                  // If not, show to event details screen
                  _currentRegistration.event = event;
                  Navigator.pushNamed(context, '/app/eventDetails', arguments: _currentRegistration);
                }
              }
            }
          }
      );
    }

    // Card holder
    Widget _eventCard(Event event) {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          // If already registered to this event, show it green
          decoration: BoxDecoration(color: event.isAlreadyRegistred() ? defaultAlreadyRegisteredCardColor : Theme.of(context).cardColor),
          child: _cardContent(event),
        ),
      );
    }

    // List of cards
    Widget _listView(){
      return Expanded(
          child: _isListLoading ? Center(child: CircularProgressIndicator()) :
          _eventsListDisplay.length == 0 ? ScreenLayouts.centerText(context, "Aucun événement à afficher") : Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _eventsListDisplay != null ? _eventsListDisplay.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return _eventCard(_eventsListDisplay[index]);
              },
            ),
          )
      );
    }

    // Selected month display
    Widget _filterMonth(){
      return Text(DateFormat('yMMMM').format(_startDate), style: Theme.of(context).textTheme.body1);
    }

    // Button of the filter
    Widget _filterButton(IconData iconData, DateTime startDateToSet){
      return IconButton(
          icon: Icon(iconData, color: Theme.of(context).iconTheme.color),
          color: Colors.transparent,
          onPressed: () {
            setState(() {
              // Load selected month
              _isListLoading = true;
              _startDate = startDateToSet;
              _endDate = DateTime(_startDate.year, _startDate.month + 1, 0);
              _load();
            });
          }
      );
    }

    // Previous month button
    Widget _filterPrevious(){
      return _filterButton(Icons.arrow_left, DateTime(_startDate.year, _startDate.month - 1, 1));
    }

    // Next month button
    Widget _filterNext(){
      return _filterButton(Icons.arrow_right, DateTime(_startDate.year, _startDate.month + 1, 1));
    }

    // Filters container
    Widget _filters() {
      return FiltersContainer([_filterPrevious(), _filterMonth(), _filterNext()]);
    }

    // Body container
    Widget _body(){
      return Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ScreenLayouts.topPageTitle(context, "Événements"),
            _listView(),
            _filters(),
          ],
        ),
      );
    }

    // Modal for filter list
    Future<void> _openFilterList() async {
      var list = await FilterList.showFilterList(
        context,
        allResetButonColor: Theme.of(context).buttonColor,
        allTextList: _stringTaskTypesList,
        applyButonTextBackgroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        borderRadius: 30,
        headerTextColor: Colors.black,
        headlineText: "Activités",
        height: double.infinity,
        searchFieldBackgroundColor: Theme.of(context).backgroundColor,
        searchFieldHintText: "Rechercher ici",
        selectedTextList: _selectedTaskTypesList,
        selectedTextBackgroundColor: Theme.of(context).accentColor,
      );
      // If filters has been selected, update intern list
      if (list != null) {
        setState(() {
          _selectedTaskTypesList = List.from(list);
        });
      }
    }

    // Badge for floating action button with number of filers selected
    Widget _badgeFloatingActionButton(){
      return Stack(
          children: <Widget>[
            Badge(
              badgeContent: Text(_selectedTaskTypesList.length.toString()),
              badgeColor: Theme.of(context).backgroundColor,
              child: Icon(Icons.filter_list),
            )
          ]
      );
    }

    // Floating button
    Widget _floatingActionButton(){
      return FloatingActionButton(
        onPressed: () {
          _openFilterList().then((onValue) {
            // No filter returned, show all events
            if (_selectedTaskTypesList.length == 0){
              _eventsListDisplay = _eventsList;
            } else {
              // Some filters returned, show filtered events
              _eventsListDisplay = _eventsList.where((Event event) {
                return _selectedTaskTypesList.contains(event.taskType.name);
              }).toList();
            }
          });
        },
        // If no filter is selected, don't show any badge
        child: _selectedTaskTypesList.length == 0 ? Icon(Icons.filter_list) : _badgeFloatingActionButton(),
      );
    }

    // Screen builder //
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: ScreenLayouts.appBar(context, _currentAuth),
      body: _body(),
      bottomNavigationBar: ScreenLayouts.bottomNavigationBar(context, _currentAuth, _index, _isLoading),
      floatingActionButton: _floatingActionButton(),
    );
  }

  // Local methods //
  // Load all task types used by organism
  _loadTaskTypes() async {
    // Get task types
    List<TaskType> taskTypesList = await TaskTypeService().getTaskTypes(_currentAuth);
    _stringTaskTypesList = Utils.getTaskTypesFilterList(taskTypesList);
  }

  // Load data
  _load() async {
    // Get participations of the user and events
    List<Participation> participationsList = await ParticipationService().getParticipations(_currentAuth);
    _eventsList = await EventService().getEventsWithFilters(_currentAuth, _currentCell, _startDate, _endDate);

    // Look at the events
    for (Event event in _eventsList){
      // Check if event is in the future
      if (event.isInFuture()){
        // Not registered by default
        event.alreadyRegistered = false;
        for (Participation participation in participationsList){
          // Check if registered
          if (event.id == participation.event){
            event.alreadyRegistered = true;
          }
        }
      }
    }

    // Actualize the display list of events
    _eventsListDisplay = _eventsList;

    // If there is task types selected as filter, apply to the list
    if (_selectedTaskTypesList.isNotEmpty){
      _eventsListDisplay = _eventsListDisplay.where((Event event) {
        return _selectedTaskTypesList.contains(event.taskType.name);
      }).toList();
    }

    setState(() {
      _isLoading = false;
      _isListLoading = false;
    });
  }
}


