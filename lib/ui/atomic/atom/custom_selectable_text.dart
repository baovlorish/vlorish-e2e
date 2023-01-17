import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum SelectableTextType {
  Link,
  General,
  Header,
  SubHeader,
  Gist,
  Bold,
  PageHeader
}

class SelectableTextData {
  final String text;
  final String? url;
  final Function? onTap;
  final SelectableTextType type;

  SelectableTextData(
      {required this.text,
      this.url,
      this.onTap,
      this.type = SelectableTextType.General});
}

class CustomSelectableText extends StatelessWidget {
  final SelectableTextData textData;
  final List<SelectableTextData>? childrenTextData;

  const CustomSelectableText(
      {Key? key, required this.textData, this.childrenTextData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      //todo fix cursor for elements with onTap
      TextSpan(
        text: textData.text,
        recognizer: textData.onTap != null
            ? (TapGestureRecognizer()..onTap = () => textData.onTap)
            : null,
        style: styleMapper(textData.type, context),
        children: List.generate(
          childrenTextData?.length ?? 0,
          (index) => TextSpan(
            text: childrenTextData![index].text,
            recognizer: childrenTextData![index].onTap != null
                ? (TapGestureRecognizer()
                  ..onTapDown = (_) {
                    childrenTextData![index].onTap!();
                  })
                : null,
            style: styleMapper(childrenTextData![index].type, context),
          ),
        ),
      ),
    );
  }

  TextStyle? styleMapper(SelectableTextType type, BuildContext context) {
    var styles = <SelectableTextType, TextStyle>{
      SelectableTextType.General:
          CustomTextStyle.LabelTextStyle(context).copyWith(height: 2.0),
      SelectableTextType.Link:
          CustomTextStyle.LinkTextStyle(context).copyWith(height: 2.0),
      SelectableTextType.Bold:
          CustomTextStyle.LabelBoldTextStyle(context).copyWith(height: 2.0),
      SelectableTextType.Gist: CustomTextStyle.LabelBoldTextStyle(context)
          .copyWith(height: 2.0, fontStyle: FontStyle.italic),
      SelectableTextType.Header:
          CustomTextStyle.Header2TextStyle(context).copyWith(height: 2.0),
      SelectableTextType.PageHeader:
          CustomTextStyle.HeaderBoldTextStyle(context).copyWith(height: 2.0),
      SelectableTextType.SubHeader:
          CustomTextStyle.Header3TextStyle(context).copyWith(height: 2.0),
    };
    return styles[type];
  }
}
