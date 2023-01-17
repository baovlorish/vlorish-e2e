import 'package:burgundy_budgeting_app/ui/model/net_worth_node.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';

class NetWorthCategory {
  final List<NetWorthNode> nodes;
  final bool isManual;
  final bool canEdit;
  final String name;
  final String id;
  final Period period;

  const NetWorthCategory({
    required this.nodes,
    required this.isManual,
    required this.canEdit,
    required this.name,
    required this.id,
    required this.period,
  });

  factory NetWorthCategory.fromJson(Map<String, dynamic> json, Period period) {
    var nodes = <NetWorthNode>[];

    if (json['nodes'] != null && (json['nodes'] as List).isNotEmpty) {
      json['nodes'].forEach((v) {
        nodes.add(NetWorthNode.fromJson(v));
      });
    }

    for (var month in period.months) {
      if (!(nodes.any((element) =>
          element.monthYear.year == month.year &&
          element.monthYear.month == month.month))) {
        nodes.add(NetWorthNode(
          amount: 0,
          monthYear: month,
        ));
      }
    }
    nodes.sort((a, b) => (a.monthYear).compareTo(b.monthYear));

    if (nodes.length > period.months.length) {
      var correctedNodes = <NetWorthNode>[];
      for (var month in period.months) {
        correctedNodes
            .add(nodes.firstWhere((element) => element.monthYear == month));
      }
      nodes = correctedNodes;
    }

    return NetWorthCategory(
      isManual: json['isManual'],
      canEdit: json['canEdit'],
      name: json['name'],
      id: json['id'],
      nodes: nodes,
      period: period,
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['nodes'] = nodes.map((v) => v.toJson()).toList();
    map['isManual'] = isManual;
    map['name'] = name;
    map['id'] = id;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetWorthCategory &&
          runtimeType == other.runtimeType &&
          nodes == other.nodes &&
          isManual == other.isManual &&
          canEdit == other.canEdit &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode =>
      nodes.hashCode ^
      isManual.hashCode ^
      canEdit.hashCode ^
      name.hashCode ^
      id.hashCode;
}
