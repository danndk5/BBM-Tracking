

import 'package:mobile_flutter/domain/entities/spbu.dart';

class SpbuModel extends Spbu {
  const SpbuModel({
    required String id,
    required String nama,
    String? alamat,
    required double latitude,
    required double longitude,
    required String createdAt,
  }) : super(
          id: id,
          nama: nama,
          alamat: alamat,
          latitude: latitude,
          longitude: longitude,
          createdAt: createdAt,
        );

  // From JSON (API Response)
  factory SpbuModel.fromJson(Map<String, dynamic> json) {
    return SpbuModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: json['created_at'] as String,
    );
  }

  // To JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
    };
  }

  // From Database (SQLite)
  factory SpbuModel.fromDatabase(Map<String, dynamic> map) {
    return SpbuModel(
      id: map['id'] as String,
      nama: map['nama'] as String,
      alamat: map['alamat'] as String?,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      createdAt: map['created_at'] as String,
    );
  }

  // To Database (SQLite)
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
    };
  }

  // Copy with
  SpbuModel copyWith({
    String? id,
    String? nama,
    String? alamat,
    double? latitude,
    double? longitude,
    String? createdAt,
  }) {
    return SpbuModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}