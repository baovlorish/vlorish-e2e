class ReferralResponse {
  ReferralResponse({
    required this.links,
    required this.earned,
    required this.paid,
  });

  final List<String> links;
  final int earned;
  final int paid;

  factory ReferralResponse.fromJson(Map<String, dynamic> json) {
    var links = <String>[];
    for (var item in json['links']) {
      links.add(item);
    }
    return ReferralResponse(
      earned: json['earned'],
      paid: json['paid'],
      links: links,
    );
  }

  @override
  String toString() {
    return 'ReferralResponse{links: $links, earned: $earned, paid: $paid}';
  }
}

class ReferralSSOResponse {
  ReferralSSOResponse({
    required this.url,
    required this.expiresAt,
  });

  final String url;
  final DateTime expiresAt;

  factory ReferralSSOResponse.fromJson(Map<String, dynamic> json) =>
      ReferralSSOResponse(
        url: json['url'],
        expiresAt: DateTime.parse(json['expiresAt']),
      );

  @override
  String toString() {
    return 'ReferralSSOResponse{url: $url, expiresAt: $expiresAt}';
  }
}
