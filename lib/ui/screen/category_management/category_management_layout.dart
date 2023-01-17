import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/annual_monthly_switcher.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/category_group_tile.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/reassign_transactions_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryManagementLayout extends StatefulWidget {
  const CategoryManagementLayout();

  @override
  State<CategoryManagementLayout> createState() =>
      _CategoryManagementLayoutState();
}

class _CategoryManagementLayoutState extends State<CategoryManagementLayout> {
  bool isPersonal = true;
  late final CategoryManagementCubit categoryManagementCubit;

  @override
  void initState() {
    super.initState();
    categoryManagementCubit = BlocProvider.of<CategoryManagementCubit>(context);
    isPersonal = categoryManagementCubit.returnToPersonal;
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      title: AppLocalizations.of(context)!.categoriesManagement,
      headerWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              CustomBackButton(
                onPressed: () {
                  categoryManagementCubit.navigateBack(context);
                },
              ),
              Label(
                text: AppLocalizations.of(context)!.categoriesManagement,
                type: LabelType.HeaderBold,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: TwoOptionSwitcher(
              isFirstItemSelected: isPersonal,
              onPressed: () {
                setState(() {
                  isPersonal = !isPersonal;
                });
              },
              options: [
                AppLocalizations.of(context)!.personal,
                AppLocalizations.of(context)!.business
              ],
            ),
          ),
        ],
      ),
      bodyWidget:
          BlocConsumer<CategoryManagementCubit, CategoryManagementState>(
        listener: (context, state) {
          if (state is CategoryManagementError) {
            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.error);
              },
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryManagementLoading) {
            return CustomLoadingIndicator();
          } else if (state is CategoryManagementLoaded) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  child: LayoutBuilder(builder: (context, constraints) {
                    var isSmall = constraints.maxWidth < 500;
                    var tileWidth = _tileWidth(isSmall, constraints.maxWidth);
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: CustomColorScheme.blockBackground,
                                border: Border.all(
                                  width: 1,
                                  color: CustomColorScheme.dividerColor,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: MaybeIntrinsicHeightWidget(
                                  shouldIntrinsicHeight: !isSmall,
                                  child: Flex(
                                    direction: isSmall
                                        ? Axis.vertical
                                        : Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _CategoriesColumn(
                                        isLarge: !isSmall,
                                        tileWidth: tileWidth,
                                        model: state.model,
                                        isPersonal: isPersonal,
                                        isInUse: true,
                                        callback: (id, {newCategoryId}) {
                                          categoryManagementCubit.hideCategory(
                                              id,
                                              newCategoryId: newCategoryId);
                                        },
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              width: 1,
                                              color: CustomColorScheme
                                                  .dividerColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _CategoriesColumn(
                                        isLarge: !isSmall,
                                        tileWidth: tileWidth,
                                        model: state.model,
                                        isPersonal: isPersonal,
                                        isInUse: false,
                                        callback: (id) {
                                          categoryManagementCubit
                                              .unHideCategory(id);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  double _tileWidth(bool isSmall, double maxWidth) {
    var tileWidth = maxWidth / 2 - 32;
    if (tileWidth > 550) tileWidth = 550;
    if (isSmall) {
      tileWidth = maxWidth - 34;
    }
    return tileWidth;
  }
}

class _CategoriesColumn extends StatelessWidget {
  final double tileWidth;
  final CategoryManagementPageModel model;
  final bool isInUse;
  final bool isPersonal;
  late final List<ManagementCategory> categories;
  final Function callback;
  final bool isLarge;

  _CategoriesColumn(
      {Key? key,
      required this.tileWidth,
      required this.model,
      required this.isInUse,
      required this.isPersonal,
      required this.callback,
      required this.isLarge})
      : super(key: key) {
    categories = isInUse
        ? model.usageType(isPersonal).inUse
        : model.usageType(isPersonal).available;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: (isInUse || isLarge || categories.isNotEmpty) ? 1 : 0,
              color: CustomColorScheme.dividerColor,
            ),
          ),
        ),
        child: Container(
          width: tileWidth,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              top: 8.0,
            ),
            child: Label(
              textAlign: TextAlign.center,
              text: isInUse
                  ? AppLocalizations.of(context)!.inUse
                  : AppLocalizations.of(context)!.available,
              type: LabelType.Header3,
            ),
          ),
        ),
      ),
      for (var item in categories)
        CategoryGroupTile(
          key: Key(item.id),
          categoryModel: item,
          width: tileWidth,
          isInUse: isInUse,
          onCategoryReassigned: (String id) {
            callback(id);
          },
          onSubcategoryReassigned: (ManagementSubcategory subcategory) {
            if (subcategory.hasTransactions && isInUse) {
              showDialog(
                context: context,
                builder: (_context) {
                  return ReAssignTransactionsDialog(
                    subcategory: subcategory,
                    model: model,
                    isPersonal: isPersonal,
                    callback: callback,
                  );
                },
              );
            } else {
              callback(
                subcategory.id,
              );
            }
          },
          isCoachLimited: BlocProvider.of<HomeScreenCubit>(context)
                  .currentForeignSession
                  ?.access
                  .isLimited ==
              true,
        ),
    ]);
  }
}

class MaybeIntrinsicHeightWidget extends StatelessWidget {
  final Widget child;
  final bool shouldIntrinsicHeight;

  const MaybeIntrinsicHeightWidget({
    Key? key,
    required this.shouldIntrinsicHeight,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shouldIntrinsicHeight
        ? IntrinsicHeight(
            child: child,
          )
        : child;
  }
}
