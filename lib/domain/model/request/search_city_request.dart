class SearchCityRequest {
  final String apiKey;
  final String query;
  final String country;
  final String resultType;
  final String maxresults;

  SearchCityRequest({
    required this.apiKey,
    required this.query,
    required this.country,
    required this.resultType,
    required this.maxresults,
  });

  factory SearchCityRequest.fromMap(Map<String, dynamic> map) {
    return SearchCityRequest(
      apiKey: map['apiKey'] as String,
      query: map['query'] as String,
      country: map['country'] as String,
      resultType: map['resultType'] as String,
      maxresults: map['maxresults'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apiKey': apiKey,
      'query': query,
      'country': country,
      'resultType': resultType,
      'maxresults': maxresults,
      'language':'en'
    };
  }
}
