/// accountType : 22442557
/// name : "anim s"
/// usageType : -58204606
/// businessName : "string"

class AddManualAccountRequest {
  int? _accountType;
  String? _name;
  int? _usageType;
  String? _businessName;

  int? get accountType => _accountType;
  String? get name => _name;
  int? get usageType => _usageType;
  String? get businessName => _businessName;

  bool get isPersonalType => _usageType == 1;
  AddManualAccountRequest({
    int? accountType,
    String? name,
    int? usageType,
    String? businessName,
  }) {
    _accountType = accountType;
    _name = name;
    _usageType = usageType;
    _businessName = businessName;
  }

  AddManualAccountRequest.fromJson(dynamic json) {
    _accountType = json['accountType'];
    _name = json['name'];
    _usageType = json['usageType'];
    _businessName = json['businessName'];
  }

  Map<String, dynamic> toJson() {
    var mappedType = 0;

    if (usageType == 1) {
      switch (_accountType) {
        case 0: // Credit card(D)
          mappedType = 2;
          break;
        case 1: // Student loan(D)
          mappedType = 4;
          break;
        case 2: // Auto loan(D)
          mappedType = 5;
          break;
        case 3: // Personal loan(D)
          mappedType = 6;
          break;
        case 4: // Mortgage loan(D)
          mappedType = 7;
          break;
        case 5: // Investment(A)
          mappedType = 8;
          break;
        case 6: // Retirement account(A)
          mappedType = 9;
          break;
        case 7: // Primary home(A)
          mappedType = 11;
          break;
        case 8: // Vehicle(A)
          mappedType = 12;
          break;
        case 9: // Back taxes(D)
          mappedType = 14;
          break;
        case 10: // Medical bills(D)
          mappedType = 15;
          break;
        case 11: // Other asset(A)
          mappedType = 13;
          break;
        case 12: // Alimony(D)
          mappedType = 16;
          break;
        case 13: // Other debt(D)
          mappedType = 17;
          break;
      }
    } else if (usageType == 2) {
      switch (_accountType) {
        case 0: // Credit card(D)
          mappedType = 2;
          break;
        case 1: // Business loan(D)
          mappedType = 3;
          break;
        case 2: // Auto loan(D)
          mappedType = 5;
          break;
        case 3: // Business assets(A)
          mappedType = 10;
          break;
      }
    }

    var map = <String, dynamic>{};
    map['accountType'] = mappedType;
    map['name'] = _name;
    map['usageType'] = _usageType;
    map['businessName'] = businessName;
    return map;
  }
}
