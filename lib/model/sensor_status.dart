import 'package:flutter/material.dart';

enum SensorStatus {
  operating,
  alert;

  Widget get icon {
    switch (this) {
      case operating:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 24,
          semanticLabel: 'Operating',
        );
      case alert:
        return const Icon(
          Icons.warning,
          color: Colors.orange,
          size: 24,
          semanticLabel: 'Alert',
        );
    }
  }

  static SensorStatus? fromString(final String? status) {
    switch (status) {
      case 'operating':
        return operating;
      case 'alert':
        return alert;
      default:
        return null;
    }
  }
}
