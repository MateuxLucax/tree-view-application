import 'package:flutter/material.dart';

enum NodeType {
  root,
  location,
  asset,
  component;

  static NodeType fromString(final String? type) {
    if (type == null) return NodeType.asset;

    return NodeType.component;
  }

  static NodeType fromIndex(final int index) {
    switch (index) {
      case 0:
        return NodeType.root;
      case 1:
        return NodeType.location;
      case 2:
        return NodeType.asset;
      case 3:
        return NodeType.component;
      default:
        return NodeType.component;
    }
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
      case root:
        return const Placeholder();
    }
  }

  int compareTo(final NodeType other) => index.compareTo(other.index);
}
