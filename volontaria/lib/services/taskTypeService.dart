import 'package:shared_preferences/shared_preferences.dart';
import 'package:volontaria/data/taskType.dart';
import 'package:volontaria/models/auth.dart';
import 'package:volontaria/services/globalService.dart';
import 'package:volontaria/utils/network.dart';
import 'package:volontaria/utils/constants.dart';

class TaskTypeService implements GlobalService{

  SharedPreferences sharedPreferences;

  Future<List<TaskType>> getTaskTypes(Auth auth) async {

    // Set the API call
    sharedPreferences = await SharedPreferences.getInstance();
    String baseURL    = sharedPreferences.getString("apiURL");
    String customURL  = baseURL + routesAPI['tasktypes'];
    String tokenValue = await auth.token.getValue();

    // Execute the API call
    var response = await Network().get(customURL, headers: _getHeaders(tokenValue));

    // Create app objects
    List<TaskType> taskTypesList = List();
      for(var taskType in response['results']){
        taskTypesList.add(TaskType.fromJson(taskType));
    }

    return taskTypesList;

  }

  Map<String,String> _getHeaders(String token) {
    return {
      'Authorization': 'Token ' + token,
      'Content-Type': 'application/json; charset=utf-8',
    };
  }
}