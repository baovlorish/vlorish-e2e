import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/model/account.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/model/manual_account.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardWidget extends StatefulWidget {
  @override
  final Key? key;
  final Account account;
  final double padding;
  final bool showMuteButton;
  final Function? muteCallBack;
  final Function? deleteCallBack;

  /// sets callback on tap on whole card
  final Function(String)? onCardTap;
  final bool isSelected;

  const CardWidget(
      {required this.account,
      this.padding = 8,
      this.showMuteButton = true,
      this.muteCallBack,
      this.deleteCallBack,
      this.key,
      this.onCardTap,
      this.isSelected = false});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late final CardWidgetData data;

  @override
  void initState() {
    super.initState();
    data = CardWidgetData(widget.account, context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Container(
        key: widget.key,
        decoration: BoxDecoration(
          color: data.backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
              color: widget.isSelected
                  ? CustomColorScheme.mainDarkBackground
                  : data.borderColor),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(2.5, 2.5),
              color: widget.isSelected
                  ? CustomColorScheme.clipElementInactive
                  : Colors.transparent,
            )
          ],
        ),
        child: CustomMaterialInkWell(
          borderRadius: BorderRadius.circular(4),
          type: (data.isPersonal) ? InkWellType.Purple : InkWellType.Grey,
          onTap: widget.onCardTap != null
              ? () => widget.onCardTap?.call(widget.account.id)
              : null,
          child: Container(
            padding: EdgeInsets.all(16),
            height: 165,
            width: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: data.sourceTypeText,
                      color: data.textColor,
                      type: LabelType.General,
                    ),
                    if (!data.isWithoutType)
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage(data.iconUrl),
                            color: data.iconColor,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Label(
                            text: data.usageTypeText,
                            color: data.iconColor,
                            fontSize: 14,
                            type: LabelType.General,
                          ),
                        ],
                      )
                  ],
                ),
                Label(
                  text: data.isWithoutType
                      ? AppLocalizations.of(context)!.unconfiguredAccount
                      : widget.account.name,
                  color: data.textColor,
                  type: LabelType.GeneralBold,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: widget.account.getAccountTypeName(context),
                      color: data.textColor,
                      fontSize: 12,
                      type: LabelType.General,
                    ),
                    if (!data.isManual)
                      Label(
                        text:
                            '**** ${(widget.account as BankAccount).lastFourDigits}',
                        color: data.textColor,
                        fontSize: 12,
                        type: LabelType.General,
                      ),
                  ],
                ),
                Label(
                  text: data.isWithoutType
                      ? ''
                      : widget.account.balance
                          .toInt()
                          .formattedWithDecorativeElementsString(),
                  color: data.textColor,
                  type: LabelType.GeneralBold,
                ),
                // todo: use button items instead of containers
                widget.showMuteButton
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Row(
                            children: [
                              if (data.isManual)
                                CustomMaterialInkWell(
                                  type:
                                      (data.isPersonal && !data.account.isMuted)
                                          ? InkWellType.White
                                          : InkWellType.Purple,
                                  borderRadius: BorderRadius.circular(4),
                                  onTap: () => widget.deleteCallBack?.call(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ImageIcon(
                                      AssetImage(
                                          'assets/images/icons/delete.png'),
                                      color:
                                          CustomColorScheme.mainDarkBackground,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              // ),
                              SizedBox(
                                width: 12,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: data.muteButtonBorderColor,
                                  ),
                                ),
                                child: CustomMaterialInkWell(
                                  borderRadius: BorderRadius.circular(4),
                                  materialColor: data.muteButtonBackgroundColor,
                                  type: (data.isWithoutType ||
                                          data.account.isMuted)
                                      ? InkWellType.Purple
                                      : InkWellType.White,
                                  onTap: () {
                                    widget.muteCallBack?.call();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    child: Label(
                                      text: data.muteButtonText,
                                      type: LabelType.General,
                                      fontSize: 12,
                                      color: data.muteButtonTextColor,
                                    ),
                                  ),
                                ),
                                // ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Label(
                        text: data.isManual
                            ? ''
                            : (widget.account as BankAccount).bankName,
                        type: LabelType.General,
                        fontSize: 12,
                        color: data.iconColor,
                      ),
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }
}

class CardWidgetData {
  final Account account;
  final BuildContext context;

  CardWidgetData(this.account, this.context);

  bool get isWithoutType => account.usageType == 0;

  bool get isPersonal => account.usageType == 1;

  bool get isManual => account is ManualAccount;

  String get sourceTypeText => isManual
      ? AppLocalizations.of(context)!.manual
      : AppLocalizations.of(context)!.plaid;

  String get usageTypeText => isPersonal
      ? AppLocalizations.of(context)!.personal
      : AppLocalizations.of(context)!.business;

  String get muteButtonText => isWithoutType
      ? AppLocalizations.of(context)!.setType
      : account.isMuted
          ? AppLocalizations.of(context)!.unmute
          : AppLocalizations.of(context)!.mute;

  String get iconUrl => isPersonal
      ? 'assets/images/icons/ic_personal.png'
      : 'assets/images/icons/ic_business.png';

  Color get textColor => isWithoutType
      ? CustomColorScheme.inputBorder
      : account.isMuted
          ? isPersonal
              ? CustomColorScheme.clipElementInactive
              : CustomColorScheme.inputBorder
          : isPersonal
              ? CustomColorScheme.tableWhiteText
              : CustomColorScheme.text;

  Color get borderColor => isWithoutType
      ? CustomColorScheme.cardBorder
      : account.isMuted
          ? isPersonal
              ? CustomColorScheme.clipElementInactive
              : CustomColorScheme.cardBorder
          : Colors.transparent;

  Color get backgroundColor => isWithoutType
      ? CustomColorScheme.tableWhiteText
      : account.isMuted
          ? CustomColorScheme.tableWhiteText
          : isPersonal
              ? CustomColorScheme.clipElementInactive
              : CustomColorScheme.tableBorder;

  Color get iconColor => account.isMuted
      ? CustomColorScheme.clipElementInactive
      : CustomColorScheme.mainDarkBackground;

  Color get muteButtonBackgroundColor => isWithoutType
      ? CustomColorScheme.tableWhiteText
      : account.isMuted
          ? Colors.transparent
          : CustomColorScheme.mainDarkBackground;

  Color get muteButtonTextColor => isWithoutType
      ? CustomColorScheme.inputBorder
      : account.isMuted
          ? CustomColorScheme.mainDarkBackground
          : CustomColorScheme.tableWhiteText;

  Color get muteButtonBorderColor => isWithoutType
      ? CustomColorScheme.cardBorder
      : CustomColorScheme.mainDarkBackground;
}
