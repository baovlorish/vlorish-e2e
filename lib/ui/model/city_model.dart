class CityModel {
  final String cityName;
  final String stateCode;

  @override
  String toString() => cityName + ', ' + stateCode;

  CityModel(this.cityName, this.stateCode);

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      map['cityName'] as String,
      map['stateCode'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'stateCode': stateCode,
    };
  }

  static String? getStateCode(String state) {
    if (stateCodesMap.containsValue(state)) {
      return state;
    } else {
      return stateCodesMap[state];
    }
  }

  static const stateCodesMap = {
    'Alaska': 'AK',
    'Alabama': 'AL',
    'Arkansas': 'AR',
    'Arizona': 'AZ',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'WashingtonDC': 'DC',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Iowa': 'IA',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Massachusetts': 'MA',
    'Maryland': 'MD',
    'Maine': 'ME',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Missouri': 'MO',
    'Mississippi': 'MS',
    'Montana': 'MT',
    'NorthCarolina': 'NC',
    'NorthDakota': 'ND',
    'Nebraska': 'NE',
    'NewHampshire': 'NH',
    'NewJersey': 'NJ',
    'NewMexico': 'NM',
    'Nevada': 'NV',
    'NewYork': 'NY',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'RhodeIsland': 'RI',
    'SouthCarolina': 'SC',
    'SouthDakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Virginia': 'VA',
    'Vermont': 'VT',
    'Washington': 'WA',
    'Wisconsin': 'WI',
    'WestVirginia': 'WV',
    'Wyoming': 'WY',
  };
}
