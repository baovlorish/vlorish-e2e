import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/details_subscribe_container.dart';
import 'package:flutter/material.dart';

class PriceValueItem extends StatelessWidget {
  final String priceValue;
  final PricePersion pricePersion;
  final Color color;

  PriceValueItem({required this.priceValue, required this.pricePersion, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Label(
          text: priceValue,
          type: LabelType.HeaderBold,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Label(
            text: '/${pricePersion.name}',
            type: LabelType.General,
            color: color,
          ),
        ),
      ],
    );
  }
}
