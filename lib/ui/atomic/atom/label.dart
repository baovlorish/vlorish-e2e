import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:flutter/material.dart';

enum LabelType {
  // todo: (andreyK) remove
  Header,
  HeaderNew,
  // todo: (andreyK) remove
  General,
  GeneralNew,
  // todo: (andreyK) remove
  Hint,
  HintNew,
  Button,
  HeaderBold,
  GeneralBold,
  GeneralWorkSansBold,
  HintSmall,
  GreyLabel,
  HintLargeBold,
  TableHeader,
  TableHeaderLink,
  Link,
  LinkLarge,
  Header2,
  // todo: (andreyK) remove
  Header3,
  Header3New,
  LargeButton,
  LabelBoldPink,
  Ellipsis,
  NewLargeTextStyle,
  NewSmallTextStyle,
  NewHeader3,
}

class Label extends StatelessWidget {
  final String text;
  final LabelType type;
  final TextAlign textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;

  const Label({
    required this.text,
    required this.type,
    this.textAlign = TextAlign.start,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.overflow,
    this.maxLines,
    this.softWrap,
  });



  @override
  Widget build(BuildContext context) {
    final styles = {
      LabelType.Header: CustomTextStyle.HeaderTextStyle(context),
      LabelType.HeaderNew: CustomTextStyle.HeaderNewTextStyle(context),
      LabelType.General: CustomTextStyle.LabelTextStyle(context),
      LabelType.GeneralNew: CustomTextStyle.LabelNewTextStyle(context),
      LabelType.Hint: CustomTextStyle.HintTextStyle(context),
      LabelType.HintNew: CustomTextStyle.HintNewTextStyle(context),
      LabelType.GreyLabel: CustomTextStyle.GreyLabelStyle(context),
      LabelType.Button: CustomTextStyle.ButtonTextStyle(context),
      LabelType.HeaderBold: CustomTextStyle.HeaderBoldTextStyle(context),
      LabelType.GeneralBold: CustomTextStyle.LabelBoldTextStyle(context),
      LabelType.GeneralWorkSansBold:
          CustomTextStyle.LabelBoldWorkSansTextStyle(context),
      LabelType.TableHeader: CustomTextStyle.TableHeaderTextStyle(context),
      LabelType.TableHeaderLink:
          CustomTextStyle.TableHeaderLinkTextStyle(context),
      LabelType.Link: CustomTextStyle.LinkTextStyle(context),
      LabelType.LinkLarge: CustomTextStyle.LinkLargeTextStyle(context),
      LabelType.Header2: CustomTextStyle.Header2TextStyle(context),
      LabelType.Header3: CustomTextStyle.Header3TextStyle(context),
      LabelType.Header3New: CustomTextStyle.Header3NewTextStyle(context),
      LabelType.LargeButton: CustomTextStyle.LargeButtonStyle(context),
      LabelType.HintLargeBold: CustomTextStyle.HintLargeBoldStyle(context),
      LabelType.LabelBoldPink: CustomTextStyle.LabelBoldPinkTextStyle(context),
      LabelType.HintSmall: CustomTextStyle.HintSmallTextStyle(context),
      LabelType.Ellipsis: CustomTextStyle.DropDownTextStyle(context),
      LabelType.NewHeader3: CustomTextStyle.NewHeader3TextStyle(context),
      LabelType.NewSmallTextStyle: CustomTextStyle.NewSmallTextStyle(context),
      LabelType.NewLargeTextStyle: CustomTextStyle.NewLargeTextStyle(context),
    };
    var textStyle =
        _formatTextStyle(context, styles[type]!, color, fontWeight, fontSize);

    return Text(
      type == LabelType.TableHeader || type == LabelType.TableHeaderLink
          ? text.toUpperCase()
          : text,
      style: textStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }

  TextStyle _formatTextStyle(BuildContext context, TextStyle style,
      Color? color, FontWeight? fontWeight, double? fontSize) {
    if (color != null || fontWeight != null || fontSize != null) {
      style = style.copyWith(
          color: color, fontWeight: fontWeight, fontSize: fontSize);
    }
    return style;
  }
}
