import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/baseModel.dart';
import 'package:volontaria/data/cell.dart';
import 'package:volontaria/data/cycle.dart';
import 'package:volontaria/data/taskType.dart';
import 'package:volontaria/app/constants.dart';
import 'package:volontaria/utils/utils.dart';

part 'event.g.dart';

@JsonSerializable()
class Event implements BaseModel{
  Event({
    this.id,
    this.taskType,
    this.cell,
    this.cycle,
    this.startDate,
    this.endDate,
    this.volunteers,
    this.volunteersStandBy,
    this.nbVolunteers,
    this.nbVolunteersNeeded,
    this.nbVolunteersStandBy,
    this.nbVolunteersStandByNeeded,
    this.alreadyRegistered,
  });

  // Methods and attributes related to serialization / deserialization
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "task_type")
  final TaskType taskType;

  @JsonKey(name: "cell")
  final Cell cell;

  @JsonKey(name: "cycle")
  final Cycle cycle;

  @JsonKey(name: "start_date")
  final String startDate;

  @JsonKey(name: "end_date")
  final String endDate;

  @JsonKey(name: "volunteers")
  final List<int> volunteers;

  @JsonKey(name: "volunteers_standby")
  final List<int> volunteersStandBy;

  @JsonKey(name: "nb_volunteers")
  final int nbVolunteers;

  @JsonKey(name: "nb_volunteers_needed")
  final int nbVolunteersNeeded;

  @JsonKey(name: "nb_volunteers_standby")
  final int nbVolunteersStandBy;

  @JsonKey(name: "nb_volunteers_standby_needed")
  final int nbVolunteersStandByNeeded;

  // Additional field for event picker, not in database
  bool alreadyRegistered;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  // Methods related to data class
  DateTime getStartTime(){
    return DateTime.parse(startDate).toLocal();
  }

  DateTime getEndTime(){
    return DateTime.parse(endDate).toLocal();
  }

  String getStartTimeDisplay(){
    return DateFormat.yMd().add_Hm().format(getStartTime());
  }

  String getEndTimeDisplay(){
    return DateFormat.yMd().add_Hm().format(getEndTime());
  }

  String getDurationDisplay(){
    return Utils.durationDisplay(getEndTime().difference(getStartTime()));
  }

  bool isInFuture(){
    return getStartTime().isAfter(DateTime.now());
  }

  bool isVolunteersFull(){
    return nbVolunteers>=nbVolunteersNeeded;
  }

  bool isStandbyFull(){
    return nbVolunteersStandBy>=nbVolunteersStandByNeeded;
  }

  bool isAlreadyRegistred(){
    if (alreadyRegistered != null){
      return alreadyRegistered;
    } else {
      return false;
    }
  }

  // Methods for display
  Container getVolunteersInfos(){
    return Container(
        width: 70.0,
        height: 50.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Icon(defaultIconVolunteer, color: defaultIconThemeColor, size: 15),
                    SizedBox(height: 10),
                    Icon(defaultIconStandby, color: defaultIconThemeColor, size: 15),
                  ],
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "  " + this.nbVolunteers.toString() + "/" + this.nbVolunteersNeeded.toString(),
                            style: TextStyle(color: Utils.getColorsFilled(this.nbVolunteers, this.nbVolunteersNeeded)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "  " + this.nbVolunteersStandBy.toString() + "/" + this.nbVolunteersStandByNeeded.toString(),
                            style: TextStyle(color: Utils.getColorsFilled(this.nbVolunteersStandBy, this.nbVolunteersStandByNeeded)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              flex: 2,
            ),
          ],
        )
    );
  }
}
