import 'package:json_annotation/json_annotation.dart';
import 'package:volontaria/data/baseModel.dart';

part 'address.g.dart';

@JsonSerializable()
class Address implements BaseModel{
  Address({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.postalCode,
    this.city,
  });

  // Methods and attributes related to serialization / deserialization
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "address_line1")
  final String addressLine1;

  @JsonKey(name: "address_line2")
  final String addressLine2;

  @JsonKey(name: "postal_code")
  final String postalCode;

  @JsonKey(name: "city")
  final String city;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  // Methods related to data class

  String getAddressDisplay(){
    String address = this.addressLine1;
    if (this.addressLine2.isNotEmpty){
      address = address + '\n' + this.addressLine2;
    }
    address = address + '\n' + this.postalCode + '\n' + this.city;
    return address;
  }

}
