import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class Account extends Equatable {
  Account({
    required this.uuid,
    required this.name,
    required this.firstname,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
    required this.photo,
    required this.createAt
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        uuid: map['uuid'] ?? '',
        name: map['name'] ?? '',
        firstname: map['firstname'] ?? '',
        gender: map['gender'] ?? '',
        birthday: map['birthday'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        photo: map['photo'] ?? '',
        createAt: map['createAt'] ?? ''
    );
  }

  String uuid;
  String name;
  String firstname;
  String gender;
  DateTime birthday;
  String phoneNumber;
  String photo;
  final DateTime createAt;

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'firstname': firstname,
      'gender': gender,
      'birthday': birthday,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'createAt': createAt
    };
  }

  @override
  List<Object?> get props => [uuid];

}