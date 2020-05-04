part of 'participation.dart';

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return Participation(
      id: json['id'] as int,
      event: json['event'] as int,
      user: User.fromJson(json['user']),
      standBy: json['standby'] as bool,
      subscriptionDate: json['subscription_date'] as String,
      presenceDurationMinutes: json['presence_duration_minutes'] as int,
      presenceStatus: json['presence_status'] as String,
  );
}

Map<String, dynamic> _$ParticipationToJson(Participation instance) => <String, dynamic>{
  'id' : instance.id,
  'event' : instance.event,
  'user' : instance.user.toJson(),
  'standby' : instance.standBy,
  'subscription_date' : instance.subscriptionDate,
  'presence_duration_minutes' : instance.presenceDurationMinutes,
  'presence_status' : instance.presenceStatus,
};