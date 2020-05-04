part of 'taskType.dart';

TaskType _$TaskTypeFromJson(Map<String, dynamic> json) {
  return TaskType(
      id: json['id'] as int,
      name: json['name'] as String,
  );
}

Map<String, dynamic> _$TaskTypeToJson(TaskType instance) => <String, dynamic>{
  'id' : instance.id,
  'name' : instance.name,
};
