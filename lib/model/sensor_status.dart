import 'package:flutter/material.dart';

enum SensorStatus {
  operating,
  alert,
  critical;

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
      case critical:
        return const Icon(
          Icons.error,
          color: Colors.red,
          size: 24,
          semanticLabel: 'Critical',
        );
    }
  }

  static SensorStatus? fromString(final String? status) {
    switch (status) {
      case 'operating':
        return operating;
      case 'alert':
        return alert;
      case 'critical':
        return critical;
      default:
        return null;
    }
  }
}
