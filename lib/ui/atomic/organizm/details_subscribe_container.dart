import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/inform_hint.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/price_value_item.dart';
import 'package:flutter/material.dart';

enum PricePersion { DAY, MONTH }

extension PricePersionExtension on PricePersion {
  String get name {
    return toString().toLowerCase().split('.')[1];
  }
}

class DetailsSubscribeContainerModel {
  String title;
  String details;
  String logo;
  String price;
  PricePersion pricePersion;
  String resultButton;
  List<FeatureSubscriptionItem> featureList;
  VoidCallback onPressedResultButton;
  final int planType;

  DetailsSubscribeContainerModel(
      {required this.title,
      required this.planType,
      required this.details,
      required this.logo,
      required this.price,
      required this.pricePersion,
      required this.resultButton,
      required this.onPressedResultButton,
      required this.featureList});
}

class FeatureSubscriptionItem {
  String title;
  String tooltip;

  FeatureSubscriptionItem(this.title, this.tooltip);
}

@immutable
class DetailsSubscribeContainer extends StatelessWidget {
  final DetailsSubscribeContainerModel model;
  final bool isVertical;

  const DetailsSubscribeContainer(this.model, this.isVertical);

  @override
  Widget build(BuildContext context) {
    var textColor = model.planType != 0 ? Colors.white : CustomColorScheme.text;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: model.planType == 1
              ? CustomColorScheme.mainDarkBackground
              : model.planType == 2
                  ? CustomColorScheme.negativeTransaction
                  : CustomColorScheme.inputBorder,
        ),
        borderRadius: BorderRadius.circular(20.0),
        color: model.planType == 1
            ? CustomColorScheme.mainDarkBackground
            : model.planType == 2
            ? CustomColorScheme.negativeTransaction
            : Colors.white,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/logo_bg.png',
          ),
          alignment: Alignment(1, 0.3),
          scale: 1.5,
          fit: BoxFit.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: model.title,
              type: LabelType.Header2,
              color: textColor,
            ),
            SizedBox(
              height: 10,
            ),
            Label(
              text: model.details,
              type: LabelType.General,
              color: textColor,
            ),
            SizedBox(
              height: 20,
            ),
            PriceValueItem(
              priceValue: model.price,
              pricePersion: PricePersion.MONTH,
              color: textColor,
            ),
            SizedBox(
              height: 20,
            ),
            ...model.featureList.map(
              (itemModel) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: model.planType != 0
                          ? Colors.white
                          : CustomColorScheme.mainDarkBackground,
                      size: 10,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Label(
                      text: itemModel.title,
                      type: LabelType.GeneralBold,
                      color: textColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InformHint(
                        message: itemModel.tooltip,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isVertical ? SizedBox() : Expanded(child: SizedBox()),
            ButtonItem(
              context,
              buttonType: ButtonType.White,
              text: model.resultButton,
              onPressed: model.onPressedResultButton,
            ),
          ],
        ),
      ),
    );
  }
}
