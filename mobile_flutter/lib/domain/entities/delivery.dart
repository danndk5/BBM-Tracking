

import 'package:equatable/equatable.dart';

class Delivery extends Equatable {
  final String id;
  final String tripId;
  final String spbuId;
  final String spbuNama;
  final int urutan;
  final String? jamBerangkat;
  final String? jamTiba;
  final String? jamMulaiBongkar;
  final String? jamSelesaiBongkar;
  final double? latitudeTiba;
  final double? longitudeTiba;
  final String status; // 'pending', 'berangkat', 'tiba', 'bongkar', 'selesai'
  final bool isLanjut;
  final String createdAt;
  final String? syncedAt;

  const Delivery({
    required this.id,
    required this.tripId,
    required this.spbuId,
    required this.spbuNama,
    required this.urutan,
    this.jamBerangkat,
    this.jamTiba,
    this.jamMulaiBongkar,
    this.jamSelesaiBongkar,
    this.latitudeTiba,
    this.longitudeTiba,
    required this.status,
    this.isLanjut = false,
    required this.createdAt,
    this.syncedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tripId,
        spbuId,
        spbuNama,
        urutan,
        jamBerangkat,
        jamTiba,
        jamMulaiBongkar,
        jamSelesaiBongkar,
        latitudeTiba,
        longitudeTiba,
        status,
        isLanjut,
        createdAt,
        syncedAt,
      ];

  // Status checks
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isBerangkat => status.toLowerCase() == 'berangkat';
  bool get isTiba => status.toLowerCase() == 'tiba';
  bool get isBongkar => status.toLowerCase() == 'bongkar';
  bool get isSelesai => status.toLowerCase() == 'selesai';

  // Check if synced
  bool get isSynced => syncedAt != null;

  // Check if has GPS coordinates
  bool get hasCoordinates => latitudeTiba != null && longitudeTiba != null;

  // Get status display text
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Belum Berangkat';
      case 'berangkat':
        return 'Dalam Perjalanan';
      case 'tiba':
        return 'Sudah Tiba';
      case 'bongkar':
        return 'Sedang Bongkar';
      case 'selesai':
        return 'Selesai';
      default:
        return status;
    }
  }

  // Get next action text
  String? get nextAction {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Berangkat';
      case 'berangkat':
        return 'Sudah Tiba';
      case 'tiba':
        return 'Mulai Bongkar';
      case 'bongkar':
        return 'Selesai Bongkar';
      case 'selesai':
        return null; // No next action
      default:
        return null;
    }
  }

  // Check if can perform action
  bool get canBerangkat => isPending;
  bool get canTiba => isBerangkat;
  bool get canMulaiBongkar => isTiba;
  bool get canSelesaiBongkar => isBongkar;
}