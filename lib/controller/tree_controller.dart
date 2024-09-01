import '../model/asset.dart';
import '../model/location.dart';
import '../model/node_type.dart';
import '../model/reverse_index.dart';
import '../model/sensor_status.dart';
import '../model/sensor_type.dart';
import '../model/tree_node.dart';
import '../repository/tree_repository.dart';
import '../state/tree_state.dart';
import '../store/base_store.dart';

class TreeController extends BaseStore {
  final ReverseIndex reverseIndex = ReverseIndex();
  final ITreeRepository repository = TractianApiTreeRepository();
  TreeState state = TreeLoading();

  void buildTreeAndIndex(
    final List<Location> locations,
    final List<Asset> assets,
  ) {
    reverseIndex.clear();
    locations.sort((final Location a, final Location b) {
      if (a.parentId == null && b.parentId != null) return -1;
      if (a.parentId != null && b.parentId == null) return 1;

      return a.id.compareTo(b.id);
    });

    for (final Location location in locations) {
      final TreeNode node = TreeNode(
        id: location.id,
        name: location.name,
        type: NodeType.location,
        parent: reverseIndex.findNodeById(location.parentId),
      );

      node.parent?.children.add(node);
      reverseIndex.addToIndex(node, reverseIndex.lastIndex);
    }

    assets.sort((final Asset a, final Asset b) {
      if (a.parentId == null && b.parentId != null) return -1;
      if (a.parentId != null && b.parentId == null) return 1;

      return a.id.compareTo(b.id);
    });

    for (final Asset asset in assets) {
      final NodeType type = NodeType.fromSensorType(asset.sensorType);
      final SensorType? sensorType = SensorType.fromString(asset.sensorType);
      final SensorStatus? status = SensorStatus.fromString(asset.status);

      final TreeNode node = TreeNode(
        id: asset.id,
        name: asset.name,
        type: type,
        parent: reverseIndex.findNodeById(asset.parentId) ??
            reverseIndex.findNodeById(asset.locationId),
        sensorType: sensorType,
        status: status,
      );

      node.parent?.children.add(node);
      reverseIndex.addToIndex(node, reverseIndex.lastIndex);
    }

    nodesToTree(
      reverseIndex.rootNodes,
    );
  }

  void searchAndFilterTree(
    final String query, {
    required final bool energySensor,
    required final bool criticalStatus,
  }) {
    if (query.isEmpty && !energySensor && !criticalStatus) {
      nodesToTree(
        reverseIndex.rootNodes.map(
          (final TreeNode node) {
            node.isExpanded = false;
            return node;
          },
        ),
      );
      return;
    }

    final Set<int> matchingIndices = <int>{};

    if (query.isNotEmpty) {
      matchingIndices.addAll(reverseIndex.searchByName(query));
    } else if (energySensor) {
      matchingIndices.addAll(reverseIndex.energySensorIndices);
    } else if (criticalStatus) {
      matchingIndices.addAll(reverseIndex.criticalSensors);
    }

    final Iterable<TreeNode> matchingNodes = reverseIndex.rootFromIndices(
      matchingIndices,
    );

    nodesToTree(matchingNodes);
  }

  void nodesToTree(final Iterable<TreeNode> nodes) {
    final Set<TreeNode> resultNodes = <TreeNode>{};
    for (final TreeNode node in nodes) {
      resultNodes.add(node);
      TreeNode? currentNode = node.parent;
      while (currentNode != null) {
        resultNodes.add(currentNode);
        currentNode = currentNode.parent;
      }
    }

    state = TreeLoaded(resultNodes.toList());
    notifyListeners();
  }

  Future<void> loadAndBuildTree(final String companyId) async {
    try {
      final List<Location> locations = await repository.fetchLocations(
        companyId,
      );
      final List<Asset> assets = await repository.fetchAssets(companyId);

      buildTreeAndIndex(locations, assets);
    } catch (e) {
      state = TreeError(e.toString());
      notifyListeners();
    }
  }
}
