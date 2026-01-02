

import 'package:mobile_flutter/domain/entities/delivery.dart';

class DeliveryModel extends Delivery {
  const DeliveryModel({
    required String id,
    required String tripId,
    required String spbuId,
    required String spbuNama,
    required int urutan,
    String? jamBerangkat,
    String? jamTiba,
    String? jamMulaiBongkar,
    String? jamSelesaiBongkar,
    double? latitudeTiba,
    double? longitudeTiba,
    required String status,
    bool isLanjut = false,
    required String createdAt,
    String? syncedAt,
  }) : super(
          id: id,
          tripId: tripId,
          spbuId: spbuId,
          spbuNama: spbuNama,
          urutan: urutan,
          jamBerangkat: jamBerangkat,
          jamTiba: jamTiba,
          jamMulaiBongkar: jamMulaiBongkar,
          jamSelesaiBongkar: jamSelesaiBongkar,
          latitudeTiba: latitudeTiba,
          longitudeTiba: longitudeTiba,
          status: status,
          isLanjut: isLanjut,
          createdAt: createdAt,
          syncedAt: syncedAt,
        );

  // From JSON (API Response)
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      spbuId: json['spbu_id'] as String,
      spbuNama: json['spbu_nama'] as String,
      urutan: json['urutan'] as int,
      jamBerangkat: json['jam_berangkat'] as String?,
      jamTiba: json['jam_tiba'] as String?,
      jamMulaiBongkar: json['jam_mulai_bongkar'] as String?,
      jamSelesaiBongkar: json['jam_selesai_bongkar'] as String?,
      latitudeTiba: json['latitude_tiba'] != null 
          ? (json['latitude_tiba'] as num).toDouble() 
          : null,
      longitudeTiba: json['longitude_tiba'] != null 
          ? (json['longitude_tiba'] as num).toDouble() 
          : null,
      status: json['status'] as String,
      isLanjut: json['is_lanjut'] == true || json['is_lanjut'] == 1,
      createdAt: json['created_at'] as String,
      syncedAt: json['synced_at'] as String?,
    );
  }

  // To JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'spbu_id': spbuId,
      'spbu_nama': spbuNama,
      'urutan': urutan,
      'jam_berangkat': jamBerangkat,
      'jam_tiba': jamTiba,
      'jam_mulai_bongkar': jamMulaiBongkar,
      'jam_selesai_bongkar': jamSelesaiBongkar,
      'latitude_tiba': latitudeTiba,
      'longitude_tiba': longitudeTiba,
      'status': status,
      'is_lanjut': isLanjut,
      'created_at': createdAt,
      'synced_at': syncedAt,
    };
  }

  // From Database (SQLite)
  factory DeliveryModel.fromDatabase(Map<String, dynamic> map) {
    return DeliveryModel(
      id: map['id'] as String,
      tripId: map['trip_id'] as String,
      spbuId: map['spbu_id'] as String,
      spbuNama: map['spbu_nama'] as String,
      urutan: map['urutan'] as int,
      jamBerangkat: map['jam_berangkat'] as String?,
      jamTiba: map['jam_tiba'] as String?,
      jamMulaiBongkar: map['jam_mulai_bongkar'] as String?,
      jamSelesaiBongkar: map['jam_selesai_bongkar'] as String?,
      latitudeTiba: map['latitude_tiba'] as double?,
      longitudeTiba: map['longitude_tiba'] as double?,
      status: map['status'] as String,
      isLanjut: map['is_lanjut'] == 1,
      createdAt: map['created_at'] as String,
      syncedAt: map['synced_at'] as String?,
    );
  }

  // To Database (SQLite)
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'trip_id': tripId,
      'spbu_id': spbuId,
      'spbu_nama': spbuNama,
      'urutan': urutan,
      'jam_berangkat': jamBerangkat,
      'jam_tiba': jamTiba,
      'jam_mulai_bongkar': jamMulaiBongkar,
      'jam_selesai_bongkar': jamSelesaiBongkar,
      'latitude_tiba': latitudeTiba,
      'longitude_tiba': longitudeTiba,
      'status': status,
      'is_lanjut': isLanjut ? 1 : 0,
      'created_at': createdAt,
      'synced_at': syncedAt,
    };
  }

  // Copy with
  DeliveryModel copyWith({
    String? id,
    String? tripId,
    String? spbuId,
    String? spbuNama,
    int? urutan,
    String? jamBerangkat,
    String? jamTiba,
    String? jamMulaiBongkar,
    String? jamSelesaiBongkar,
    double? latitudeTiba,
    double? longitudeTiba,
    String? status,
    bool? isLanjut,
    String? createdAt,
    String? syncedAt,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      spbuId: spbuId ?? this.spbuId,
      spbuNama: spbuNama ?? this.spbuNama,
      urutan: urutan ?? this.urutan,
      jamBerangkat: jamBerangkat ?? this.jamBerangkat,
      jamTiba: jamTiba ?? this.jamTiba,
      jamMulaiBongkar: jamMulaiBongkar ?? this.jamMulaiBongkar,
      jamSelesaiBongkar: jamSelesaiBongkar ?? this.jamSelesaiBongkar,
      latitudeTiba: latitudeTiba ?? this.latitudeTiba,
      longitudeTiba: longitudeTiba ?? this.longitudeTiba,
      status: status ?? this.status,
      isLanjut: isLanjut ?? this.isLanjut,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}