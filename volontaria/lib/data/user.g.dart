part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      mobile: json['mobile'] as String,
      isActive: json['is_active'] as bool,
      isSuperuser: json['is_superuser'] as bool,
      //managedCell: json['managed_cell'] as List<Cell>
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id' : instance.id,
  'username' : instance.username,
  'first_name' : instance.firstName,
  'last_name' : instance.lastName,
  'email' : instance.email,
  'phone' : instance.phone,
  'mobile' : instance.mobile,
  'is_active' : instance.isActive,
  'is_superuser' : instance.isSuperuser,
  //'managed_cell' : instance.managedCell
};
