import 'sensor_status.dart';
import 'sensor_type.dart';
import 'tree_node.dart';

class ReverseIndex {
  final Map<String, int> idIndex = <String, int>{};
  // Can be optimized with a stemming algorithm (RSLP https://www.inf.ufrgs.br/~viviane/rslp/index.htm (I have one made in JS))
  final Map<String, List<int>> nameIndex = <String, List<int>>{};
  final Map<SensorType, List<int>> sensorTypeIndex = <SensorType, List<int>>{};
  final Map<SensorStatus, List<int>> statusIndex = <SensorStatus, List<int>>{};
  final List<TreeNode> allNodes = <TreeNode>[];

  void clear() {
    idIndex.clear();
    nameIndex.clear();
    sensorTypeIndex.clear();
    statusIndex.clear();
    allNodes.clear();
  }

  void addToIndex(
    final TreeNode node,
    final int index,
  ) {
    allNodes.add(node);
    idIndex.putIfAbsent(node.id, () => index);
    nameIndex.putIfAbsent(node.name, () => <int>[]).add(index);

    final SensorType? sensorType = node.sensorType;
    if (sensorType != null) {
      sensorTypeIndex.putIfAbsent(sensorType, () => <int>[]).add(index);
    }

    final SensorStatus? status = node.status;
    if (status != null) {
      statusIndex.putIfAbsent(status, () => <int>[]).add(index);
    }
  }

  List<int> searchByName(
    final String name,
  ) =>
      nameIndex[name] ?? <int>[];

  List<int> searchBySensorType(
    final SensorType sensorType,
  ) =>
      sensorTypeIndex[sensorType] ?? <int>[];

  List<int> searchByStatus(
    final SensorStatus status,
  ) =>
      statusIndex[status] ?? <int>[];

  List<TreeNode> getNodes(
    final List<int> indices,
  ) =>
      indices.map((final int index) => allNodes[index]).toList();

  TreeNode? findNodeById(
    final String? id,
  ) {
    final int? index = idIndex[id];
    if (index == null) return null;

    return allNodes[index];
  }

  int get lastIndex => allNodes.isEmpty ? 0 : allNodes.length - 1;
}
