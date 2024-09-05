import '../model/filter_params.dart';
import '../model/tree_node.dart';

sealed class TreeState {}

class TreeLoading extends TreeState {}

class TreeLoaded extends TreeState {
  TreeLoaded({
    required this.root,
    required this.filterParams,
  });

  final TreeNode root;
  final FilterParams filterParams;
}

class TreeError extends TreeState {
  TreeError(this.message);

  final String message;
}
