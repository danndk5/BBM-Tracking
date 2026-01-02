

import 'package:mobile_flutter/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String noPekerja,
    required String nama,
    required String role,
    String? token,
    required String createdAt,
  }) : super(
          id: id,
          noPekerja: noPekerja,
          nama: nama,
          role: role,
          token: token,
          createdAt: createdAt,
        );

  // From JSON (API Response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      noPekerja: json['no_pekerja'] as String,
      nama: json['nama'] as String,
      role: json['role'] as String,
      token: json['token'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  // To JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_pekerja': noPekerja,
      'nama': nama,
      'role': role,
      'token': token,
      'created_at': createdAt,
    };
  }

  // From Database (SQLite)
  factory UserModel.fromDatabase(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      noPekerja: map['no_pekerja'] as String,
      nama: map['nama'] as String,
      role: map['role'] as String,
      token: map['token'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  // To Database (SQLite)
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'no_pekerja': noPekerja,
      'nama': nama,
      'role': role,
      'token': token,
      'created_at': createdAt,
    };
  }

  // Copy with
  UserModel copyWith({
    String? id,
    String? noPekerja,
    String? nama,
    String? role,
    String? token,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      noPekerja: noPekerja ?? this.noPekerja,
      nama: nama ?? this.nama,
      role: role ?? this.role,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}