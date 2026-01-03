// lib/data/datasources/local/delivery_local_datasource.dart

import 'package:mobile_flutter/core/config/database_config.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/data/datasources/local/local_database.dart';
import 'package:mobile_flutter/data/models/delivery_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DeliveryLocalDataSource {
  Future<void> cacheDelivery(DeliveryModel delivery);
  Future<List<DeliveryModel>> getDeliveriesByTripId(String tripId);
  Future<DeliveryModel?> getDeliveryById(String id);
  Future<void> updateDelivery(DeliveryModel delivery);
  Future<void> deleteDelivery(String id);
  Future<DeliveryModel?> getCurrentDelivery(String tripId);
}

class DeliveryLocalDataSourceImpl implements DeliveryLocalDataSource {
  final LocalDatabase localDatabase;

  DeliveryLocalDataSourceImpl(this.localDatabase);

  @override
  Future<void> cacheDelivery(DeliveryModel delivery) async {
    try {
      final db = await localDatabase.database;
      
      await db.insert(
        DatabaseConfig.tableDeliveries,
        delivery.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      print('✅ Delivery cached: ${delivery.id}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache delivery: $e');
    }
  }

  @override
  Future<List<DeliveryModel>> getDeliveriesByTripId(String tripId) async {
    try {
      final db = await localDatabase.database;
      
      final result = await db.query(
        DatabaseConfig.tableDeliveries,
        where: 'trip_id = ?',
        whereArgs: [tripId],
        orderBy: 'urutan ASC',
      );
      
      return result.map((map) => DeliveryModel.fromDatabase(map)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get deliveries: $e');
    }
  }

  @override
  Future<DeliveryModel?> getDeliveryById(String id) async {
    try {
      final db = await localDatabase.database;
      
      final result = await db.query(
        DatabaseConfig.tableDeliveries,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      
      if (result.isEmpty) {
        return null;
      }
      
      return DeliveryModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get delivery by id: $e');
    }
  }

  @override
  Future<void> updateDelivery(DeliveryModel delivery) async {
    try {
      final db = await localDatabase.database;
      
      await db.update(
        DatabaseConfig.tableDeliveries,
        delivery.toDatabase(),
        where: 'id = ?',
        whereArgs: [delivery.id],
      );
      
      print('✅ Delivery updated: ${delivery.id}');
    } catch (e) {
      throw CacheException(message: 'Failed to update delivery: $e');
    }
  }

  @override
  Future<void> deleteDelivery(String id) async {
    try {
      final db = await localDatabase.database;
      
      await db.delete(
        DatabaseConfig.tableDeliveries,
        where: 'id = ?',
        whereArgs: [id],
      );
      
      print('✅ Delivery deleted: $id');
    } catch (e) {
      throw CacheException(message: 'Failed to delete delivery: $e');
    }
  }

  @override
  Future<DeliveryModel?> getCurrentDelivery(String tripId) async {
    try {
      final db = await localDatabase.database;
      
      // Get delivery yang belum selesai (bukan status 'selesai')
      final result = await db.query(
        DatabaseConfig.tableDeliveries,
        where: 'trip_id = ? AND status != ?',
        whereArgs: [tripId, 'selesai'],
        orderBy: 'urutan ASC',
        limit: 1,
      );
      
      if (result.isEmpty) {
        return null;
      }
      
      return DeliveryModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get current delivery: $e');
    }
  }
}