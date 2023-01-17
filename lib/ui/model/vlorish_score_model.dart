class VlorishScoreModel {
  int? totalVlorishScore;
  List<VlorishScoreComponents>? vlorishScoreComponents;

  VlorishScoreModel(
      {required this.totalVlorishScore, required this.vlorishScoreComponents});

  VlorishScoreModel.fromJson(Map<String, dynamic> json) {
    totalVlorishScore = json['totalVlorishScore'];
    if (json['vlorishScoreComponents'] != null) {
      vlorishScoreComponents = <VlorishScoreComponents>[];
      json['vlorishScoreComponents'].forEach((v) {
        vlorishScoreComponents!.add(VlorishScoreComponents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalVlorishScore'] = totalVlorishScore;
    if (vlorishScoreComponents != null) {
      data['vlorishScoreComponents'] =
          vlorishScoreComponents!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'VlorishScoreModel{totalVlorishScore: $totalVlorishScore, vlorishScoreComponents: $vlorishScoreComponents}';
  }
}

class VlorishScoreComponents {
  late final int? score;
  late final double? nextStarNeeded;
  late final int? profileCategory;

  VlorishScoreComponents(
      {required this.score,
      required this.nextStarNeeded,
      required this.profileCategory});

  VlorishScoreComponents.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    nextStarNeeded = json['nextStarNeeded'];
    profileCategory = json['profileCategory'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['score'] = score;
    data['nextStarNeeded'] = nextStarNeeded;
    data['profileCategory'] = profileCategory;
    return data;
  }

  @override
  String toString() {
    return 'VlorishScoreComponents{score: $score, nextStarNeeded: $nextStarNeeded, profileCategory: $profileCategory}';
  }
}
