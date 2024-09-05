import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/tree_controller.dart';
import '../model/company.dart';
import '../model/tree_node.dart';
import '../state/tree_state.dart';
import '../widgets/search_panel_widget.dart';
import '../widgets/tree_node_widget.dart';

class TreePage extends StatefulWidget {
  const TreePage({
    required this.company,
    super.key,
  });

  final Company company;

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  final TreeController controller = TreeController();

  void handleStateChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    unawaited(controller.loadAndBuildTree(widget.company.id));
    controller.addListener(handleStateChange);
  }

  @override
  void dispose() {
    controller.removeListener(handleStateChange);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final TreeState state = controller.state;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company.name),
      ),
      body: switch (state) {
        TreeLoaded() => Column(
            children: <Widget>[
              SearchPanelWidget(
                onSearch: controller.filter,
                filterParams: state.filterParams,
              ),
              const Divider(),
              if (state.root.children.every(
                (final TreeNode node) => node.isFiltered,
              ))
                const Center(
                  child: Text('No results found'),
                )
              else
                Expanded(
                  child: ListView(
                    children: state.root.children
                        .where((final TreeNode node) => !node.isFiltered)
                        .map<Widget>(TreeNodeWidget.new)
                        .toList(),
                  ),
                ),
            ],
          ),
        TreeError() => Column(
            children: <Widget>[
              Text(state.message),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async => controller.loadAndBuildTree(
                  widget.company.id,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        _ => const Center(
            child: CircularProgressIndicator(),
          ),
      },
    );
  }
}
