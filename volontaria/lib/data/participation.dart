import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/baseModel.dart';
import 'package:volontaria/data/user.dart';

part 'participation.g.dart';

@JsonSerializable()
class Participation implements BaseModel{
  Participation({
    this.id,
    this.event,
    this.user,
    this.standBy,
    this.subscriptionDate,
    this.presenceDurationMinutes,
    this.presenceStatus,
  });

  // Methods and attributes related to serialization / deserialization
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "event")
  final int event;

  @JsonKey(name: "user")
  final User user;

  @JsonKey(name: "standby")
  final bool standBy;

  @JsonKey(name: "subscription_date")
  final String subscriptionDate;

  @JsonKey(name: "presence_duration_minutes")
  final int presenceDurationMinutes;

  @JsonKey(name: "presence_status")
  final String presenceStatus;

  factory Participation.fromJson(Map<String, dynamic> json) => _$ParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipationToJson(this);

  // Methods related to data class
  String getVerboseStatus(){
    switch (presenceStatus){
      case 'I': {return 'Inconnu';}
      case 'A': {return 'Absent';}
      case 'P': {return 'Présent';}
      default : {return '';}
    }
  }
}