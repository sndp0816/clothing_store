import 'package:clothing_store/features/auth/domain/entities/user.dart';

class UserModel {
  const UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
      );

  final String id;
  final String email;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};

  User toEntity() => User(id: id, email: email, name: name);
}
