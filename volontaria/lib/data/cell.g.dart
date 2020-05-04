part of 'cell.dart';

Cell _$CellFromJson(Map<String, dynamic> json) {
  return Cell(
      id: json['id'] as int,
      name: json['name'] as String,
      address: Address.fromJson(json['address']),
      //managers: User.fromJson(json['managers']),
  );
}

Map<String, dynamic> _$CellToJson(Cell instance) => <String, dynamic>{
  'id' : instance.id,
  'name' : instance.name,
  'address' : instance.address.toJson(),
  'managers' : instance.managers.toJson(),
};
