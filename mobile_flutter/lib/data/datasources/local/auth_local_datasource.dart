// lib/data/datasources/local/auth_local_datasource.dart

import 'package:mobile_flutter/core/config/database_config.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/data/datasources/local/local_database.dart';
import 'package:mobile_flutter/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDatabase localDatabase;

  AuthLocalDataSourceImpl(this.localDatabase);

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final db = await localDatabase.database;
      
      // Delete existing user data
      await db.delete(DatabaseConfig.tableUsers);
      
      // Insert new user
      await db.insert(
        DatabaseConfig.tableUsers,
        user.toDatabase(),
      );
      
      print('✅ User cached: ${user.nama}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final db = await localDatabase.database;
      
      final result = await db.query(
        DatabaseConfig.tableUsers,
        limit: 1,
      );
      
      if (result.isEmpty) {
        return null;
      }
      
      return UserModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      final db = await localDatabase.database;
      await db.delete(DatabaseConfig.tableUsers);
      print('✅ User cache cleared');
    } catch (e) {
      throw CacheException(message: 'Failed to clear user cache: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final user = await getCachedUser();
      return user != null && user.token != null && user.token!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}