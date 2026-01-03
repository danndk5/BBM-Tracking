

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile_flutter/core/config/app_config.dart';
import 'package:mobile_flutter/core/config/database_config.dart';

class LocalDatabase {
  static LocalDatabase? _instance;
  static Database? _database;

  LocalDatabase._internal();

  factory LocalDatabase() {
    _instance ??= LocalDatabase._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);

    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create all tables
    await db.execute(DatabaseConfig.createTableUsers);
    await db.execute(DatabaseConfig.createTableTrips);
    await db.execute(DatabaseConfig.createTableDeliveries);
    await db.execute(DatabaseConfig.createTableSPBU);
    await db.execute(DatabaseConfig.createTableSyncQueue);

    // Create indexes
    await db.execute(DatabaseConfig.createIndexTripUserId);
    await db.execute(DatabaseConfig.createIndexDeliveryTripId);
    await db.execute(DatabaseConfig.createIndexSyncQueue);

    print('✅ Database created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      print('Upgrading database from v$oldVersion to v$newVersion');
      // Add migration logic here when needed
    }
  }

  // Clear all data (for logout or reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(DatabaseConfig.tableUsers);
    await db.delete(DatabaseConfig.tableTrips);
    await db.delete(DatabaseConfig.tableDeliveries);
    await db.delete(DatabaseConfig.tableSPBU);
    await db.delete(DatabaseConfig.tableSyncQueue);
    print('✅ All data cleared');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    print('✅ Database closed');
  }

  // Delete database (for testing)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
    print('✅ Database deleted');
  }
}