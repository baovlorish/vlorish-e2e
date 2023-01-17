/// name : "ut in"
/// targetAmount : 23813068
/// targetDate : "1978-03-10T03:15:11.709Z"
/// fundedAmount : 51941725
/// note : "ex nulla minim adipisicing"
/// icon : "commodo ullamco fugiat deserunt"
/// startDate : "1995-05-05T17:14:07.722Z"
// TODO: fix avatar uploading
class PostAddGoalRequest {
  final String? id;
  final String name;
  final int targetAmount;
  final String targetDate;
  final int? fundedAmount;
  final String? note;
  final String? icon;
  final String? startDate;

  PostAddGoalRequest({
    required this.name,
    required this.targetAmount,
    required this.targetDate,
    this.fundedAmount,
    this.note,
    this.startDate,
    this.icon,
    this.id,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['targetAmount'] = targetAmount;
    map['targetDate'] = targetDate;
    map['fundedAmount'] = fundedAmount;
    map['startDate'] = startDate;
    if (note != null) {
      map['note'] = note;
    }
    if (icon != null) {
      map['icon'] = icon;
    }
    if (id != null) {
      map['goalId'] = id;
    }
    return map;
  }
}
