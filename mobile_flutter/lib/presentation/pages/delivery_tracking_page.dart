// lib/presentation/pages/delivery_tracking_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/core/constants/app_strings.dart';
import 'package:mobile_flutter/core/utils/location_helper.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_event.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_state.dart';
import 'package:mobile_flutter/presentation/widgets/custom_button.dart';
import 'package:mobile_flutter/presentation/widgets/gps_indicator.dart';
import 'package:mobile_flutter/presentation/widgets/status_timeline.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final String tripId;

  const DeliveryTrackingPage({
    super.key,
    required this.tripId,
  });

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  Delivery? _currentDelivery;

  @override
  void initState() {
    super.initState();
    _loadCurrentDelivery();
  }

  void _loadCurrentDelivery() {
    context.read<DeliveryBloc>().add(LoadCurrentDelivery(widget.tripId));
  }

  Future<void> _handleTiba() async {
    if (_currentDelivery == null) return;

    try {
      final position = await LocationHelper.getCurrentPosition();

      if (!mounted) return;

      context.read<DeliveryBloc>().add(
            UpdateTibaRequested(
              deliveryId: _currentDelivery!.id,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('GPS Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleMulaiBongkar() {
    if (_currentDelivery == null) return;

    context.read<DeliveryBloc>().add(
          UpdateMulaiBongkarRequested(_currentDelivery!.id),
        );
  }

  void _handleSelesaiBongkar() {
    if (_currentDelivery == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembongkaran Selesai'),
        content: const Text('Apakah akan lanjut ke SPBU berikutnya?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitSelesaiBongkar(false); // Pulang
            },
            child: const Text(AppStrings.pulang),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitSelesaiBongkar(true); // Lanjut
            },
            child: const Text(AppStrings.lanjutSPBU),
          ),
        ],
      ),
    );
  }

  void _submitSelesaiBongkar(bool isLanjut) {
    context.read<DeliveryBloc>().add(
          UpdateSelesaiBongkarRequested(
            deliveryId: _currentDelivery!.id,
            isLanjut: isLanjut,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Pengiriman'),
      ),
      body: BlocListener<DeliveryBloc, DeliveryState>(
        listener: (context, state) {
          if (state is CurrentDeliveryLoaded) {
            setState(() {
              _currentDelivery = state.delivery;
            });
          } else if (state is DeliveryUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Status berhasil diupdate'),
                backgroundColor: Colors.green,
              ),
            );
            _loadCurrentDelivery();
          } else if (state is DeliveryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<DeliveryBloc, DeliveryState>(
          builder: (context, state) {
            if (state is DeliveryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_currentDelivery == null) {
              return const Center(
                child: Text('Tidak ada delivery aktif'),
              );
            }

            return _buildTrackingView(_currentDelivery!);
          },
        ),
      ),
    );
  }

  Widget _buildTrackingView(Delivery delivery) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    delivery.spbuNama,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tujuan #${delivery.urutan}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const GpsIndicator(),
          const SizedBox(height: 24),
          StatusTimeline(delivery: delivery),
          const SizedBox(height: 32),
          _buildActionButton(delivery),
        ],
      ),
    );
  }

  Widget _buildActionButton(Delivery delivery) {
    if (delivery.canTiba) {
      return CustomButton(
        text: AppStrings.sudahTiba,
        icon: Icons.location_on,
        onPressed: _handleTiba,
      );
    } else if (delivery.canMulaiBongkar) {
      return CustomButton(
        text: AppStrings.mulaiBongkar,
        icon: Icons.play_arrow,
        onPressed: _handleMulaiBongkar,
      );
    } else if (delivery.canSelesaiBongkar) {
      return CustomButton(
        text: AppStrings.selesaiBongkar,
        icon: Icons.check_circle,
        onPressed: _handleSelesaiBongkar,
      );
    }

    return const SizedBox.shrink();
  }
}