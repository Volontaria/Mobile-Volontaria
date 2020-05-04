import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/baseModel.dart';

part 'taskType.g.dart';

@JsonSerializable()
class TaskType implements BaseModel{
  TaskType({
    this.id,
    this.name,
  });

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String name;

  factory TaskType.fromJson(Map<String, dynamic> json) => _$TaskTypeFromJson(json);

  Map<String, dynamic> toJson() => _$TaskTypeToJson(this);

}
