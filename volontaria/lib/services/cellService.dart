import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/data/cell.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/services/globalService.dart';
import 'package:volontaria/utils/network.dart';
import 'package:volontaria/app/constants.dart';

class CellService implements GlobalService{

  SharedPreferences sharedPreferences;

  Future<List<Cell>> getCells(Auth auth) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['cells'] + '?ordering=name';
    String tokenValue = await auth.token.getValue();

    // Execute the API call
    var response = await Network().get(customURL, headers: _getHeaders(tokenValue));

    // Create app objects
    List<Cell> cellsList = List();
      for(var cell in response['results']){
        cellsList.add(Cell.fromJson(cell));
    }

    return cellsList;

  }

  Map<String,String> _getHeaders(String token) {
    return {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json; charset=utf-8',
    };
  }
}