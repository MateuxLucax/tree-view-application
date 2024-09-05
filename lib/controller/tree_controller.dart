import 'package:flutter/foundation.dart';

import '../model/filter_params.dart';
import '../model/sensor_status.dart';
import '../model/sensor_type.dart';
import '../model/tree_index.dart';
import '../model/tree_node.dart';
import '../repository/tree_repository.dart';
import '../state/tree_state.dart';
import '../store/base_store.dart';

typedef FilterFunction = bool Function(TreeNode);

class TreeController extends BaseStore {
  final ITreeRepository repository = TractianApiTreeRepository();
  TreeState state = TreeLoading();
  final List<FilterFunction> _filters = <FilterFunction>[];
  TreeIndex index = TreeIndex();

  Future<void> filter(final FilterParams params) async {
    final TreeState state = this.state;
    if (state is! TreeLoaded) return Future<void>.value();

    this.state = TreeLoading();
    notifyListeners();

    final String query = params.query;
    final bool criticalStatus = params.criticalStatus;
    final bool energySensor = params.energySensor;

    if (query.isEmpty && !criticalStatus && !energySensor) {
      index.nodesById.forEach((final String key, final TreeNode node) {
        node
          ..isExpanded = false
          ..isFiltered = false;
      });
      this.state = TreeLoaded(
        root: state.root,
        filterParams: FilterParams.empty(),
      );
      notifyListeners();
      return;
    }

    index.nodesById.forEach((final String key, final TreeNode node) {
      node
        ..isExpanded = false
        ..isFiltered = true;
    });
    _filters.clear();
    if (query.isNotEmpty) {
      _filters.add(
        (final TreeNode node) => !node.name.toLowerCase().contains(
              query.toLowerCase(),
            ),
      );
    }

    if (criticalStatus) {
      _filters.add(
        (final TreeNode node) => node.status != SensorStatus.alert,
      );
    }

    if (energySensor) {
      _filters.add(
        (final TreeNode node) => node.sensorType != SensorType.energy,
      );
    }

    final (TreeIndex updatedIndex, TreeNode updatedRoot) = await compute(
      filterIndex,
      (index, _filters),
    );

    index = updatedIndex;

    this.state = TreeLoaded(
      root: updatedRoot,
      filterParams: params,
    );
    notifyListeners();
  }

  Future<void> loadAndBuildTree(final String companyId) async {
    try {
      final (TreeNode root, TreeIndex index) = await repository.fetchData(
        companyId,
      );

      state = TreeLoaded(
        root: root,
        filterParams: FilterParams.empty(),
      );
      this.index = index;
      notifyListeners();
    } catch (e) {
      state = TreeError(e.toString());
      notifyListeners();
    }
  }
}

Future<(TreeIndex, TreeNode)> filterIndex(
  final (TreeIndex, List<FilterFunction>) indexAndFilters,
) {
  final (TreeIndex index, List<FilterFunction> filters) = indexAndFilters;

  index.nodesById.forEach((final String key, final TreeNode node) {
    final bool shouldFilter = filters.every(
      (final FilterFunction filter) => filter(node),
    );

    if (shouldFilter && node.isFiltered) {
      return;
    }

    node
      ..isFiltered = false
      ..isExpanded = true;

    index.parentNodesOfId[node.id]?.forEach((final TreeNode node) {
      node
        ..isFiltered = false
        ..isExpanded = true;
    });
    // index.childrenNodesOfId[node.id]?.forEach((final TreeNode node) {
    //   node
    //     ..isFiltered = false
    //     ..isExpanded = true;

    //   TreeNode? currentChild = node;
    //   while (currentChild != null) {
    //     currentChild
    //       ..isFiltered = false
    //       ..isExpanded = false;
    //     currentChild = index.nodesById[currentChild.parentId];
    //   }
    // });
  });

  final TreeNode? root = index.nodesById['root'];

  if (root == null) {
    return Future<(TreeIndex, TreeNode)>.error(
      Exception('Root node not found'),
    );
  }

  return Future<(TreeIndex, TreeNode)>.value((index, root));
}
