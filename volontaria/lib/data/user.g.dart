part of 'user.dart';

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
      managedCell: _$ManagedCellsFromJson(json),
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
  'managed_cell' : _$ManagedCellsToJson(instance.managedCell),
};

List<Cell> _$ManagedCellsFromJson(Map<String, dynamic> json){
  var jsonList = json['managed_cell'] as List;
  List<Cell> cellList = jsonList.map((cell) => Cell.fromJson(cell)).toList();
  return cellList;
}

List<Map<String, dynamic>> _$ManagedCellsToJson(List<Cell> cells){
  List<Map<String, dynamic>> managedCell = List();
  for(Cell cell in cells){
    managedCell.add(cell.toJson());
  }
  return managedCell;
}