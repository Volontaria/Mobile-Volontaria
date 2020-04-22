import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/data/event.dart';
import 'package:volontaria/data/participation.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/services/globalService.dart';
import 'package:volontaria/utils/network.dart';
import 'package:volontaria/app/constants.dart';

class ParticipationService implements GlobalService{

  SharedPreferences sharedPreferences;

  Future<List<Participation>> getParticipations(Auth auth) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['participations'] + '?username=' + auth.user.username;
    String tokenValue = await auth.token.getValue();

    // Execute the API call
    var response = await Network().get(customURL, headers: _getHeaders(tokenValue));

    // Create app objects
    List<Participation> participationsList = List();
    for(var participation in response['results']){
      participationsList.add(Participation.fromJson(participation));
    }

    return participationsList;

  }

  Future<void> deleteParticipation(Auth auth, Participation participation) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['participations'] + '/' + participation.id.toString();
    String tokenValue = await auth.token.getValue();

    // Execute the API call
    await Network().delete(customURL, headers: _getHeaders(tokenValue));

  }

  Future<void> createParticipation(Auth auth, Event event, bool standby) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['participations'];
    String tokenValue = await auth.token.getValue();

    Map<String,dynamic> body = {
      'event': event.id,
      'standby': standby,
    };
    final msg = jsonEncode(body);

    // Execute the API call
    await Network().post(customURL, body: msg, headers: _getHeaders(tokenValue));

  }

  Map<String,String> _getHeaders(String token) {
    return {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json; charset=utf-8',
    };
  }
}