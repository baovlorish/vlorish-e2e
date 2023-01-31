import 'dart:async';

import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_indicator_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/budget_memo_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/split_transaction_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/unite_transaction_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/list_of_transaction_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionWidget extends StatefulWidget with FlexFactors {
  final TransactionModel transaction;
  final TransactionModel? originalOfSplit;
  final Function(SplitTransactionEvent) onSplit;
  final Function(String id) onUnite;
  final CategoryManagementPageModel categoriesModel;
  final Function(String, bool) onCategoryChanged;
  final String? newParentCategoryId;
  final String? newSubcategoryId;
  final bool isDoNotRememberCheckboxSelected;
  final bool isBulkCheckboxSelected;

  final Function({
    required String id,
    required String parentCategoryId,
    required String newSubcategoryId,
    required bool isPreviousCategory,
    required bool isCheckboxSelected,
  }) onSubcategoryChosen;

  final ProfileOverviewModel currentUser;
  final bool isCoach;

  final String? budgetOwnerId;

  final Function onBulkChanged;

  TransactionWidget(
    this.transaction, {
    required this.onCategoryChanged,
    required this.categoriesModel,
    required this.onSplit,
    required this.onUnite,
    required this.isCoach,
    required this.currentUser,
    Key? key,
    this.originalOfSplit,
    required this.onSubcategoryChosen,
    this.isDoNotRememberCheckboxSelected = false,
    this.isBulkCheckboxSelected = false,
    this.newParentCategoryId,
    this.newSubcategoryId,
    required this.budgetOwnerId,
    required this.onBulkChanged,
  }) : super(key: key);

  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  late String? parentCategoryId;
  late String? categoryId;
  ManagementSubcategory? subcategory;
  var parentKeys = <String>[];
  var parentNames = <String>[];
  var childKeys = <String>[];
  var childNames = <String>[];
  var mappingSuccessful = true;
  MemoNoteModel? note;
  bool categoryIsChanged = false;
  bool isDoNotRememberCheckboxSelected = false;
  bool isMenuVisible = false;
  bool isMenuFocused = false;
  bool bulkCheckboxCanBeSelected = true;

  @override
  void initState() {
    super.initState();
    categoryIsChanged = widget.newSubcategoryId == null ? false : true;
    parentCategoryId =
        widget.newParentCategoryId ?? widget.transaction.parentCategoryId;
    categoryId = widget.newSubcategoryId ?? widget.transaction.categoryId;
    note = widget.transaction.note;
    isDoNotRememberCheckboxSelected = widget.isDoNotRememberCheckboxSelected;
  }

  late var bloc = BlocProvider.of<BankAccountsAndStatisticsBloc>(context);
  late var isReadOnlyAdvisor = BlocProvider.of<HomeScreenCubit>(context)
      .currentForeignSession
      ?.access
      .isReadOnly;

  late var hasBulkCheckbox = _shouldShowDropdowns && isReadOnlyAdvisor != true;

  @override
  Widget build(BuildContext context) {
    if (parentCategoryId != null) {
      subcategory = ManagementSubcategory(
        name: '',
        isHidden: false,
        isIncome: widget.transaction.isIncome,
        parentCategoryId: parentCategoryId!,
        id: categoryId ?? '',
        hasTransactions: true,
        isDebt: false,
        cannotBeHidden: false,
      );
      try {
        parentKeys = (widget.transaction.usageType == 1
                ? widget.categoriesModel.personal
                : widget.categoriesModel.business)
            .possibleParentCategoriesIds(subcategory!, excludeSelf: false);
        parentNames = (widget.transaction.usageType == 1
                ? widget.categoriesModel.personal
                : widget.categoriesModel.business)
            .possibleParentCategoriesNames(context, subcategory!,
                excludeSelf: false);
        _getSubcategoryDropdownParams();
      } catch (e) {
        mappingSuccessful = false;
      }
    }
    bulkCheckboxCanBeSelected =
        bloc.bulkType == widget.transaction.transactionType ||
            bloc.bulkType == null;
    return Column(
      children: [
        Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: 30,
              child: hasBulkCheckbox
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        splashRadius: 0,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        fillColor: bulkCheckboxCanBeSelected
                            ? MaterialStateProperty.all(
                                CustomColorScheme.mainDarkBackground)
                            : MaterialStateProperty.all(Colors.black26),
                        value:
                            bloc.bulkTransactions.contains(widget.transaction),
                        onChanged: bulkCheckboxCanBeSelected
                            ? (bool? value) {
                                var previousBulkLength =
                                    bloc.bulkTransactions.length;
                                if (value == true &&
                                    !bloc.bulkTransactions
                                        .contains(widget.transaction)) {
                                  bloc.addTransactionToBulk(widget.transaction);
                                } else if (value == false) {
                                  bloc.removeTransactionFromBulk(
                                      widget.transaction);
                                }

                                setState(() {});
                                // if first added or last removed from bulk,
                                // then redraw whole table
                                if ((previousBulkLength == 0 &&
                                        bloc.bulkTransactions.length == 1) ||
                                    (previousBulkLength == 1 &&
                                        bloc.bulkTransactions.isEmpty)) {
                                  widget.onBulkChanged();
                                }
                              }
                            : null,
                      ),
                    )
                  : SizedBox(),
            ),
            Expanded(
              flex: widget.combined,
              child: CustomMaterialInkWell(
                type: InkWellType.Grey,
                onDoubleTap: isReadOnlyAdvisor != true && _shouldShowDropdowns
                    ? () {
                        _showSplitOrUniteDialog(widget.transaction);
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: widget.listOfFlexFactors[0],
                          child: Wrap(
                            children: [
                              Label(
                                softWrap: false,
                                text: CustomDateFormats.defaultDateFormat
                                    .format(widget.transaction.creationTimeUtc)
                                    .substring(0, 3),
                                type: LabelType.General,
                              ),
                              Label(
                                softWrap: false,
                                text: CustomDateFormats.defaultDateFormat
                                    .format(widget.transaction.creationTimeUtc)
                                    .substring(3, 6),
                                type: LabelType.General,
                              ),
                              Label(
                                softWrap: false,
                                text: CustomDateFormats.defaultDateFormat
                                    .format(widget.transaction.creationTimeUtc)
                                    .substring(6, 10),
                                type: LabelType.General,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: widget.listOfFlexFactors[1],
                          child: Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Label(
                              text: widget.transaction.merchantName,
                              type: LabelType.General,
                            ),
                          )),
                      Expanded(
                        flex: widget.listOfFlexFactors[2],
                        child: Listener(
                          onPointerDown: (PointerDownEvent? event) {
                            if (event?.kind == PointerDeviceKind.mouse &&
                                event?.buttons == kSecondaryMouseButton) {
                              showMemoMenu();
                            }
                          },
                          child: ModalAnchor(
                            tag: widget.transaction.id,
                            child: MouseRegion(
                              onEnter: (details) {
                                if (note != null) {
                                  showMemoMenu();
                                }
                              },
                              onExit: (details) async {
                                if (isMenuVisible) {
                                  Timer(Duration(milliseconds: 100), () {
                                    if (!isMenuFocused) {
                                      removeMemoMenu();
                                    }
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(
                                    text: widget.transaction.amount
                                        .formattedWithDecorativeElementsString(),
                                    type: LabelType.GeneralBold,
                                    color: widget.transaction.amount > 0
                                        ? CustomColorScheme.successPopupButton
                                        : CustomColorScheme.negativeTransaction,
                                  ),
                                  SizedBox(height: 32),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 32),
                                      if (widget.transaction.isChildOfSplit)
                                        CustomTooltip(
                                          message: AppLocalizations.of(context)!
                                              .splitTransaction,
                                          color: CustomColorScheme
                                              .mainDarkBackground,
                                          child: CustomIndicatorWidget(
                                            color: widget.transaction.amount > 0
                                                ? CustomColorScheme
                                                    .successPopupButton
                                                : CustomColorScheme
                                                    .negativeTransaction,
                                            child: Label(
                                              text: 'S',
                                              type: LabelType.GeneralBold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      if (note != null)
                                        CustomIndicatorWidget(
                                          color: CustomColorScheme
                                              .tableExpensesBusinessText,
                                          child: Icon(
                                            Icons.comment,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      if (widget.transaction.isPending == true)
                                        CustomTooltip(
                                          message: AppLocalizations.of(context)!
                                              .transactionIsPending,
                                          color: CustomColorScheme
                                              .mainDarkBackground,
                                          child: CustomIndicatorWidget(
                                            color: CustomColorScheme
                                                .pendingStatusColor,
                                            child: Label(
                                              text: 'P',
                                              type: LabelType.GeneralBold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: widget.listOfFlexFactors[3],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Label(
                                  text: widget.transaction.bankAccountName,
                                  type: LabelType.General),
                              SizedBox(height: 28),
                              Label(
                                  text:
                                      '**** **** **** ${widget.transaction.lastFourDigits}',
                                  type: LabelType.HintSmall),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: widget.listOfFlexFactors[4],
              child: SizedBox(
                child: _shouldShowDropdowns
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40,
                              child: DropdownItem<String>(
                                isSmall: true,
                                enabled: isReadOnlyAdvisor != true,
                                items: parentNames,
                                initialValue: parentCategoryId,
                                itemKeys: parentKeys,
                                hintText: AppLocalizations.of(context)!.select,
                                callback: (String id) {
                                  categoryIsChanged = false;
                                  _changeParentCategory(id);
                                },
                              ),
                            ),
                            SizedBox(height: 4),
                            SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownItem<String>(
                                    key: ObjectKey(parentCategoryId),
                                    isSmall: true,
                                    enabled: isReadOnlyAdvisor != true,
                                    items: childNames,
                                    itemKeys: childKeys,
                                    initialValue: categoryId,
                                    hintText:
                                        AppLocalizations.of(context)!.select,
                                    callback: (String value) {
                                      setState(() {
                                        categoryIsChanged = value !=
                                            widget.transaction.categoryId;
                                        categoryId = value;
                                        widget.onSubcategoryChosen(
                                          id: widget.transaction.id,
                                          parentCategoryId: parentCategoryId!,
                                          newSubcategoryId: categoryId!,
                                          isPreviousCategory:
                                              !categoryIsChanged,
                                          isCheckboxSelected: false,
                                        );
                                      });
                                    },
                                  ),
                                  categoryIsChanged
                                      ? SizedBox(height: 8)
                                      : SizedBox(),
                                  categoryIsChanged
                                      ? LayoutBuilder(
                                          builder: (BuildContext context,
                                              BoxConstraints constraints) {
                                            return Flex(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              direction:
                                                  constraints.maxWidth < 200
                                                      ? Axis.vertical
                                                      : Axis.horizontal,
                                              children: [
                                                Flexible(
                                                  child: CustomTooltip(
                                                    message: AppLocalizations
                                                            .of(context)!
                                                        .doNotApplyThisChangeInTheFuture,
                                                    color: CustomColorScheme
                                                        .mainDarkBackground,
                                                    child:
                                                        CustomMaterialInkWell(
                                                      border:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      type: InkWellType.Purple,
                                                      onTap: () {
                                                        setState(() {
                                                          isDoNotRememberCheckboxSelected =
                                                              !isDoNotRememberCheckboxSelected;
                                                        });

                                                        widget
                                                            .onSubcategoryChosen(
                                                          id: widget
                                                              .transaction.id,
                                                          parentCategoryId:
                                                              parentCategoryId!,
                                                          newSubcategoryId:
                                                              categoryId!,
                                                          isPreviousCategory:
                                                              !categoryIsChanged,
                                                          isCheckboxSelected:
                                                              isDoNotRememberCheckboxSelected,
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            value:
                                                                isDoNotRememberCheckboxSelected,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                isDoNotRememberCheckboxSelected =
                                                                    value!;
                                                              });
                                                              widget
                                                                  .onSubcategoryChosen(
                                                                id: widget
                                                                    .transaction
                                                                    .id,
                                                                parentCategoryId:
                                                                    parentCategoryId!,
                                                                newSubcategoryId:
                                                                    categoryId!,
                                                                isPreviousCategory:
                                                                    !categoryIsChanged,
                                                                isCheckboxSelected:
                                                                    isDoNotRememberCheckboxSelected,
                                                              );
                                                            },
                                                          ),
                                                          Flexible(
                                                            child: Label(
                                                                type: LabelType
                                                                    .GeneralBold,
                                                                text:
                                                                    '${AppLocalizations.of(context)!.doNotRemember} ',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                constraints.maxWidth < 200
                                                    ? SizedBox(height: 8.0)
                                                    : SizedBox(width: 8.0),
                                                ButtonItem(context,
                                                    text:
                                                        '${AppLocalizations.of(context)!.apply}',
                                                    onPressed: () {
                                                  widget.onCategoryChanged(
                                                      categoryId!,
                                                      !isDoNotRememberCheckboxSelected);
                                                  categoryIsChanged = false;
                                                  isDoNotRememberCheckboxSelected =
                                                      false;
                                                  setState(() {});
                                                })
                                              ],
                                            );
                                          },
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : widget.transaction.isInterest
                        ? Label(
                            text: AppLocalizations.of(context)!.interestPayment,
                            type: LabelType.General)
                        : SizedBox(),
              ),
            ),
          ],
        ),
        CustomDivider(),
      ],
    );
  }

  void _getSubcategoryDropdownParams() {
    childKeys = (widget.transaction.usageType == 1
            ? widget.categoriesModel.personal
            : widget.categoriesModel.business)
        .possibleSubcategoriesToMoveIds(subcategory!, parentCategoryId!,
            excludeSelf: false);
    childNames = (widget.transaction.usageType == 1
            ? widget.categoriesModel.personal
            : widget.categoriesModel.business)
        .possibleSubcategoriesToMove(context, subcategory!, parentCategoryId!,
            excludeSelf: false);
  }

  void _changeParentCategory(String id) {
    setState(() {
      parentCategoryId = id;
      _getSubcategoryDropdownParams();
      if (childKeys.length == 1) {
        categoryId = childKeys.first;
        categoryIsChanged = (categoryId != widget.transaction.categoryId);
      } else {
        categoryId = null;
      }
    });
  }

  void _showSplitOrUniteDialog(TransactionModel transaction) {
    if (transaction.isChildOfSplit && widget.originalOfSplit != null) {
      showDialog(
          context: context,
          builder: (context) {
            return UniteTransactionPopup(
              originalTransaction: widget.originalOfSplit!,
              onConfirm: (String id) {
                widget.onUnite(id);
              },
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SplitTransactionPopup(
              transaction: transaction,
              onConfirm: (SplitTransactionEvent event) {
                widget.onSplit(event);
              },
              parentIdMap: (widget.transaction.usageType == 1
                      ? widget.categoriesModel.personal
                      : widget.categoriesModel.business)
                  .possibleParentCategoriesMap(subcategory!,
                      excludeSelf: false),
            );
          });
    }
  }

  bool get _shouldShowDropdowns =>
      mappingSuccessful &&
      parentCategoryId != null &&
      widget.transaction.categoryId != null;

  void removeMemoMenu() {
    isMenuFocused = false;
    isMenuVisible = false;
    removeModal();
  }

  void showMemoMenu() {
    isMenuVisible = true;
    showModal(
      ModalEntry.selfPositioned(
        context,
        tag: 'memo${widget.transaction.id}',
        anchorTag: widget.transaction.id,
        child: MouseRegion(
          onEnter: (_) {
            isMenuFocused = true;
          },
          onExit: (_) {
            removeMemoMenu();
          },
          child: MemoMenuWidget(
            isTransactionMenu: true,
            isPartner: widget.currentUser.role.isPartner,
            budgetPartnerId: widget.currentUser.partnerId,
            onClose: () {
              removeMemoMenu();
            },
            isCoach: widget.isCoach,
            userId: widget.currentUser.userId,
            notesPage: MemoNotesPage.transaction(note),
            onAdd: (String value) async {
              var newNote = await bloc.setTransactionNote(
                SetTransactionNoteEvent(
                  note: value,
                  shouldFetch: true,
                  transactionId: widget.transaction.id,
                ),
              );

              if (newNote != null) {
                setState(() {
                  note = newNote;
                });
              }
            },
            onDelete: (model) async {
              removeMemoMenu();
              var isSuccessful = await bloc.deleteTransactionNote(
                DeleteTransactionNoteEvent(
                  transactionId: widget.transaction.id,
                ),
              );
              if (isSuccessful != null && isSuccessful) {
                setState(() {
                  note = null;
                });
              }
            },
            onEdit: (MemoNoteModel note) async {
              await bloc.setTransactionNote(
                SetTransactionNoteEvent(
                  note: note.note,
                  transactionId: widget.transaction.id,
                ),
              );
              setState(() {
                this.note = note;
              });
            },
            onReply: (String text, MemoNoteModel note) async {
              var replyId = await bloc.addReply(
                note: text,
                noteId: note.transactionId ?? note.id,
              );
              if (replyId != null) {
                var replies = note.replies;
                replies.add(MemoNoteModel(
                    id: replyId,
                    transactionId: note.transactionId,
                    note: text,
                    isTransaction: note.isTransaction,
                    isGoal: false,
                    authorUserId: widget.currentUser.userId,
                    authorFirstName: widget.currentUser.firstName,
                    authorLastName: widget.currentUser.lastName,
                    authorImageUrl: widget.currentUser.imageUrl,
                    isReply: true,
                    replies: [],
                    monthYear: note.monthYear,
                    canShowMore: false,
                    canAddReply: false));
                this.note = this.note?.copyWith(replies: replies);
              }
            },
            onDeleteReply: (_, String replyId) async {
              await bloc.deleteNoteReply(replyId: replyId);
              note = note?.copyWith(
                  replies: note?.replies
                      .where((element) => element.id != replyId)
                      .toList());
            },
            onEditReply: (MemoNoteModel note, MemoNoteModel reply) async {
              await bloc.editNoteReply(
                  replyId: reply.id, replyText: reply.note);
              var replies = note.replies;
              var index =
                  replies.indexWhere((element) => element.id == reply.id);
              replies.removeAt(index);
              replies.insert(index, reply);
              this.note = note.copyWith(replies: replies);
            },
            onUpdate: () async {
              return await bloc.fetchNotePage(widget.transaction.id);
            },
          ),
        ),
      ),
    );
    setState(() {});
  }
}
