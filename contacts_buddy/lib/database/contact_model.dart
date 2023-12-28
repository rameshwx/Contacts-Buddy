import 'package:contacts_buddy/database/database_helper.dart';

class Contact {
  int? id;
  String? name;
  int? phoneNumber;
  String? email;

  Contact({this.id, this.name, this.phoneNumber, this.email});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.nameTable.toString(): name,
      DatabaseHelper.numberTable.toString(): phoneNumber,
      DatabaseHelper.emailTable.toString(): email
    };
    if (id != null) {
      map[DatabaseHelper.idTable] = id;
    }

    return map;
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
        id: map[DatabaseHelper.idTable],
        name: map[DatabaseHelper.nameTable],
        phoneNumber: map[DatabaseHelper.numberTable],
        email: map[DatabaseHelper.emailTable]);
  }
}
