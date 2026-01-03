

import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final String id;
  final String userId;
  final String noKendaraan;
  final String namaDriver;
  final String? namaAwak2;
  final String status; // 'active', 'completed'
  final String createdAt;
  final String? syncedAt;

  const Trip({
    required this.id,
    required this.userId,
    required this.noKendaraan,
    required this.namaDriver,
    this.namaAwak2,
    required this.status,
    required this.createdAt,
    this.syncedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        noKendaraan,
        namaDriver,
        namaAwak2,
        status,
        createdAt,
        syncedAt,
      ];

  // Check if trip is active
  bool get isActive => status.toLowerCase() == 'active';

  // Check if trip is completed
  bool get isCompleted => status.toLowerCase() == 'completed';

  // Check if synced with server
  bool get isSynced => syncedAt != null;

  // Get crew info
  String get crewInfo {
    if (namaAwak2 != null && namaAwak2!.isNotEmpty) {
      return '$namaDriver & $namaAwak2';
    }
    return namaDriver;
  }
}