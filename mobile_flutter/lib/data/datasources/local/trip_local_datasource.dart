// lib/data/datasources/local/trip_local_datasource.dart

import 'package:mobile_flutter/core/config/database_config.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/data/datasources/local/local_database.dart';
import 'package:mobile_flutter/data/models/trip_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class TripLocalDataSource {
  Future<void> cacheTrip(TripModel trip);
  Future<TripModel?> getActiveTrip();
  Future<List<TripModel>> getAllTrips();
  Future<TripModel?> getTripById(String id);
  Future<void> updateTrip(TripModel trip);
  Future<void> deleteTrip(String id);
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  final LocalDatabase localDatabase;

  TripLocalDataSourceImpl(this.localDatabase);

  @override
  Future<void> cacheTrip(TripModel trip) async {
    try {
      final db = await localDatabase.database;
      
      await db.insert(
        DatabaseConfig.tableTrips,
        trip.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      print('✅ Trip cached: ${trip.id}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache trip: $e');
    }
  }

  @override
  Future<TripModel?> getActiveTrip() async {
    try {
      final db = await localDatabase.database;
      
      final result = await db.query(
        DatabaseConfig.tableTrips,
        where: 'status = ?',
        whereArgs: ['active'],
        orderBy: 'created_at DESC',
        limit: 1,
      );
      
      if (result.isEmpty) {
        return null;
      }
      
      return TripModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get active trip: $e');
    }
  }

  @override
  Future<List<TripModel>> getAllTrips() async {
    try {
      final db = await localDatabase.database;
      
      final result = await db.query(
        DatabaseConfig.tableTrips,
        orderBy: 'created_at DESC',
      );
      
      return result.map((map) => TripModel.fromDatabase(map)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get all trips: $e');
    }
  }

  @override
  Future<TripModel?> getTripById(String id) async {
    try {
      final db = await localDatabase.database;
      
      final result = await db.query(
        DatabaseConfig.tableTrips,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      
      if (result.isEmpty) {
        return null;
      }
      
      return TripModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get trip by id: $e');
    }
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    try {
      final db = await localDatabase.database;
      
      await db.update(
        DatabaseConfig.tableTrips,
        trip.toDatabase(),
        where: 'id = ?',
        whereArgs: [trip.id],
      );
      
      print('✅ Trip updated: ${trip.id}');
    } catch (e) {
      throw CacheException(message: 'Failed to update trip: $e');
    }
  }

  @override
  Future<void> deleteTrip(String id) async {
    try {
      final db = await localDatabase.database;
      
      await db.delete(
        DatabaseConfig.tableTrips,
        where: 'id = ?',
        whereArgs: [id],
      );
      
      print('✅ Trip deleted: $id');
    } catch (e) {
      throw CacheException(message: 'Failed to delete trip: $e');
    }
  }
}