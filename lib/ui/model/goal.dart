import 'dart:ui';

import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/utils/get_stats_color.dart';
import 'package:flutter/material.dart';

class Goal with Comparable, GetStatsColor {
  final String id;
  final String goalName;

  final int target;
  final DateTime endDate;
  final int funded;
  final int totalFunded;
  final DateTime startDate;
  final String? note;
  final int number;
  final bool isArchived;
  final String? iconUrl;

  late final Color color;
  late final int progress;

  Goal({
    required this.id,
    required this.goalName,
    required this.note,
    required this.funded,
    required this.totalFunded,
    required this.target,
    required this.startDate,
    required this.endDate,
    required this.number,
    required this.isArchived,
    this.iconUrl,
  }) {
    progress = (totalFunded * 100) ~/ target;

    color = mapColor(number);
  }

  factory Goal.fromMap(Map<String, dynamic> map, int number) {
    return Goal(
      id: map['id'] as String,
      goalName: map['name'] as String,
      note: map['note']  as String ?   ,
      funded: map['fundedAmount'] as int,
      totalFunded: map['totalFundedAmount'] as int,
      target: map['targetAmount'] as int,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['targetDate']),
      isArchived: map['isArchived'] as bool,
      iconUrl: map['iconUrl'] as String?,
      number: number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalName': goalName,
      'note': note,
      'funded': funded,
      'totalFundedAmount': totalFunded,
      'targetAmount': target,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  @override
  int compareTo(other) {
    if (progress > other.progress) return 1;
    if (progress < other.progress) return -1;
    return 0;
  }

  static List<StatisticModel> mapToStatisticModel(List<Goal> goals) {
    var models = <StatisticModel>[];
    goals.sort();
    goals.forEach((goal) {
      models.add(StatisticModel.fromGoal(goal));
    });

    return models;
  }
}
