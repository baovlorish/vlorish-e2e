import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalBlock extends StatelessWidget {
  final String? name;
  final String? secondName;
  final String memberSince;
  final String? imageUrl;
  final bool isSmall;
  final bool shouldDisplayMenageUsers;

  const PersonalBlock({
    Key? key,
    required this.name,
    required this.secondName,
    required this.memberSince,
    required this.isSmall,
    required this.shouldDisplayMenageUsers,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileOverviewCubit = BlocProvider.of<ProfileOverviewCubit>(context);
    return Container(
      color: CustomColorScheme.blockBackground,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.personal,
                style: CustomTextStyle.HeaderTextStyle(context)
                    .copyWith(fontSize: 24),
              ),
              if (!isSmall)
                Align(
                    alignment: Alignment.topRight,
                    child: profileDetailsButton(context, profileOverviewCubit)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: CustomColorScheme.button,
                        ),
                        borderRadius: BorderRadius.circular(66),
                      ),
                      child: ClipOval(
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl!,
                                width: 132.0,
                                height: 132.0,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/imageplaceholder.png',
                                width: 132.0,
                                height: 132.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(width: 24),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (name != null)
                            Text(
                              name!,
                              style: CustomTextStyle.LabelBoldTextStyle(context)
                                  .copyWith(fontSize: 35),
                            ),
                          if (secondName != null)
                            Text(
                              secondName!,
                              style: CustomTextStyle.LabelBoldTextStyle(context)
                                  .copyWith(fontSize: 35),
                            ),
                          SizedBox(height: 25),
                          Label(
                            text: AppLocalizations.of(context)!.memberSince +
                                ' ' +
                                CustomDateFormats.defaultDateFormat
                                    .format(DateTime.parse(memberSince)),
                            type: LabelType.General,
                            fontSize: 19,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isSmall && shouldDisplayMenageUsers)
                  Align(
                    alignment: Alignment.topRight,
                    child: manageUsersButton(context),
                  ),
              ],
            ),
          ),
          if (isSmall)
            Column(
              children: [
                SizedBox(height: 16),
                profileDetailsButton(context, profileOverviewCubit),
                if (shouldDisplayMenageUsers) SizedBox(height: 16),
                if (shouldDisplayMenageUsers) manageUsersButton(context)
              ],
            ),
        ],
      ),
    );
  }

  Widget profileDetailsButton(
      BuildContext context, ProfileOverviewCubit profileOverviewCubit) {
    return SizedBox(
      width: 200,
      child: ButtonItem(
        context,
        text: AppLocalizations.of(context)!.profileDetailsLower,
        onPressed: () {
          profileOverviewCubit.navigateToProfileDetailsPage(context);
        },
      ),
    );
  }

  Widget manageUsersButton(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ButtonItem(
        context,
        text: AppLocalizations.of(context)!.manageUsersLower,
        onPressed: () {
          NavigatorManager.navigateTo(
            context,
            ManageUsersPage.routeName,
          );
        },
      ),
    );
  }
}
