/*
import 'dart:ui';

import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
*/

// old implementation via showMenu
/*

Future<void> showMemo(
  context,
  PointerEvent event, {
  bool showTwoInputItems = false,
  String? cellMemoInitialValue,
  String? transactionMemoInitialValue,
  required Future<void> Function(String newNote) onSave,
  required Future<void> Function() onDelete,
}) async {
  final transactionsCommentController = TextEditingController();
  TextEditingController? cellCommentController;
  if (showTwoInputItems) {
    cellCommentController = TextEditingController();
    if (cellMemoInitialValue != null) {
      cellCommentController.text = cellMemoInitialValue;
    }
  }

  if (transactionMemoInitialValue != null &&
      event.kind == PointerDeviceKind.mouse) {
    final sizes = MediaQuery.of(context).size;
    await showMenu(
      context: context,
      position: RelativeRect.fromSize(event.position & Size(100.0, 0.0), sizes),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          enabled: false,
          child: Theme(
            data: Theme.of(context).copyWith(disabledColor: Colors.transparent),
            child: Column(
              children: [
                if (showTwoInputItems)
                  _MemoInputItem(
                    labelText: AppLocalizations.of(context)!.cellComment,
                    hintText: AppLocalizations.of(context)!.addCommentToCell,
                    textEditingController: cellCommentController!,
                    onDelete: onDelete,
                  ),
                if (showTwoInputItems) SizedBox(height: 8),
                _MemoInputItem(
                  labelText: AppLocalizations.of(context)!.transactionComment,
                  hintText:
                      AppLocalizations.of(context)!.addCommentToTransaction,
                  textEditingController: transactionsCommentController,
                  onDelete: onDelete,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            if (transactionsCommentController.text.isNotEmpty) {
              await onSave(transactionsCommentController.text);
            }
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.button,
            ),
            child: Center(
              child: Label(
                text: cellMemoInitialValue != null
                    ? AppLocalizations.of(context)!.save
                    : AppLocalizations.of(context)!.addComment,
                type: LabelType.Button,
                color: Theme.of(context).colorScheme.blockBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemoInputItem extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final Future<void>? Function() onDelete;

  _MemoInputItem({
    required this.labelText,
    required this.hintText,
    required this.textEditingController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: labelText,
                type: LabelType.General,
              ),
              PopupMenuItem(
                onTap: () async {
                  await onDelete();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ImageIcon(
                    AssetImage('assets/images/icons/delete.png'),
                    color: Theme.of(context).colorScheme.inputErrorBorder,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextField(
          style: CustomTextStyle.LabelTextStyle(context),
          minLines: 2,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(16),
            fillColor: Theme.of(context).colorScheme.inputFill,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.inputBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: Theme.of(context).colorScheme.button,
              ),
            ),
            hintMaxLines: 2,
            hintText: hintText,
            hintStyle: CustomTextStyle.HintTextStyle(context),
          ),
          controller: textEditingController,
          inputFormatters: [LengthLimitingTextInputFormatter(250)],
          maxLines: 5,
        )
      ],
    );
  }
}

Future<void> showBudgetMemo(
  context,
  PointerEvent event, {
  required Future<MemoNotesPage> Function() fetchNotes,
  required Function(MemoNoteModel noteModel) onDeleteNote,
  required Function(MemoNoteModel noteModel) onEditNote,
  required Function(String text) onAddNote,
  required Function() onUpdate,
}) async {
  if (event.kind == PointerDeviceKind.mouse &&
      event.buttons == kSecondaryMouseButton) {
    final size = MediaQuery.of(context).size;

    await showMenu(
      context: context,
      position: RelativeRect.fromSize(event.position & Size(48.0, 48.0), size),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          enabled: false,
          child: Theme(
            data: Theme.of(context).copyWith(disabledColor: Colors.transparent),
            child: StatefulBuilder(builder: (context, setState) {
              return FutureBuilder(
                  future: fetchNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      var model = snapshot.data as MemoNotesPage;
                      return Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuItem(
                                padding: EdgeInsets.all(0),
                                height: 16,
                                onTap: onUpdate,
                                child: Icon(Icons.close),
                              ),
                            ]),
                        if (model.canBeAdded)
                          _BudgetMemoItem(
                            onAdd: (String text) async {
                              await onAddNote(text);
                              onUpdate();
                              if (model.notes.isEmpty) {
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  fetchNotes();
                                });
                              }
                            },
                            showPlus: model.notes.isNotEmpty,
                          ),
                        for (var item in model.notes)
                          _BudgetMemoItem(
                            key: Key(item.id),
                            model: BudgetMemoItemModel(
                                noteModel: item,
                                onDelete: (MemoNoteModel item) async {
                                  await onDeleteNote(item);
                                  onUpdate();
                                  //deleting last note, then close menu
                                  if (model.notes.length == 1) {
                                    Navigator.of(context).pop();
                                  } else {
                                    //otherwise show updated
                                    setState(() {
                                      fetchNotes();
                                    });
                                  }
                                },
                                onEdit: (MemoNoteModel item) {
                                  onEditNote(item);
                                  if (model.notes.length == 1) {
                                    Navigator.of(context).pop();
                                  }
                                }),
                          ),
                      ]);
                    } else {
                      return CustomLoadingIndicator(
                        isExpanded: false,
                      );
                    }
                  });
            }),
          ),
        ),
      ],
    );
  }
}

class BudgetMemoItemModel {
  final MemoNoteModel noteModel;
  final Function(MemoNoteModel item) onEdit;
  final Function(MemoNoteModel item) onDelete;

  BudgetMemoItemModel({
    required this.noteModel,
    required this.onEdit,
    required this.onDelete,
  });
}

class _BudgetMemoItem extends StatefulWidget {
  final BudgetMemoItemModel? model;
  final Function(String text)? onAdd;

  final bool showPlus;

  const _BudgetMemoItem(
      {Key? key, this.model, this.onAdd, this.showPlus = false})
      : super(key: key);

  @override
  State<_BudgetMemoItem> createState() => _BudgetMemoItemState();
}

class _BudgetMemoItemState extends State<_BudgetMemoItem> {
  var controller = TextEditingController();

  MemoNoteModel? noteModel;

  var collapsed = false;
  var enabled = false;

  @override
  Widget build(BuildContext context) {
    var buttonItemText = widget.model?.noteModel == null
        ? AppLocalizations.of(context)!.addComment
        : AppLocalizations.of(context)!.saveComment;
    enabled = controller.text.isNotEmpty && controller.text != noteModel?.note;
    assert(widget.onAdd != null || widget.model != null);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (collapsed)
                CustomMaterialInkWell(
                  borderRadius: BorderRadius.circular(12),
                  type: InkWellType.Purple,
                  onTap: () {
                    setState(() {
                      collapsed = false;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.mainDarkBackground,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Label(
                          text: AppLocalizations.of(context)!.addComment,
                          type: LabelType.General,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!collapsed)
                Label(
                  text: noteModel?.isTransaction == true
                      ? AppLocalizations.of(context)!.transactionComment
                      : AppLocalizations.of(context)!.cellComment,
                  type: LabelType.General,
                ),
              if (widget.model != null)
                CustomMaterialInkWell(
                  type: InkWellType.Red,
                  onTap: () {
                    widget.model!.onDelete(noteModel!);
                  },
                  child: ImageIcon(
                    AssetImage('assets/images/icons/delete.png'),
                    color: Theme.of(context).colorScheme.inputErrorBorder,
                    size: 20,
                  ),
                ),
            ],
          ),
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                style: CustomTextStyle.LabelTextStyle(context),
                minLines: 2,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Theme.of(context).colorScheme.inputFill,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inputBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.button,
                    ),
                  ),
                  hintMaxLines: 2,
                  hintText: widget.model?.noteModel.isTransaction == true
                      ? AppLocalizations.of(context)!.addCommentToTransaction
                      : AppLocalizations.of(context)!.addCommentToCell,
                  hintStyle: CustomTextStyle.HintTextStyle(context),
                ),
                onChanged: (_) {
                  setState(() {});
                },
                controller: controller,
                inputFormatters: [LengthLimitingTextInputFormatter(250)],
                maxLines: 5,
              ),
            ),
          if (!collapsed)
            ButtonItem(
              context,
              text: buttonItemText,
              enabled: enabled,
              onPressed: enabled
                  ? () {
                      if (widget.model != null) {
                        noteModel = widget.model!.noteModel
                            .copyWith(note: controller.text);
                        widget.model!.onEdit(noteModel!);
                        setState(() {});
                      } else {
                        widget.onAdd!(controller.text);
                      }
                    }
                  : () {},
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    collapsed = widget.showPlus;
    if (widget.model != null) {
      controller.text = widget.model!.noteModel.note;
      noteModel = widget.model?.noteModel;
    }
  }
}
*/
