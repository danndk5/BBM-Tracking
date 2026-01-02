

class DatabaseConfig {
  // Table Names
  static const String tableUsers = 'users';
  static const String tableTrips = 'trips';
  static const String tableDeliveries = 'deliveries';
  static const String tableSPBU = 'spbu';
  static const String tableSyncQueue = 'sync_queue';
  
  // SQL Create Tables
  static const String createTableUsers = '''
    CREATE TABLE $tableUsers (
      id TEXT PRIMARY KEY,
      no_pekerja TEXT NOT NULL,
      nama TEXT NOT NULL,
      role TEXT NOT NULL,
      token TEXT,
      created_at TEXT NOT NULL
    )
  ''';
  
  static const String createTableTrips = '''
    CREATE TABLE $tableTrips (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      no_kendaraan TEXT NOT NULL,
      nama_driver TEXT NOT NULL,
      nama_awak2 TEXT,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      synced_at TEXT,
      FOREIGN KEY (user_id) REFERENCES $tableUsers (id)
    )
  ''';
  
  static const String createTableDeliveries = '''
    CREATE TABLE $tableDeliveries (
      id TEXT PRIMARY KEY,
      trip_id TEXT NOT NULL,
      spbu_id TEXT NOT NULL,
      spbu_nama TEXT NOT NULL,
      urutan INTEGER NOT NULL,
      jam_berangkat TEXT,
      jam_tiba TEXT,
      jam_mulai_bongkar TEXT,
      jam_selesai_bongkar TEXT,
      latitude_tiba REAL,
      longitude_tiba REAL,
      status TEXT NOT NULL,
      is_lanjut INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      synced_at TEXT,
      FOREIGN KEY (trip_id) REFERENCES $tableTrips (id),
      FOREIGN KEY (spbu_id) REFERENCES $tableSPBU (id)
    )
  ''';
  
  static const String createTableSPBU = '''
    CREATE TABLE $tableSPBU (
      id TEXT PRIMARY KEY,
      nama TEXT NOT NULL,
      alamat TEXT,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      created_at TEXT NOT NULL
    )
  ''';
  
  static const String createTableSyncQueue = '''
    CREATE TABLE $tableSyncQueue (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      action TEXT NOT NULL,
      payload TEXT NOT NULL,
      retry_count INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      synced_at TEXT
    )
  ''';
  
  // Indexes
  static const String createIndexTripUserId = '''
    CREATE INDEX idx_trips_user_id ON $tableTrips (user_id)
  ''';
  
  static const String createIndexDeliveryTripId = '''
    CREATE INDEX idx_deliveries_trip_id ON $tableDeliveries (trip_id)
  ''';
  
  static const String createIndexSyncQueue = '''
    CREATE INDEX idx_sync_queue_synced ON $tableSyncQueue (synced_at)
  ''';
}