import 'package:flutter/material.dart';

enum NodeType {
  location,
  asset,
  component;

  static NodeType fromSensorType(final String? type) {
    if (type == null) return NodeType.asset;

    return NodeType.component;
  }

  Widget get icon {
    switch (this) {
      case location:
        return const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 24,
          semanticLabel: 'Location',
        );
      case asset:
        return const Icon(
          Icons.device_hub,
          color: Colors.blueGrey,
          size: 24,
          semanticLabel: 'Asset',
        );
      case component:
        return const Icon(
          Icons.device_unknown,
          color: Colors.grey,
          size: 24,
          semanticLabel: 'Component',
        );
    }
  }
}
