import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/clip_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/responsive_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/clip_selector_element.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_auth_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/details_subscribe_container.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

class SubscriptionLayout extends StatefulWidget {
  final List<ClipSelectorData> listChips = [
    ClipSelectorData(key: Key('1'), title: 'Annual', selected: true),
    ClipSelectorData(key: Key('2'), title: 'Monthly', selected: false),
  ];
  final Logger logger = getLogger('SubscriptionLayout');

  @override
  State<SubscriptionLayout> createState() => _SubscriptionLayoutState();
}

class _SubscriptionLayoutState extends State<SubscriptionLayout> {
  bool isAnnual = true;
  bool shouldShowSuccessLayout = false;

  var controller = ScrollController();

  late final SubscriptionCubit _subscriptionCubit;
  late final HomeScreenCubit _homeScreenCubit;

  @override
  void initState() {
    _subscriptionCubit = BlocProvider.of<SubscriptionCubit>(context);
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleSubscriptionType() {
    setState(() {
      isAnnual = widget.listChips.first.selected;
    });
  }

  String get subscriptionHint =>
      '${AppLocalizations.of(context)!.subscriptionHint1}\n${AppLocalizations.of(context)!.subscriptionHint2}';

  @override
  Widget build(BuildContext context) {
    isAnnual = widget.listChips.first.selected;
    var isSmall = !ResponsiveWidget.isLargeScreen(context);
    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
      listener: (BuildContext context, state) {
        if (state is SubscriptionError) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
              );
            },
          );
        } else if (state is SubscriptionAlreadyExistsState) {
          showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(
                context,
                message: state.message,
                onButtonPress: () {
                  NavigatorManager.navigateTo(
                      context, BudgetPersonalPage.routeName);
                  // if user is subscribed, update user data
                  _homeScreenCubit.updateUserData();
                },
                buttonText: 'OK',
              );
            },
          );
        }
      },
      builder: (context, state) {
        return AuthScreen(
          title: AppLocalizations.of(context)!.subscriptionTitle,
          leftSideColumnWidgetIndex: 6,
          availableIndex: _subscriptionCubit.availableIndex,
          role: _subscriptionCubit.role,
          showDefaultSignupTopWidget: true,
          centerWidget: (state is SubscriptionExistsSignUp)
              ? SuccessAuthWidget(
                  onPressed: () {
                    NavigatorManager.navigateTo(
                        context, SignupAddCardPage.routeName);
                  },
                  message:
                      AppLocalizations.of(context)!.youHaveAlreadySubscribed,
                )
              : !(state is SubscriptionLoaded)
                  ? Center(
                      child: Container(),
                    )
                  : SingleChildScrollView(
                      controller: controller,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Label(
                                text: AppLocalizations.of(context)!
                                    .subscriptionTitle,
                                type: LabelType.Header,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipSelectorElement(
                                widget.listChips,
                                (selected) {
                                  widget.logger.i(
                                      'User selected ${selected.title} from the clips');
                                  toggleSubscriptionType();
                                },
                                padding: EdgeInsets.only(right: 16.0),
                              ),
                            ),
                            isSmall
                                ? Column(
                                    children:
                                        contentBlocks(isSmall, isAnnual, state),
                                  )
                                : IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: contentBlocks(
                                          isSmall, isAnnual, state),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  List<Widget> contentBlocks(
      bool isSmall, bool isAnnual, SubscriptionLoaded state) {
    return [

        _wrapperExpanded(
          isSmall,
          DetailsSubscribeContainer(
              DetailsSubscribeContainerModel(
                title: state.personalPlan.name,
                planType: state.personalPlan.type,
                details:
                    'Designed for individuals with one or more w-2 income but no freelance or self-employed/business income.',
                logo: 'images/folder_multiple_image.png',
                price:
                    '\$${isAnnual ? state.personalPlan.yearly.pricePerMonth : state.personalPlan.monthly.pricePerMonth}',
                pricePersion: PricePersion.MONTH,
                resultButton: 'Start with ${state.personalPlan.name}',
                onPressedResultButton: () {
                  _subscriptionCubit.subscribe(isAnnual
                      ? state.personalPlan.yearly.id
                      : state.personalPlan.monthly.id);
                },
                featureList: <FeatureSubscriptionItem>[
                  FeatureSubscriptionItem('Two-way Budget Tracking', ''),
                  FeatureSubscriptionItem('Debt Pay-off Planning', ''),
                  FeatureSubscriptionItem('Net Worth Tracking', ''),
                  FeatureSubscriptionItem('Goals Planning', ''),
                  FeatureSubscriptionItem('Retirement Planning', ''),
                  FeatureSubscriptionItem('Investment Tracking', ''),
                  FeatureSubscriptionItem('Peer Score™', ''),
                ],
                hint: subscriptionHint,
            ),
            isSmall),
      ),
      SizedBox(
          width: isSmall ? 0 : 36.0,
          height: isSmall ? 36.0 : 0.0,
        ),

        _wrapperExpanded(
          isSmall,
          DetailsSubscribeContainer(
              DetailsSubscribeContainerModel(
                title: state.premiumPlan.name,
                planType: state.premiumPlan.type,
                details:
                    'For freelancers and others with self-employed income, side hustles or multiple income streams that need to figure estimated income taxes.',
                logo: 'images/folder_multiple_image.png',
                price:
                    '\$${isAnnual ? state.premiumPlan.yearly.pricePerMonth : state.premiumPlan.monthly.pricePerMonth}',
                pricePersion: PricePersion.MONTH,
                resultButton: 'Get ${state.premiumPlan.name}',
                onPressedResultButton: () {
                  _subscriptionCubit.subscribe(isAnnual
                      ? state.premiumPlan.yearly.id
                      : state.premiumPlan.monthly.id);
                },
                featureList: <FeatureSubscriptionItem>[
                  FeatureSubscriptionItem('Two-way Budget Tracking', ''),
                  FeatureSubscriptionItem('Debt Pay-off Planning', ''),
                  FeatureSubscriptionItem('Net Worth Tracking', ''),
                  FeatureSubscriptionItem('Goals Planning', ''),
                  FeatureSubscriptionItem('Retirement Planning', ''),
                  FeatureSubscriptionItem('Investment Tracking', ''),
                  FeatureSubscriptionItem('Peer Score™', ''),
                  FeatureSubscriptionItem('Realtime Tax Estimates', ''),
                ],
                hint: subscriptionHint,
              ),
              isSmall),
        ),

        SizedBox(
          width: isSmall ? 0 : 36.0,
          height: isSmall ? 36.0 : 0.0,
        ),
      _wrapperExpanded(
        isSmall,
        DetailsSubscribeContainer(
            DetailsSubscribeContainerModel(
              title: state.advisorPlan.name,
              planType: state.advisorPlan.type,
              details:
                  'For financial advisors and accountants that need to collaborate with clients on building budgets, financial goals, and taxes.',
              logo: 'images/folder_multiple_image.png',
              price:
                  '\$${isAnnual ? state.advisorPlan.yearly.pricePerMonth : state.advisorPlan.monthly.pricePerMonth}',
              pricePersion: PricePersion.MONTH,
              resultButton: 'Get ${state.advisorPlan.name}',
              onPressedResultButton: () {
                _subscriptionCubit.subscribe(isAnnual
                    ? state.advisorPlan.yearly.id
                    : state.advisorPlan.monthly.id);
              },
              featureList: <FeatureSubscriptionItem>[
                FeatureSubscriptionItem('Two-way Budget Tracking', ''),
                FeatureSubscriptionItem('Debt Pay-off Planning', ''),
                FeatureSubscriptionItem('Net Worth Tracking', ''),
                FeatureSubscriptionItem('Goals Planning', ''),
                FeatureSubscriptionItem('Retirement Planning', ''),
                FeatureSubscriptionItem('Investment Tracking', ''),
                FeatureSubscriptionItem('Peer Score™', ''),
                FeatureSubscriptionItem('Realtime Tax Estimates', ''),
              ],
              hint: subscriptionHint,
            ),
            isSmall),
      ),
    ];
  }

  Widget _wrapperExpanded(bool isSmall, Widget child) {
    if (isSmall) {
      return child;
    } else {
      return Expanded(
        child: child,
      );
    }
  }
}
