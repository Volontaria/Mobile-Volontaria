import 'package:flutter/material.dart';
import 'package:volontaria/data/taskType.dart';

class Utils {
  static String durationDisplay(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h$twoDigitMinutes";
  }

  static List<String> getTaskTypesFilterList(List<TaskType> taskTypesList){
    List<String> stringTaskTypesList = List<String>();

    for (TaskType taskType in taskTypesList){
      stringTaskTypesList.add(taskType.name);
    }

    return stringTaskTypesList;
  }

  static dynamic getColorsFilled(int divided, int divider){
    num pourcentage = (divided / divider)*100;
    if (pourcentage>=90){
      return Colors.green;
    } else if (pourcentage >= 60){
      return Colors.orange;
    } else {
      return Colors.redAccent;
    }
  }
}