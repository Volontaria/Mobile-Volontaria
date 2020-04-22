import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/data/cell.dart';
import 'package:volontaria/data/event.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/services/globalService.dart';
import 'package:volontaria/utils/network.dart';
import 'package:volontaria/app/constants.dart';

class EventService implements GlobalService{

  SharedPreferences sharedPreferences;

  Future<List<Event>> getEventsVolunteers(Auth auth) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['events'] + '?volunteers=' + auth.user.id.toString();
    String tokenValue = await auth.token.getValue();

    // Execute the API call
    var response = await Network().get(customURL, headers: _getHeaders(tokenValue));

    // Create app objects
    List<Event> eventsList = List();
    for(var event in response['results']){
      eventsList.add(Event.fromJson(event));
    }

    return eventsList;

  }

  Future<List<Event>> getEventsWithFilters(Auth auth, Cell cell, DateTime startDate, DateTime endDate) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['events'] + "?cell=" + cell.id.toString() +  '&start_date=' + startDate.toUtc().toString() + '&end_date=' + endDate.toUtc().toString();
    String tokenValue = await auth.token.getValue();

    // Execute the API call
    var response = await Network().get(customURL, headers: _getHeaders(tokenValue));

    // Create app objects
    List<Event> eventsList = List();
    for(var event in response['results']){
      eventsList.add(Event.fromJson(event));
    }

    return eventsList;

  }

  Map<String,String> _getHeaders(String token) {
    return {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json; charset=utf-8',
    };
  }
}