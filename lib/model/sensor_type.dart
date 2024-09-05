import 'package:flutter/material.dart';

enum SensorType {
  energy,
  vibration;

  static SensorType? fromString(final String? type) {
    switch (type) {
      case 'energy':
        return energy;
      case 'vibration':
        return vibration;
      default:
        return null;
    }
  }

  static SensorType? fromIndex(final int index) {
    switch (index) {
      case 0:
        return energy;
      case 1:
        return vibration;
      default:
        return null;
    }
  }

  Widget get icon {
    switch (this) {
      case energy:
        return const Icon(
          Icons.bolt,
          color: Colors.yellow,
          size: 24,
          semanticLabel: 'Energy',
        );
      case vibration:
        return const Icon(
          Icons.vibration,
          color: Colors.blue,
          size: 24,
          semanticLabel: 'Vibration',
        );
    }
  }
}
