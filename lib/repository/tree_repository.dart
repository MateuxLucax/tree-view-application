import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import '../model/asset.dart';
import '../model/location.dart';
import '../model/sensor_status.dart';
import '../model/sensor_type.dart';
import '../model/tree_index.dart';
import '../model/tree_node.dart';

abstract class ITreeRepository {
  Future<(TreeNode, TreeIndex)> fetchData(final String companyId);
}

class TractianApiTreeRepository implements ITreeRepository {
  final String baseUrl = 'https://fake-api.tractian.com';

  @override
  Future<(TreeNode, TreeIndex)> fetchData(final String companyId) async {
    final List<TreeNode> nodes = <TreeNode>[];
    final TreeIndex index = TreeIndex();

    final List<(List<TreeNode>, Index)> result = await Future.wait(
      <Future<(List<TreeNode>, Index)>>[
        _fetchLocations(companyId),
        _fetchAssets(companyId),
      ],
    );

    for (final (List<TreeNode> list, Index idx) in result) {
      nodes.addAll(list);
      index.nodesById.addAll(idx);
    }

    return await Isolate.run(() {
      final TreeNode root = TreeNode.root();
      index.nodesById[root.id] = root;

      for (final TreeNode node in nodes) {
        final TreeNode? parent = index.nodesById[node.parentId];

        if (node.sensorType == SensorType.energy) {
          index.energyNodes[node.id] = node;
        }

        if (node.status == SensorStatus.alert) {
          index.criticalNodes[node.id] = node;
        }

        if (parent == null) {
          root.children.add(node);
          index.childrenNodesOfId
              .putIfAbsent(root.id, () => <TreeNode>[])
              .add(node);
          index.parentNodesOfId
              .putIfAbsent(node.id, () => <TreeNode>[])
              .add(root);
          continue;
        }

        parent.addChild(node);
        index.childrenNodesOfId
            .putIfAbsent(parent.id, () => <TreeNode>[])
            .add(node);

        TreeNode? currentParent = parent;

        while (currentParent != null) {
          index.parentNodesOfId
              .putIfAbsent(node.id, () => <TreeNode>[])
              .add(currentParent);
          currentParent = index.nodesById[currentParent.parentId];
        }
      }

      return (root, index);
    });
  }

  Future<(List<TreeNode>, Index)> _fetchLocations(
    final String companyId,
  ) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/locations'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load locations');
    }

    return Isolate.run(() {
      final List<TreeNode> nodes = <TreeNode>[];
      final Index index = <String, TreeNode>{};

      final List<dynamic> jsonResponse = json.decode(response.body);

      for (final dynamic json in jsonResponse) {
        final Location location = Location.fromJson(json);

        final TreeNode node = TreeNode.fromLocation(location);

        nodes.add(node);
        index[location.id] = node;
      }

      return (nodes, index);
    });
  }

  Future<(List<TreeNode>, Index)> _fetchAssets(final String companyId) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/assets'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load assets');
    }

    return await Isolate.run(() {
      final List<TreeNode> nodes = <TreeNode>[];
      final Index index = <String, TreeNode>{};

      final List<dynamic> jsonResponse = json.decode(response.body);

      for (final dynamic json in jsonResponse) {
        final Asset asset = Asset.fromJson(json);

        final TreeNode node = TreeNode.fromAsset(asset);

        nodes.add(node);
        index[asset.id] = node;
      }

      return (nodes, index);
    });
  }
}
