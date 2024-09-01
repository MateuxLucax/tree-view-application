import 'package:flutter/material.dart';

import '../model/sensor_status.dart';
import '../model/sensor_type.dart';
import '../model/tree_node.dart';

class TreeNodeWidget extends StatefulWidget {
  const TreeNodeWidget(this.node, {super.key});

  final TreeNode node;

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  @override
  Widget build(final BuildContext context) {
    final TreeNode node = widget.node;
    final SensorType? sensorType = node.sensorType;
    final SensorStatus? status = node.status;
    final bool hasParent = node.parent != null;
    final bool hasChildren = node.children.isNotEmpty;

    final ListTile header = ListTile(
      title: Row(
        children: <Widget>[
          if (hasParent) const Icon(Icons.subdirectory_arrow_right),
          if (hasParent) const SizedBox(width: 8),
          node.type.icon,
          const SizedBox(width: 8),
          if (sensorType != null) sensorType.icon,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              node.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (status != null) status.icon,
          if (hasChildren) const SizedBox(width: 8),
          if (hasChildren)
            Icon(
              node.isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
        ],
      ),
      onTap: () {
        if (!hasChildren) return;

        setState(() {
          node.isExpanded = !node.isExpanded;
        });
      },
    );

    if (!node.isExpanded) {
      return header;
    }

    return Column(
      children: <Widget>[
        header,
        ...node.children.map<Widget>(
          (final TreeNode node) => Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TreeNodeWidget(node),
          ),
        ),
      ],
    );
  }
}
