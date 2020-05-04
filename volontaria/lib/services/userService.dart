import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/data/user.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/models/token.dart';
import 'package:volontaria/services/globalService.dart';
import 'package:volontaria/utils/network.dart';
import 'package:volontaria/utils/constants.dart';

class UserService implements GlobalService{

  SharedPreferences sharedPreferences;

  Future<String> login(String username, String password) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['authentication'];

    Map body = {
      'login': username,
      'password': password
    };

    // Execute the API call
    var response = await Network().post(customURL, body: body);

    // Create app objects
    return response['token'];

  }

  Future<Auth> getProfile(Token token) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['profile'];
    String tokenValue = await token.getValue();

    // Execute the API call
    var response = await Network().get(customURL, headers: _getHeaders(tokenValue));

    // Create app objects
    return Auth(User.fromJson(response), token);

  }

  Map<String,String> _getHeaders(String token) {
    return {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json; charset=utf-8',
    };
  }



}