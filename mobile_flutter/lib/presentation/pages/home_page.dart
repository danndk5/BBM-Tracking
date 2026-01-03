// lib/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/core/constants/app_strings.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_event.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_state.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_event.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_state.dart';
import 'package:mobile_flutter/presentation/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TripBloc>().add(LoadActiveTrip());
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.batal),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TripError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TripBloc>().add(LoadActiveTrip());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is TripLoaded) {
              if (state.trip == null) {
                return _buildNoActiveTrip();
              } else {
                return _buildActiveTripView(state.trip!);
              }
            }

            return _buildNoActiveTrip();
          },
        ),
      ),
    );
  }

  Widget _buildNoActiveTrip() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Tidak Ada Trip Aktif',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Buat trip baru untuk memulai pengiriman',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: AppStrings.createTrip,
              icon: Icons.add,
              onPressed: () {
                Navigator.pushNamed(context, '/create-trip');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTripView(trip) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Aktif',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow('Kendaraan', trip.noKendaraan),
                  _buildInfoRow('Driver', trip.namaDriver),
                  if (trip.namaAwak2 != null)
                    _buildInfoRow('Awak 2', trip.namaAwak2!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Mulai Tracking',
            icon: Icons.navigation,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/delivery-tracking',
                arguments: trip.id,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}