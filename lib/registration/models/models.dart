import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class Account extends Equatable {
  String uuid;
  String name;
  String firstname;
  String gender;
  DateTime birthday;
  String phoneNumber;
  String photo;
  final DateTime createAt;
  String accountType;

  Account({
    required this.uuid,
    required this.name,
    required this.firstname,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
    required this.photo,
    required this.createAt,
    required this.accountType
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    print(map['birthday']);
    return Account(
      uuid: map['uuid'] ?? '',
      name: map['name'] ?? '',
      firstname: map['firstname'] ?? '',
      gender: map['gender'] ?? '',
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday'].seconds * 1000, isUtc: true),
      phoneNumber: map['phoneNumber'] ?? '',
      photo: map['photo'] ?? '',
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'].seconds * 1000, isUtc: true),
      accountType: map['accountType'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'firstname': firstname,
      'gender': gender,
      'birthday': birthday,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'createAt': createAt,
      'accountType': accountType,
    };
  }

  @override
  List<Object?> get props => [uuid];

}