import 'sensor_status.dart';
import 'sensor_type.dart';
import 'tree_node.dart';

class ReverseIndex {
  final Map<String, int> idIndex = <String, int>{};

  // Can be optimized with a stemming algorithm (RSLP https://www.inf.ufrgs.br/~viviane/rslp/index.htm (I have one made in JS))
  final Map<String, List<int>> nameIndex = <String, List<int>>{};
  final List<int> energySensors = <int>[];
  final List<int> criticalSensors = <int>[];
  final List<TreeNode> allNodes = <TreeNode>[];

  void clear() {
    idIndex.clear();
    nameIndex.clear();
    energySensors.clear();
    criticalSensors.clear();
    allNodes.clear();
  }

  void addToIndex(
    final TreeNode node,
    final int index,
  ) {
    allNodes.add(node);
    idIndex.putIfAbsent(node.id, () => index);
    nameIndex.putIfAbsent(node.name.toLowerCase(), () => <int>[]).add(index);

    final SensorType? sensorType = node.sensorType;
    if (sensorType != null && sensorType == SensorType.energy) {
      energySensors.add(index);
    }

    final SensorStatus? status = node.status;
    if (status != null && status == SensorStatus.alert) {
      criticalSensors.add(index);
    }
  }

  List<int> searchByName(
    final String name,
  ) =>
      nameIndex[name.toLowerCase()] ?? <int>[];

  List<int> get energySensorIndices => energySensors;

  List<int> get criticalSensorIndices => criticalSensors;

  Iterable<TreeNode> getNodes(
    final Iterable<int> indices,
  ) =>
      indices.map((final int index) => allNodes[index]);

  Iterable<TreeNode> rootFromIndices(
    final Iterable<int> indices,
  ) {
    final Set<TreeNode> roots = <TreeNode>{};

    for (final int index in indices) {
      final TreeNode node = allNodes[index]..isExpanded = true;
      TreeNode? currentNode = node;

      while (currentNode != null) {
        currentNode.isExpanded = true;
        if (currentNode.parent == null) {
          roots.add(currentNode);
          break;
        }
        currentNode = currentNode.parent;
      }
    }

    return roots;
  }

  TreeNode? findNodeById(
    final String? id,
  ) {
    final int? index = idIndex[id];
    if (index == null) return null;

    return allNodes[index];
  }

  int get lastIndex => allNodes.length;

  Iterable<TreeNode> get rootNodes => allNodes.where(
        (final TreeNode node) => node.parent == null,
      );
}
