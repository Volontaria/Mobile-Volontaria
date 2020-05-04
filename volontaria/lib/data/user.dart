import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/baseModel.dart';
import 'package:volontaria/data/cell.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements BaseModel{
  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.mobile,
    this.isActive,
    this.isSuperuser,
    this.managedCell,
  });

  // Methods and attributes related to serialization / deserialization
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "username")
  final String username;

  @JsonKey(name: "first_name")
  final String firstName;

  @JsonKey(name: "last_name")
  final String lastName;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "phone")
  final String phone;

  @JsonKey(name: "mobile")
  final String mobile;

  @JsonKey(name: "is_active")
  final bool isActive;

  @JsonKey(name: "is_superuser")
  final bool isSuperuser;

  @JsonKey(name: "managed_cell")
  final List<Cell> managedCell;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Methods related to data class
}
