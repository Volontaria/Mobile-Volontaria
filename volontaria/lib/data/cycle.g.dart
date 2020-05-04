part of 'cycle.dart';

Cycle _$CycleFromJson(Map<String, dynamic> json) {
  return Cycle(
      id: json['id'] as int,
      name: json['name'] as String,
      startDate: json['address_line2'] as String,
      endDate: json['postal_code'] as String,
  );
}

Map<String, dynamic> _$CycleToJson(Cycle instance) => <String, dynamic>{
  'id' : instance.id,
  'name' : instance.name,
  'start_date' : instance.startDate,
  'end_date' : instance.endDate,
};
