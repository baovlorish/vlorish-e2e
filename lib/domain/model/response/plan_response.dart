class PlanResponse {
  final String name;
  final List<Price> prices;

  final int type;

  PlanResponse({
    required this.name,
    required this.type,
    required this.prices,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    var prices = <Price>[];
    for (var item in json['prices']) {
      prices.add(Price.fromJson(item));
    }

    return PlanResponse(
      name: json['name'],
      type: json['type'],
      prices: prices,
    );
  }
}

class Price {
  final String id;
  final int recurringType;
  final double pricePerMonth;

  ///archived === old prices
  final bool archived;
  Price({
    required this.id,
    required this.recurringType,
    required this.pricePerMonth,
    required this.archived,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        id: json['id'],
        recurringType: json['recurringType'],
        pricePerMonth: json['pricePerMonth'],
        archived: json['archived'],
      );
}
