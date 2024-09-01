import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/tree_controller.dart';
import '../model/company.dart';
import '../state/tree_state.dart';
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
        TreeLoaded() => ListView(
            children: state.tree.map<Widget>(TreeNodeWidget.new).toList(),
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
