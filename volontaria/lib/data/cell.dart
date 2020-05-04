import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/address.dart';
import 'package:volontaria/data/baseModel.dart';
import 'package:volontaria/data/user.dart';

part 'cell.g.dart';

@JsonSerializable()
class Cell implements BaseModel{
  Cell({
    this.id,
    this.name,
    this.address,
    this.managers,
  });

  // Methods and attributes related to serialization / deserialization
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "address")
  final Address address;

  @JsonKey(name: "managers")
  final User managers;

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);

  Map<String, dynamic> toJson() => _$CellToJson(this);

  // Methods related to data class

}
