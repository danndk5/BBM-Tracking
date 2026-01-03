// lib/presentation/widgets/status_timeline.dart

import 'package:flutter/material.dart';
import 'package:mobile_flutter/core/utils/timestamp_helper.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';

class StatusTimeline extends StatelessWidget {
  final Delivery delivery;

  const StatusTimeline({
    super.key,
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Pengiriman',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Berangkat',
              delivery.jamBerangkat,
              true,
            ),
            _buildTimelineItem(
              'Tiba di SPBU',
              delivery.jamTiba,
              delivery.jamBerangkat != null,
            ),
            _buildTimelineItem(
              'Mulai Bongkar',
              delivery.jamMulaiBongkar,
              delivery.jamTiba != null,
            ),
            _buildTimelineItem(
              'Selesai Bongkar',
              delivery.jamSelesaiBongkar,
              delivery.jamMulaiBongkar != null,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String? timestamp,
    bool isActive, {
    bool isLast = false,
  }) {
    final isDone = timestamp != null;
    final color = isDone ? Colors.green : (isActive ? Colors.blue : Colors.grey);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : Colors.white,
                border: Border.all(color: color, width: 2),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                  color: isDone ? Colors.black : Colors.grey,
                ),
              ),
              if (isDone) ...[
                const SizedBox(height: 4),
                Text(
                  TimestampHelper.formatDisplay(timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
              if (!isLast) const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}