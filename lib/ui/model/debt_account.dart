import 'package:burgundy_budgeting_app/ui/model/period.dart';

import 'debt_node.dart';

class DebtAccount {
  final List<DebtNode> nodes;
  final bool isManual;
  final String name;
  final String id;

  const DebtAccount({
    required this.nodes,
    required this.isManual,
    required this.name,
    required this.id,
  });

  factory DebtAccount.fromJson(Map<String, dynamic> json, Period period) {
    var nodes = <DebtNode>[];
    bool isManual = json['isManual'];
    if (json['nodes'] != null) {
      json['nodes'].forEach((v) {
        nodes.add(DebtNode.fromJson(v, isManual));
      });
      for (var month in period.months) {
        if (!(nodes.any((element) =>
            element.monthYear.year == month.year &&
            element.monthYear.month == month.month))) {
          nodes.add(DebtNode(
            totalAmount: 0,
            interestAmount: 0,
            debtAmount: 0,
            monthYear: month,
            isManual: isManual,
          ));
        }
      }
      nodes.sort((a, b) => (a.monthYear).compareTo(b.monthYear));
    }

    if (nodes.length > period.months.length) {
      var correctedNodes = <DebtNode>[];
      for (var month in period.months) {
        correctedNodes
            .add(nodes.firstWhere((element) => element.monthYear == month));
      }
      nodes = correctedNodes;
    }

    return DebtAccount(
      isManual: json['isManual'],
      name: json['name'],
      id: json['id'],
      nodes: nodes,
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
      other is DebtAccount &&
          runtimeType == other.runtimeType &&
          nodes == other.nodes &&
          isManual == other.isManual &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode =>
      nodes.hashCode ^ isManual.hashCode ^ name.hashCode ^ id.hashCode;
}
