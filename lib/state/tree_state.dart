import '../model/tree_node.dart';

sealed class TreeState {}

class TreeLoading extends TreeState {}

class TreeLoaded extends TreeState {
  TreeLoaded(this.tree);

  final Iterable<TreeNode> tree;
}

class TreeError extends TreeState {
  TreeError(this.message);

  final String message;
}
