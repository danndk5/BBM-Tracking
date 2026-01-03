// lib/presentation/pages/create_trip_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/core/constants/app_strings.dart';
import 'package:mobile_flutter/core/utils/validators.dart';
import 'package:mobile_flutter/domain/entities/spbu.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_event.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_state.dart';
import 'package:mobile_flutter/presentation/widgets/custom_button.dart';
import 'package:mobile_flutter/presentation/widgets/custom_text_field.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _noKendaraanController = TextEditingController();
  final _namaDriverController = TextEditingController();
  final _namaAwak2Controller = TextEditingController();

  List<Spbu> _spbuList = [];
  Spbu? _selectedSpbu;

  @override
  void initState() {
    super.initState();
    context.read<TripBloc>().add(LoadSpbuList());
  }

  @override
  void dispose() {
    _noKendaraanController.dispose();
    _namaDriverController.dispose();
    _namaAwak2Controller.dispose();
    super.dispose();
  }

  void _handleCreateTrip() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSpbu == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih SPBU tujuan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<TripBloc>().add(
            CreateTripRequested(
              noKendaraan: Validators.normalizeNomorKendaraan(
                _noKendaraanController.text,
              ),
              namaDriver: _namaDriverController.text.trim(),
              namaAwak2: _namaAwak2Controller.text.trim().isEmpty
                  ? null
                  : _namaAwak2Controller.text.trim(),
              spbuId: _selectedSpbu!.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createTrip),
      ),
      body: BlocListener<TripBloc, TripState>(
        listener: (context, state) {
          if (state is SpbuListLoaded) {
            setState(() {
              _spbuList = state.spbuList;
            });
          } else if (state is TripCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Trip berhasil dibuat'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is TripError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading && _spbuList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _noKendaraanController,
                      label: AppStrings.nomorKendaraan,
                      hint: 'B 1234 XYZ',
                      validator: Validators.validateNomorKendaraan,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _namaDriverController,
                      label: AppStrings.namaDriver,
                      hint: 'Nama lengkap driver',
                      validator: Validators.validateNama,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _namaAwak2Controller,
                      label: AppStrings.namaAwak2,
                      hint: 'Nama lengkap awak 2 (opsional)',
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Spbu>(
                      value: _selectedSpbu,
                      decoration: InputDecoration(
                        labelText: AppStrings.spbuTujuan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _spbuList.map((spbu) {
                        return DropdownMenuItem<Spbu>(
                          value: spbu,
                          child: Text(spbu.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSpbu = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih SPBU tujuan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Buat Trip',
                      icon: Icons.add_circle,
                      onPressed: state is TripLoading ? null : _handleCreateTrip,
                      isLoading: state is TripLoading && _spbuList.isNotEmpty,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}