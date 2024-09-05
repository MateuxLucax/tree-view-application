import 'tree_node.dart';

typedef Index = Map<String, TreeNode>;
typedef ListIndex = Map<String, List<TreeNode>>;

class TreeIndex {
  final Index nodesById = <String, TreeNode>{};
  final ListIndex parentNodesOfId = <String, List<TreeNode>>{};
  final ListIndex childrenNodesOfId = <String, List<TreeNode>>{};
  final Index criticalNodes = <String, TreeNode>{};
  final Index energyNodes = <String, TreeNode>{};
}
