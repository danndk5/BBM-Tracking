

import 'package:mobile_flutter/domain/entities/trip.dart';

class TripModel extends Trip {
  const TripModel({
    required String id,
    required String userId,
    required String noKendaraan,
    required String namaDriver,
    String? namaAwak2,
    required String status,
    required String createdAt,
    String? syncedAt,
  }) : super(
          id: id,
          userId: userId,
          noKendaraan: noKendaraan,
          namaDriver: namaDriver,
          namaAwak2: namaAwak2,
          status: status,
          createdAt: createdAt,
          syncedAt: syncedAt,
        );

  // From JSON (API Response)
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      noKendaraan: json['no_kendaraan'] as String,
      namaDriver: json['nama_driver'] as String,
      namaAwak2: json['nama_awak2'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      syncedAt: json['synced_at'] as String?,
    );
  }

  // To JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'no_kendaraan': noKendaraan,
      'nama_driver': namaDriver,
      'nama_awak2': namaAwak2,
      'status': status,
      'created_at': createdAt,
      'synced_at': syncedAt,
    };
  }

  // From Database (SQLite)
  factory TripModel.fromDatabase(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      noKendaraan: map['no_kendaraan'] as String,
      namaDriver: map['nama_driver'] as String,
      namaAwak2: map['nama_awak2'] as String?,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
      syncedAt: map['synced_at'] as String?,
    );
  }

  // To Database (SQLite)
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'no_kendaraan': noKendaraan,
      'nama_driver': namaDriver,
      'nama_awak2': namaAwak2,
      'status': status,
      'created_at': createdAt,
      'synced_at': syncedAt,
    };
  }

  // Copy with
  TripModel copyWith({
    String? id,
    String? userId,
    String? noKendaraan,
    String? namaDriver,
    String? namaAwak2,
    String? status,
    String? createdAt,
    String? syncedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      noKendaraan: noKendaraan ?? this.noKendaraan,
      namaDriver: namaDriver ?? this.namaDriver,
      namaAwak2: namaAwak2 ?? this.namaAwak2,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}