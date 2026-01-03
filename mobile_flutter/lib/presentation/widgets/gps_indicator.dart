// lib/presentation/widgets/gps_indicator.dart

import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/utils/location_helper.dart';
import 'package:geolocator/geolocator.dart';

class GpsIndicator extends StatefulWidget {
  const GpsIndicator({super.key});

  @override
  State<GpsIndicator> createState() => _GpsIndicatorState();
}

class _GpsIndicatorState extends State<GpsIndicator> {
  bool _isGpsActive = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkGpsStatus();
  }

  Future<void> _checkGpsStatus() async {
    try {
      final isEnabled = await LocationHelper.isLocationServiceEnabled();
      final position = await LocationHelper.getCurrentPosition();

      if (mounted) {
        setState(() {
          _isGpsActive = isEnabled;
          _currentPosition = position;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGpsActive = false;
          _currentPosition = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isGpsActive ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _isGpsActive ? Icons.gps_fixed : Icons.gps_off,
              color: _isGpsActive ? Colors.green : Colors.red,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isGpsActive ? 'GPS Aktif' : 'GPS Tidak Aktif',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isGpsActive ? Colors.green : Colors.red,
                    ),
                  ),
                  if (_currentPosition != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      LocationHelper.formatCoordinates(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Akurasi: ${_currentPosition!.accuracy.toStringAsFixed(0)}m',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (!_isGpsActive)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _checkGpsStatus,
              ),
          ],
        ),
      ),
    );
  }
}