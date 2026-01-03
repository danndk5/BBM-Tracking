

import 'package:equatable/equatable.dart';

class Spbu extends Equatable {
  final String id;
  final String nama;
  final String? alamat;
  final double latitude;
  final double longitude;
  final String createdAt;

  const Spbu({
    required this.id,
    required this.nama,
    this.alamat,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        nama,
        alamat,
        latitude,
        longitude,
        createdAt,
      ];

  // Get formatted address for display
  String get displayAddress => alamat ?? 'Alamat tidak tersedia';

  // Get coordinates as string
  String get coordinatesString => '$latitude, $longitude';
}