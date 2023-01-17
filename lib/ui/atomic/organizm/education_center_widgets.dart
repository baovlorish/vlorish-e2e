import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/contact_us/contact_us_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FAQsWidget extends StatelessWidget {
  const FAQsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expansionTileItems = [
      ExpansionTileData(
          title: AppLocalizations.of(context)!.howDoIGetStartedWithBudgeting,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .howDoIGetStartedWithBudgetingBodyPart1,
            ),
            ExpansionTileContentSpan(
                text: 'help button',
                isLink: true,
                onTap: () {
                  NavigatorManager.navigateTo(
                    context,
                    EducationCenterPage.routeName,
                    params: {
                      'tab': '0',
                    },
                  );
                }),
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .howDoIGetStartedWithBudgetingBodyPart2,
            ),
            ExpansionTileContentSpan(
                text: 'Vlorish categories guideline',
                isLink: true,
                onTap: () {
                  NavigatorManager.navigateTo(
                    context,
                    EducationCenterPage.routeName,
                    params: {
                      'tab': '1',
                    },
                  );
                }),
            ExpansionTileContentSpan(
              text: ' found here and ',
            ),
            ExpansionTileContentSpan(
                text: 'budgeting tips and tricks',
                isLink: true,
                onTap: () {
                  NavigatorManager.navigateTo(
                    context,
                    EducationCenterPage.routeName,
                    params: {
                      'tab': '2',
                    },
                  );
                }),
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .howDoIGetStartedWithBudgetingBodyPart3,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .whyDoesMyCreditCardPaymentShowAnegativeNumber,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .whyDoesMyCreditCardPaymentShowAnegativeNumberBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.howDoIRemoveMyPartner,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.howDoIRemoveMyPartnerBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .partnerThatISharedTheCouplesBudgetingAndIAreNoLongerTogether,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .partnerThatISharedTheCouplesBudgetingAndIAreNoLongerTogetherBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.removeAFinancialCoach,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.removeAFinancialCoachBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .whatInformationDoFinancialCoachesAndCPAsSeeWithinMyBudget,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .whatInformationDoFinancialCoachesAndCPAsSeeWithinMyBudgetBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .howAccurateIsTheEstimatedTaxCalculationOnTheTaxPage,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .howAccurateIsTheEstimatedTaxCalculationOnTheTaxPageBody,
            ),
          ]),
      ExpansionTileData(
          title:
              AppLocalizations.of(context)!.howDoIDeleteADuplicateTransaction,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .howDoIDeleteADuplicateTransactionBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.howIsMyInformationProtected,
          content: [
            ExpansionTileContentSpan(
              text:
                  AppLocalizations.of(context)!.howIsMyInformationProtectedBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.whyIsntMyVlorishScoreImproving,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .whyIsntMyVlorishScoreImprovingBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .iAmAFinancialPlannerAndMyCompanyWantsToWhitelabelYourVlorishScore,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .iAmAFinancialPlannerAndMyCompanyWantsToWhitelabelYourVlorishScoreBody,
            ),
            ExpansionTileContentSpan(
                text: 'contact page',
                isLink: true,
                onTap: () {
                  NavigatorManager.navigateTo(
                    context,
                    ContactUsPage.routeName,
                  );
                }),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .iAmAFinancialPlannerAndImSuddenlyLockedOutOfMyClientAccounts,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .iAmAFinancialPlannerAndImSuddenlyLockedOutOfMyClientAccountsBody,
            ),
            ExpansionTileContentSpan(
                text: 'here',
                isLink: true,
                onTap: () {
                  //todo: HELP page
                }),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.myCompanyWantsToOfferVlorish,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .myCompanyWantsToOfferVlorishBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .myBankDoesntHaveLinkingToFinancialAppsCanIManuallyAddTransactionsToVlorish,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .myBankDoesntHaveLinkingToFinancialAppsCanIManuallyAddTransactionsToVlorishBody,
            ),
          ]),
      ExpansionTileData(
          title:
              AppLocalizations.of(context)!.isThereAMobileAppVersionOfVlorish,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!
                  .isThereAMobileAppVersionOfVlorishBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!
              .iHaveADifferentQuestionThatHasNotBeenAddressedHere,
          hasButton: true,
          buttonText: AppLocalizations.of(context)!.contactUs,
          onButtonTap: () {
            NavigatorManager.navigateTo(
              context,
              ContactUsPage.routeName,
            );
          },
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.contactUsText,
            ),
          ]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        for (var item in expansionTileItems)
          HelpExpansionTile(
            item,
            color: CustomColorScheme.FAQsTiles,
          ),
      ],
    );
  }
}

