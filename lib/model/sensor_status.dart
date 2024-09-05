import 'package:flutter/material.dart';

enum SensorStatus {
  operating,
  alert;

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

  static SensorStatus? fromIndex(final int index) {
    switch (index) {
      case 0:
        return operating;
      case 1:
        return alert;
      default:
        return null;
    }
  }

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
}
