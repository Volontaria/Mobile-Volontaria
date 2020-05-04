import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/baseModel.dart';

part 'cycle.g.dart';

@JsonSerializable()
class Cycle implements BaseModel{
  Cycle({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
  });

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "start_date")
  final String startDate;

  @JsonKey(name: "end_date")
  final String endDate;

  factory Cycle.fromJson(Map<String, dynamic> json) => _$CycleFromJson(json);

  Map<String, dynamic> toJson() => _$CycleToJson(this);

}
