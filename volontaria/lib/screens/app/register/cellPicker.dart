import 'package:flutter/material.dart';
import 'package:volontaria/data/cell.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/models/registration.dart';
import 'package:volontaria/screens/customs.layout/screens.layouts.dart';
import 'package:volontaria/services/cellService.dart';

class CellPickerPage extends StatefulWidget {

  Auth _contextAuth;

  CellPickerPage(Auth auth){
    this._contextAuth = auth;
  }

  @override
  _CellPickerPageState createState() => _CellPickerPageState(_contextAuth);
}

class _CellPickerPageState extends State<CellPickerPage> with WidgetsBindingObserver {

  num _index = 2;
  bool _isLoading = true;

  // Data for screen
  Auth _currentAuth;
  List<Cell> _cellsListDisplay;

  _CellPickerPageState(Auth auth){
    this._currentAuth = auth;
  }

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
    // Text card content
    Widget _titleCard(Cell cell){
      return Text(
        cell.name,
        style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
      );
    }

    // Text card content
    Widget _subtitleCard(Cell cell){
      return Text(
        cell.address.city + ", " + cell.address.postalCode,
        style: Theme.of(context).textTheme.body1,
      );
    }

    // Card content
    Widget _cardContent(Cell cell){
      return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: _titleCard(cell),
          subtitle: _subtitleCard(cell),
          trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).iconTheme.color, size: 30.0),
          onTap: () {
            // Navigate to events screen of this cell
            Navigator.pushNamed(context, '/app/events', arguments: Registration(_currentAuth, cell));
          }
      );
    }

    // Card holder
    Widget _cellCard(Cell cell) {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _cardContent(cell),
        ),
      );
    }

    // List of cards
    Widget _listView(){
      return Expanded(
          child: _cellsListDisplay.length == 0 ? ScreenLayouts.centerText(context, "Aucune cellule à afficher") : Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _cellsListDisplay != null ? _cellsListDisplay.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return _cellCard(_cellsListDisplay[index]);
              },
            ),
          )
      );
    }

    // Body container
    Widget _body(){
      return Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ScreenLayouts.topPageTitle(context, "Cellules"),
            _listView(),
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
    // Get cells
    _cellsListDisplay = await CellService().getCells(_currentAuth);

    setState(() {
      _isLoading = false;
    });

    // If there is only one cell available, go directly to the events of this cell
    if (_cellsListDisplay.length == 1){
      Navigator.pushNamedAndRemoveUntil(context, '/app/events', (Route<dynamic> route) => false, arguments: Registration(_currentAuth, _cellsListDisplay[0]));
    }
  }
}