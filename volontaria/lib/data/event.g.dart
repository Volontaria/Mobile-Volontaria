part of 'event.dart';

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      id: json['id'] as int,
      taskType: TaskType.fromJson(json['task_type']),
      cell: Cell.fromJson(json['cell']),
      cycle: Cycle.fromJson(json['cycle']),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      volunteers: new List<int>.from(json['volunteers']) as List<int>,
      volunteersStandBy: json['volunteers_standby']!= null ? new List<int>.from(json['volunteers_standby']) : null,
      nbVolunteers: json['nb_volunteers'] as int,
      nbVolunteersNeeded: json['nb_volunteers_needed'] as int,
      nbVolunteersStandBy: json['nb_volunteers_standby'] as int,
      nbVolunteersStandByNeeded: json['nb_volunteers_standby_needed'] as int,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'id' : instance.id,
  'task_type' : instance.taskType.toJson(),
  'cell' : instance.cell.toJson(),
  'cycle' : instance.cycle.toJson(),
  'start_date' : instance.startDate,
  'end_date' : instance.endDate,
  'volunteers' : instance.volunteers,
  'volunteers_standby' : instance.volunteersStandBy,
  'nb_volunteers' : instance.nbVolunteers,
  'nb_volunteers_needed' : instance.nbVolunteersNeeded,
  'nb_volunteers_standby' : instance.nbVolunteersStandBy,
  'nb_volunteers_standby_needed' : instance.nbVolunteersStandByNeeded,
};