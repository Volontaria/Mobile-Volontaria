part of 'address.dart';

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      id: json['id'] as int,
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String,
      postalCode: json['postal_code'] as String,
      city: json['city'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id' : instance.id,
  'address_line1' : instance.addressLine1,
  'address_line2' : instance.addressLine2,
  'postal_code' : instance.postalCode,
  'city' : instance.city,
};
