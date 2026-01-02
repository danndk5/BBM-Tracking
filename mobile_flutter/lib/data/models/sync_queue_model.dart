// lib/data/models/sync_queue_model.dart

class SyncQueueModel {
  final int? id;
  final String entityType; // 'trip', 'delivery'
  final String entityId;
  final String action; // 'create', 'update'
  final String payload; // JSON string
  final int retryCount;
  final String createdAt;
  final String? syncedAt;

  const SyncQueueModel({
    this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.payload,
    this.retryCount = 0,
    required this.createdAt,
    this.syncedAt,
  });

  // From Database (SQLite)
  factory SyncQueueModel.fromDatabase(Map<String, dynamic> map) {
    return SyncQueueModel(
      id: map['id'] as int?,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      action: map['action'] as String,
      payload: map['payload'] as String,
      retryCount: map['retry_count'] as int? ?? 0,
      createdAt: map['created_at'] as String,
      syncedAt: map['synced_at'] as String?,
    );
  }

  // To Database (SQLite)
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'action': action,
      'payload': payload,
      'retry_count': retryCount,
      'created_at': createdAt,
      'synced_at': syncedAt,
    };
  }

  // Copy with
  SyncQueueModel copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? action,
    String? payload,
    int? retryCount,
    String? createdAt,
    String? syncedAt,
  }) {
    return SyncQueueModel(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  // Check if synced
  bool get isSynced => syncedAt != null;

  // Check if should retry
  bool get shouldRetry => retryCount < 3 && !isSynced;
}