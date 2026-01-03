

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String noPekerja;
  final String nama;
  final String role;
  final String? token;
  final String createdAt;

  const User({
    required this.id,
    required this.noPekerja,
    required this.nama,
    required this.role,
    this.token,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        noPekerja,
        nama,
        role,
        token,
        createdAt,
      ];

  // Check if user is driver
  bool get isDriver => role.toLowerCase() == 'driver';

  // Check if user is supervisor
  bool get isSupervisor => role.toLowerCase() == 'supervisor';
}