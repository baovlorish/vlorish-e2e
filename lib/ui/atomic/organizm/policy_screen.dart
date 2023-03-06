import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_selectable_text.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PolicyScreen extends StatelessWidget {
  final String title;
  final DateTime lastUpdate;
  final Widget child;

  const PolicyScreen(
      {Key? key,
      required this.title,
      required this.lastUpdate,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 76,
        elevation: 0.0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              'assets/images/logo_white_full.png',
              height: 50.0,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
      body: Title(
        title: title,
        color: CustomColorScheme.generalBackground,
        child: Container(
          color: CustomColorScheme.homeBodyWidgetBackground,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColorScheme.blockBackground,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: CustomColorScheme.tableBorder,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomSelectableText(
                            textData: SelectableTextData(
                              text: title,
                              type: SelectableTextType.PageHeader,
                            ),
                          ),
                        ),
                        Flexible(
                          child: CustomSelectableText(
                            textData: SelectableTextData(
                              text:
                                  '${AppLocalizations.of(context)!.lastUpdated}: ${CustomDateFormats.defaultDateFormat.format(lastUpdate)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    child,
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 150,
                      child: ButtonItem(context,
                          text: AppLocalizations.of(context)!.ok.toUpperCase(),
                          buttonType: ButtonType.LargeText, onPressed: () {
                        Navigator.of(context).pop();
                      }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
