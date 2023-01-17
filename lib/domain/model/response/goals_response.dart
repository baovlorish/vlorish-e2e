import 'package:burgundy_budgeting_app/ui/model/goal.dart';

/// goals : [{"fundedAmount":70145519,"note":"occaecat anim ut magna","targetAmount":-42578814,"isArchived":true,"targetDate":"1950-05-03T20:04:16.951Z","name":"in","id":"4fffa5e7-7d9c-91be-d414-b3938d523b88","iconUrl":"adipisicing enim quis incididun","totalFundedAmount":-61599784,"startDate":"1982-11-17T11:58:26.266Z"},{"fundedAmount":-78145357,"note":"minim laborum","targetAmount":-14480179,"isArchived":false,"targetDate":"2001-06-14T14:56:58.063Z","name":"laboris Ut anim","id":"urn:uuid:66c5e509-f6bf-4a0a-e09b-82e63444736c","iconUrl":"consectetur velit","totalFundedAmount":-52063358,"startDate":"1989-03-22T22:58:10.032Z"}]

class GoalsResponse {
  List<Goal>? _goals;

  List<Goal>? get goals => _goals;

  GoalsResponse({List<Goal>? goals}) {
    _goals = goals;
  }

  GoalsResponse.fromJson(dynamic json) {
    if (json['goals'] != null) {
      _goals = [];
      var number = 0;
      json['goals'].forEach((v) {
        _goals?.add(Goal.fromMap(v, number));
        number++;
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_goals != null) {
      map['goals'] = _goals?.map((v) => v.toMap()).toList();
    }
    return map;
  }
}

/// fundedAmount : 70145519
/// note : "occaecat anim ut magna"
/// targetAmount : -42578814
/// isArchived : true
/// targetDate : "1950-05-03T20:04:16.951Z"
/// name : "in"
/// id : "4fffa5e7-7d9c-91be-d414-b3938d523b88"
/// iconUrl : "adipisicing enim quis incididun"
/// totalFundedAmount : -61599784
/// startDate : "1982-11-17T11:58:26.266Z"

class Goals {
  int? _fundedAmount;
  String? _note;
  int? _targetAmount;
  bool? _isArchived;
  String? _targetDate;
  String? _name;
  String? _id;
  String? _iconUrl;
  int? _totalFundedAmount;
  String? _startDate;

  int? get fundedAmount => _fundedAmount;
  String? get note => _note;
  int? get targetAmount => _targetAmount;
  bool? get isArchived => _isArchived;
  String? get targetDate => _targetDate;
  String? get name => _name;
  String? get id => _id;
  String? get iconUrl => _iconUrl;
  int? get totalFundedAmount => _totalFundedAmount;
  String? get startDate => _startDate;

  Goals(
      {int? fundedAmount,
      String? note,
      int? targetAmount,
      bool? isArchived,
      String? targetDate,
      String? name,
      String? id,
      String? iconUrl,
      int? totalFundedAmount,
      String? startDate}) {
    _fundedAmount = fundedAmount;
    _note = note;
    _targetAmount = targetAmount;
    _isArchived = isArchived;
    _targetDate = targetDate;
    _name = name;
    _id = id;
    _iconUrl = iconUrl;
    _totalFundedAmount = totalFundedAmount;
    _startDate = startDate;
  }

  Goals.fromJson(dynamic json) {
    _fundedAmount = json['fundedAmount'];
    _note = json['note'];
    _targetAmount = json['targetAmount'];
    _isArchived = json['isArchived'];
    _targetDate = json['targetDate'];
    _name = json['name'];
    _id = json['id'];
    _iconUrl = json['iconUrl'];
    _totalFundedAmount = json['totalFundedAmount'];
    _startDate = json['startDate'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['fundedAmount'] = _fundedAmount;
    map['note'] = _note;
    map['targetAmount'] = _targetAmount;
    map['isArchived'] = _isArchived;
    map['targetDate'] = _targetDate;
    map['name'] = _name;
    map['id'] = _id;
    map['iconUrl'] = _iconUrl;
    map['totalFundedAmount'] = _totalFundedAmount;
    map['startDate'] = _startDate;
    return map;
  }
}
