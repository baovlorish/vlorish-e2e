import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/inform_hint.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/price_value_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../atom/custom_indicator_widget.dart';
import '../atom/custom_tooltip.dart';


enum PricePersion { DAY, MONTH }

extension PricePersionExtension on PricePersion {
  String get name {
    return toString().toLowerCase().split('.')[1];
  }
}

class DetailsSubscribeContainerModel {
  final String title;
  final String details;
  final String logo;
  final String price;
  final PricePersion pricePersion;
  final String resultButton;
  final List<FeatureSubscriptionItem> featureList;
  final VoidCallback onPressedResultButton;
  final int planType;
  final String hint;

  const DetailsSubscribeContainerModel({
    required this.title,
    required this.planType,
    required this.details,
    required this.logo,
    required this.price,
    required this.pricePersion,
    required this.resultButton,
    required this.onPressedResultButton,
    required this.featureList,
    required this.hint,
  });
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

  Color get backgroundColor => model.planType == 1
      ? CustomColorScheme.mainDarkBackground
      : model.planType == 2
      ? CustomColorScheme.negativeTransaction
      : Colors.white;

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
        color: backgroundColor,
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
            SizedBox(height: 20),
            Row(children: [
              Label(
                text: AppLocalizations.of(context)!.learnMore,
                type: LabelType.GeneralBold,
                color: CustomColorScheme.clipElementInactive,
              ),
              SizedBox(width: 8),
              CustomTooltip(
                message: model.hint,
                color: CustomColorScheme.mainDarkBackground,
                child: CustomIndicatorWidget(
                  color: backgroundColor,
                  child: Center(
                    child: Icon(
                      Icons.info,
                      color: CustomColorScheme.clipElementInactive,
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 20),
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
