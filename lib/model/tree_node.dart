import 'asset.dart';
import 'location.dart';
import 'node_type.dart';
import 'sensor_status.dart';
import 'sensor_type.dart';

class TreeNode {
  TreeNode({
    required this.id,
    required this.name,
    required this.type,
    this.parent,
    this.parentId,
    this.sensorType,
    this.status,
    this.isExpanded = false,
    this.isFiltered = false,
    final List<TreeNode>? children,
  }) : children = children ?? <TreeNode>[];

  factory TreeNode.root() => TreeNode(
        id: 'root',
        name: 'root',
        type: NodeType.root,
      );

  factory TreeNode.fromLocation(final Location location) => TreeNode(
        id: location.id,
        name: location.name,
        type: NodeType.location,
        parentId: location.parentId,
      );

  factory TreeNode.fromAsset(final Asset asset) => TreeNode(
        id: asset.id,
        name: asset.name,
        type: NodeType.fromString(asset.sensorType),
        sensorType: SensorType.fromString(asset.sensorType),
        status: SensorStatus.fromString(asset.status),
        parentId: asset.parentId ?? asset.locationId,
      );

  final String id;
  final String name;
  final List<TreeNode> children;
  final NodeType type;
  SensorType? sensorType;
  SensorStatus? status;
  TreeNode? parent;
  bool isExpanded = false;
  String? parentId;
  bool isFiltered;

  TreeNode copyWith() {
    final TreeNode copiedNode = TreeNode(
      id: id,
      name: name,
      type: type,
      sensorType: sensorType,
      status: status,
      isExpanded: isExpanded,
    );

    copiedNode.children.addAll(
      children.map(
        (final TreeNode child) => child
          ..copyWith()
          ..parent = copiedNode,
      ),
    );

    return copiedNode;
  }

  void addChild(final TreeNode node) {
    children.add(node);
    node.parent = this;
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is TreeNode && runtimeType == other.runtimeType;

  @override
  int get hashCode => id.hashCode;
}
