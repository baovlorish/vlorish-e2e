import 'dart:js' as js;

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/response/referral_response.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/policies/terms_referral_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReferralLayout extends StatefulWidget {
  const ReferralLayout({Key? key}) : super(key: key);

  @override
  State<ReferralLayout> createState() => _ReferralLayoutState();
}

class _ReferralLayoutState extends State<ReferralLayout> {
  var isScreenSmall = false;
  late final ReferralCubit _referralCubit;
  late final referralLink;
  @override
  void initState() {
    _referralCubit = BlocProvider.of<ReferralCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      title: AppLocalizations.of(context)!.referral,
      headerWidget: Label(
        text: AppLocalizations.of(context)!.referralTitle,
        type: LabelType.Header2,
      ),
      bodyWidget: BlocConsumer<ReferralCubit, ReferralState>(
        listener: (BuildContext context, state) async {
          if (state is ReferralError) {
            await showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.error);
              },
            );
          }
        },
        builder: (BuildContext context, state) {
          if (state is ReferralInitial) {
            return CustomLoadingIndicator();
          } else if (state is ReferralLoaded) {
            referralLink = state.referralResponse.links.isNotEmpty ? state.referralResponse.links.first : '';
            return Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                isScreenSmall = constraints.maxWidth < 1000;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: CustomColorScheme.tableBorder,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isScreenSmall)
                                Column(
                                  children: [
                                    Label(
                                        text: AppLocalizations.of(context)!.copyAndShareYourLink,
                                        type: LabelType.Header3),
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        ConstrainedBox(
                                          constraints: isScreenSmall
                                              ? BoxConstraints(
                                                  maxWidth:
                                                      constraints.maxWidth -
                                                          226)
                                              : BoxConstraints(
                                                  maxWidth:
                                                      constraints.maxWidth -
                                                          400),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: CustomColorScheme
                                                          .tableBorder)),
                                              child: Row(
                                                children: [
                                                  SelectableText(referralLink),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 64,
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ButtonItem(
                                              context,
                                              text: AppLocalizations.of(context)!.copyLink,
                                              onPressed: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: referralLink));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      CustomColorScheme
                                                          .clipElementInactive,
                                                  content: Label(
                                                    text:
                                                    AppLocalizations.of(context)!.linkCopiedToClipboard,
                                                    type: LabelType.General,
                                                  ),
                                                ));
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    ReferralHistoryWidget(
                                      referralResponse: state.referralResponse,
                                      isSmall: isScreenSmall,
                                      referralCubit: _referralCubit,
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Label(
                                            text: AppLocalizations.of(context)!.copyAndShareYourLink,
                                            type: LabelType.Header3),
                                        SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          alignment: WrapAlignment.spaceBetween,
                                          children: [
                                            ConstrainedBox(
                                              constraints: isScreenSmall
                                                  ? BoxConstraints(
                                                      maxWidth:
                                                          constraints.maxWidth -
                                                              226)
                                                  : BoxConstraints(
                                                      maxWidth:
                                                          constraints.maxWidth -
                                                              540),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          color:
                                                              CustomColorScheme
                                                                  .tableBorder)),
                                                  child: Row(
                                                    children: [
                                                      SelectableText(referralLink),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 64,
                                              width: 150,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: ButtonItem(
                                                  context,
                                                  text: AppLocalizations.of(context)!.copyLink,
                                                  onPressed: () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: referralLink));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            CustomColorScheme
                                                                .clipElementInactive,
                                                        content: Label(
                                                          text:
                                                          AppLocalizations.of(context)!.linkCopiedToClipboard,
                                                          type:
                                                              LabelType.General,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        HowItWorksWidget(),
                                      ],
                                    ),
                                    ReferralHistoryWidget(
                                      referralResponse: state.referralResponse,
                                      isSmall: isScreenSmall,
                                      referralCubit: _referralCubit,
                                    ),
                                  ],
                                ),
                              if (isScreenSmall) HowItWorksWidget(),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class HowItWorksWidget extends StatelessWidget {
  const HowItWorksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 36),
          Label(
            text: AppLocalizations.of(context)!.howItWorks,
            type: LabelType.Header3,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage('assets/images/icons/group.png'),
                color: CustomColorScheme.groupBackgroundColor,
                size: 56,
              ),
              SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: '1. ',
                      style: CustomTextStyle.LabelBoldTextStyle(context),
                      children: [
                        TextSpan(
                            text:
                            AppLocalizations.of(context)!.shareYourLinkWithFriendsFamilyColleagues,
                            style: CustomTextStyle.LabelTextStyle(context))
                      ]),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage('assets/images/icons/add_user.png'),
                color: CustomColorScheme.groupBackgroundColor,
                size: 56,
              ),
              SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: '2. ',
                      style: CustomTextStyle.LabelBoldTextStyle(context),
                      children: [
                        TextSpan(
                            text:  AppLocalizations.of(context)!.ifTheySubscribeTheVlorish,
                            style: CustomTextStyle.LabelTextStyle(context))
                      ]),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage('assets/images/icons/gift.png'),
                color: CustomColorScheme.groupBackgroundColor,
                size: 56,
              ),
              SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: '3. ',
                      style: CustomTextStyle.LabelBoldTextStyle(context),
                      children: [
                        TextSpan(
                            text:
                            AppLocalizations.of(context)!.benefitsFromReferralDescription,
                            style: CustomTextStyle.LabelTextStyle(context))
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReferralHistoryWidget extends StatefulWidget {
  final ReferralResponse referralResponse;
  final bool isSmall;
  final ReferralCubit referralCubit;

  const ReferralHistoryWidget({
    Key? key,
    required this.referralResponse,
    required this.isSmall,
    required this.referralCubit,
  }) : super(key: key);

  @override
  State<ReferralHistoryWidget> createState() => _ReferralHistoryWidgetState();
}

class _ReferralHistoryWidgetState extends State<ReferralHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Label(
            text: AppLocalizations.of(context)!.referralHistory,
            type: LabelType.Header3,
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: (widget.isSmall ? 0 : 16.0)),
          child: Container(
            constraints: BoxConstraints(minWidth: 300),
            decoration: BoxDecoration(
              color: CustomColorScheme.groupBackgroundColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  color: CustomColorScheme.tableBorder,
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        text: AppLocalizations.of(context)!.totalEarned+': ',
                        type: LabelType.General,
                        fontWeight: FontWeight.w600,
                      ),
                      Label(
                          text:
                              '\$' + widget.referralResponse.earned.toString(),
                          type: LabelType.General)
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Label(
                        text: AppLocalizations.of(context)!.unpaidAmount+': ',
                        type: LabelType.General,
                        fontWeight: FontWeight.w600,
                      ),
                      Label(
                          text: '\$' +
                              (widget.referralResponse.earned -
                                      widget.referralResponse.paid)
                                  .toString(),
                          type: LabelType.General)
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Label(
                        text: AppLocalizations.of(context)!.totalPaid+': ',
                        type: LabelType.General,
                        fontWeight: FontWeight.w600,
                      ),
                      Label(
                          text: '\$' + widget.referralResponse.paid.toString(),
                          type: LabelType.General)
                    ],
                  ),
                  SizedBox(height: 32),
                  ButtonItem(
                    context,
                    text: AppLocalizations.of(context)!.checkThePortal,
                    onPressed: () async {
                      var referralSSO =
                          await widget.referralCubit.getReferralSSo();
                      js.context.callMethod('open', [referralSSO.url]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        LabelButtonItem(
          label: Label(
            text: AppLocalizations.of(context)!.termsHeadline,
            type: LabelType.Link,
          ),
          onPressed: () {
            NavigatorManager.navigateTo(
              context,
              TermsReferralPage.routeName,
            );
          },
        ),
      ],
    );
  }
}
