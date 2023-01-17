import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_flexible_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/plan_block.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/presonal_block.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/security_block.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileOverviewLayout extends StatefulWidget {
  const ProfileOverviewLayout({Key? key}) : super(key: key);

  @override
  _ProfileOverviewLayoutState createState() => _ProfileOverviewLayoutState();
}

class _ProfileOverviewLayoutState extends State<ProfileOverviewLayout> {
  var isSmall = false;

  final _formKey = GlobalKey<FormState>();
  late final ProfileOverviewCubit _profileOverviewCubit;
  @override
  void initState() {
    _profileOverviewCubit = BlocProvider.of<ProfileOverviewCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.of(context).size.width < 1280;
    return BlocConsumer<ProfileOverviewCubit, ProfileOverviewState>(
      listener: (BuildContext context, state) {
        if (state is ProfileOverviewError) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
              );
            },
          );
        } else if (state is PasswordChangedSuccessfully) {
          showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(
                context,
                message:
                    AppLocalizations.of(context)!.passwordChangedSuccessfully,
              );
            },
          );
        }
      },
      builder: (BuildContext context, state) {
        return HomeScreen(
          title: AppLocalizations.of(context)!.profileOverview,
          headerWidget: (state is ProfileOverviewLoaded)
              ? _buildHeader(state.model.firstName)
              : null,
          bodyWidget: (state is ProfileOverviewLoaded)
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                        child: IntrinsicHeight(
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            direction:
                                isSmall ? Axis.vertical : Axis.horizontal,
                            children: [
                              isSmall
                                  ? _personalColumn(state.model)
                                  : Flexible(
                                      flex: 5,
                                      child: _personalColumn(state.model),
                                    ),
                              if (!state.model.role.isPartner)
                                isSmall
                                    ? CustomDivider()
                                    : CustomVerticalDivider(),
                              state.model.role.isPartner
                                  ? SizedBox()
                                  : MaybeFlexibleWidget(
                                      flexibleWhen: !isSmall,
                                      flex: 4,
                                      child: Container(
                                        child: PlanBlock(
                                          state.model.subscription,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        );
      },
    );
  }

  Widget _buildHeader(String? firstName) {
    return Label(
      text: firstName != null
          ? AppLocalizations.of(context)!.welcome + ', $firstName!'
          : AppLocalizations.of(context)!.welcome + '!',
      type: LabelType.HeaderBold,
    );
  }

  Widget _personalColumn(ProfileOverviewModel model) {
    var isSmall = MediaQuery.of(context).size.width < 940;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            PersonalBlock(
              name: model.firstName,
              secondName: model.lastName,
              memberSince: model.creationTimeUtc,
              imageUrl: model.imageUrl,
              isPremium: model.subscription?.isPremiumOrHigher,
              isSmall: isSmall,
            ),
            CustomDivider(),
            SecurityBlock(isSmall: isSmall),
          ],
        ),
        _closeButton(),
      ],
    );
  }

  Widget _closeButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(24),
        color: CustomColorScheme.blockBackground,
        child: LabelButtonItem(
          label: Label(
            text: AppLocalizations.of(context)!.closeAccount,
            type: LabelType.LinkLarge,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_context) {
                return Form(
                  key: _formKey,
                  child: TwoButtonsDialog(
                    context,
                    title: AppLocalizations.of(context)!
                        .areYouSureWantToCloseYourVlorishAccount,
                    message:
                        AppLocalizations.of(context)!.yourDataWillBeDeleted,
                    mainButtonText: AppLocalizations.of(context)!.yesClose,
                    dismissButtonText: AppLocalizations.of(context)!.no,
                    onMainButtonPressed: () async {
                      if (await _profileOverviewCubit.deleteUser() ?? false) {
                        _profileOverviewCubit.navigateToSignIn(context);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