class BudgetingTipsWidget extends StatelessWidget {
  const BudgetingTipsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expansionTileItems = [
      ExpansionTileData(
          title: AppLocalizations.of(context)!.opportunityCost,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.opportunityCostBody1,
            ),
            ExpansionTileContentSpan(
                text: AppLocalizations.of(context)!.opportunityCostBody2,
                isLink: true,
                onTap: () {
                  NavigatorManager.navigateTo(
                    context,
                    EducationCenterPage.routeName,
                    params: {
                      'tab': '0',
                    },
                  );
                }),
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.opportunityCostBody3,
            ),
            ExpansionTileContentSpan(
                text: AppLocalizations.of(context)!.here,
                isLink: true,
                onTap: () {}),
            ExpansionTileContentSpan(text: '.'),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.budgetingWithIntent,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.budgetingWithIntentBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.achievableGoals,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.achievableGoalsBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.betterHabits,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.betterHabitsBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.lessCash,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.lessCashBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.betterBanking,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.betterBankingBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.vlorishScore,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.vlorishScoreBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.mixAndMatch,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.mixAndMatchBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.billPayments,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.billPaymentsBody,
            ),
          ]),
      ExpansionTileData(
          title: AppLocalizations.of(context)!.debtPayoff,
          content: [
            ExpansionTileContentSpan(
              text: AppLocalizations.of(context)!.debtPayoffBody,
            ),
          ]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Label(
            text: AppLocalizations.of(context)!.budgetTips1,
            type: LabelType.General,
            fontWeight: FontWeight.w500,
          ),
        ),
        for (var item in expansionTileItems)
          HelpExpansionTile(
            item,
            color: CustomColorScheme.tableExpenseBackground,
          ),
      ],
    );
  }
}

class HelpExpansionTile extends StatefulWidget {
  final ExpansionTileData item;
  final bool hasLeadingIcon;
  final Color color;

  const HelpExpansionTile(
    this.item, {
    Key? key,
    this.hasLeadingIcon = false,
    required this.color,
  }) : super(key: key);

  @override
  _HelpExpansionTileState createState() => _HelpExpansionTileState();
}

class _HelpExpansionTileState extends State<HelpExpansionTile>
    with TickerProviderStateMixin {
  bool isExpanded = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutQuart,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
        ),
        child: ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          leading: widget.hasLeadingIcon
              ? RotationTransition(
                  turns: _animation,
                  child: isExpanded
                      ? Icon(Icons.remove_circle_outline_rounded)
                      : Icon(Icons.add_circle_outline_rounded),
                )
              : null,
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(
              () {
                isExpanded = expanded;
              },
            );
          },
          title: Label(
            text: widget.item.title,
            type: LabelType.General,
            fontWeight: FontWeight.w600,
          ),
          controlAffinity: widget.hasLeadingIcon
              ? ListTileControlAffinity.leading
              : ListTileControlAffinity.trailing,
          trailing: !widget.hasLeadingIcon
              ? ImageIcon(
                  isExpanded
                      ? AssetImage('assets/images/icons/arrow_up.png')
                      : AssetImage('assets/images/icons/arrow.png'),
                  color: CustomColorScheme.errorPopupButton,
                  size: 24,
                )
              : null,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(children: [
                  for (var span in widget.item.content)
                    TextSpan(
                      text: span.text,
                      style: span.isLink
                          ? CustomTextStyle.LinkTextStyle(context)
                          : CustomTextStyle.LabelTextStyle(context),
                      recognizer: TapGestureRecognizer()..onTap = span.onTap,
                    )
                ]),
              ),
            ),
            if (widget.item.hasButton)
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: Center(
                    child: SizedBox(
                      width: 130,
                      child: ButtonItem(
                        context,
                        text: widget.item.buttonText!,
                        onPressed: widget.item.onButtonTap!,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ExpansionTileData {
  final String title;
  final List<ExpansionTileContentSpan> content;
  final bool hasButton;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  ExpansionTileData({
    required this.title,
    required this.content,
    this.hasButton = false,
    this.onButtonTap,
    this.buttonText,
  });
}

class ExpansionTileContentSpan {
  final String text;
  final bool isLink;
  final VoidCallback? onTap;

  ExpansionTileContentSpan({
    required this.text,
    this.isLink = false,
    this.onTap,
  });
}
