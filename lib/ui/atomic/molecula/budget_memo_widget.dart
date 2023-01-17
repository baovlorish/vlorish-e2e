import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemoMenuWidget extends StatefulWidget {
  final MemoNotesPage notesPage;
  final bool isCoach;
  final bool isPartner;
  final Future<void> Function(MemoNoteModel note) onDelete;
  final Future<void> Function(String text) onAdd;
  final Future<void> Function(String text, MemoNoteModel note) onReply;
  final Future<void> Function(MemoNoteModel note) onEdit;
  final Future<void> Function(MemoNoteModel note, MemoNoteModel reply)
      onEditReply;
  final Future<void> Function(MemoNoteModel note, String replyId) onDeleteReply;
  final Future<MemoNotesPage> Function() onUpdate;
  final void Function() onClose;
  final bool isTransactionMenu;
  final String userId;
  final String? budgetPartnerId;

  const MemoMenuWidget({
    Key? key,
    required this.notesPage,
    required this.onDelete,
    required this.onAdd,
    required this.onEdit,
    required this.onUpdate,
    required this.onClose,
    required this.onReply,
    required this.isCoach,
    required this.onEditReply,
    required this.onDeleteReply,
    this.isTransactionMenu = false,
    required this.userId,
    required this.isPartner,
    required this.budgetPartnerId,
  }) : super(key: key);

  @override
  State<MemoMenuWidget> createState() => _MemoMenuWidgetState();
}

class _MemoMenuWidgetState extends State<MemoMenuWidget> {
  late MemoNotesPage notesPage;

  var expandedNotes = <String>{};
  var controller = ScrollController();

  @override
  void initState() {
    super.initState();
    notesPage = widget.notesPage;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: CustomColorScheme.tableBorder,
              blurRadius: 5,
            )
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 260,
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CustomMaterialInkWell(
                        type: InkWellType.Grey,
                        onTap: widget.onClose,
                        child: Icon(Icons.close)),
                  ]),
                  for (var item in notesPage.notes)
                    _MemoItem(
                        key: Key(
                            '${item.id}${item.replyIdList}${expandedNotes.contains(item.id)}'),
                        isTransactionMenu: widget.isTransactionMenu,
                        model: MemoItemModel(
                          noteModel: item,
                          isCoach: widget.isCoach,
                          isPartner: widget.isPartner,
                          budgetPartnerId: widget.budgetPartnerId,
                          userId: widget.userId,
                          onDelete: (MemoNoteModel item) async {
                            await widget.onDelete(item);
                            //deleting last note, then close menu
                            if (notesPage.notes.isEmpty ||
                                widget.isTransactionMenu) {
                              widget.onClose();
                            } else {
                              //otherwise show updated
                              notesPage = await widget.onUpdate();
                              setState(() {});
                            }
                          },
                          onReply: (text, note) async {
                            await widget.onReply(text, note);
                            notesPage = await widget.onUpdate();
                            expandedNotes.add(item.id);
                            setState(() {});
                          },
                          onShowMore: () async {
                            notesPage = await widget.onUpdate();
                            expandedNotes.add(item.id);
                            setState(() {});
                            controller.jumpTo(controller.offset + 50);
                          },
                          expanded: expandedNotes.contains(item.id),
                          onEdit: (MemoNoteModel item) {
                            widget.onEdit(item);
                          },
                          onEditReply: (model, reply) async {
                            await widget.onEditReply(model, reply);
                            setState(() {});
                          },
                          onDeleteReply: (model, replyId) async {
                            await widget.onDeleteReply(model, replyId);
                            notesPage = await widget.onUpdate();
                            setState(() {});
                          },
                        ),
                        onOpenReplyField: (int items) {
                          controller
                              .jumpTo(controller.offset + 50 + items * 50);
                        },
                        withDivider: notesPage.notes.indexOf(item) !=
                            notesPage.notes.length - 1,
                        onCancel: () {
                          widget.onClose();
                        }),
                  if (notesPage.canBeAdded)
                    _MemoItem(
                        onAdd: (String text) async {
                          await widget.onAdd(text);
                          notesPage = await widget.onUpdate();
                          setState(() {});
                        },
                        isTransactionMenu: widget.isTransactionMenu,
                        showPlus: notesPage.notes.isNotEmpty,
                        onCancel: () {
                          widget.onClose();
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MemoItemModel {
  final MemoNoteModel noteModel;
  final Function(MemoNoteModel item) onEdit;
  final Function(MemoNoteModel item) onDelete;
  final Function(String text, MemoNoteModel item)? onReply;
  final Function(MemoNoteModel note, MemoNoteModel reply)? onEditReply;
  final Function(MemoNoteModel note, String replyId)? onDeleteReply;
  final Future<void> Function()? onShowMore;
  final bool expanded;
  final bool isCoach;
  final String userId;
  final bool isPartner;
  final String? budgetPartnerId;

  MemoItemModel({
    required this.noteModel,
    required this.onEdit,
    required this.onDelete,
    required this.isCoach,
    this.onReply,
    this.onEditReply,
    this.onDeleteReply,
    this.onShowMore,
    this.expanded = false,
    required this.userId,
    required this.isPartner,
    required this.budgetPartnerId,
  });
}

class _MemoItem extends StatefulWidget {
  final MemoItemModel? model;
  final Function(String text)? onAdd;
  final Function(String text, MemoNoteModel item)? onReply;
  final void Function() onCancel;
  final bool isTransactionMenu;
  final bool showPlus;
  final bool withDivider;

  final MemoNoteModel? parentNote;

  final void Function(int replies)? onOpenReplyField;

  const _MemoItem({
    Key? key,
    this.model,
    this.onAdd,
    this.onReply,
    required this.isTransactionMenu,
    this.parentNote,
    this.showPlus = false,
    this.withDivider = false,
    this.onOpenReplyField,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<_MemoItem> createState() => _MemoItemState();
}

class _MemoItemState extends State<_MemoItem> {
  var controller = TextEditingController();
  var node = FocusNode();

  MemoNoteModel? noteModel;
  var isReplyFormOpen = false;
  var collapsed = false;
  var enabled = false;
  late bool isReply = widget.parentNote != null;
  late String hintText = isReply
      ? AppLocalizations.of(context)!.addReply
      : (widget.model?.noteModel.isTransaction == true ||
              widget.isTransactionMenu)
          ? AppLocalizations.of(context)!.addCommentToTransaction
          : AppLocalizations.of(context)!.addCommentToCell;

  //coach can delete only their own memo
  //partner or primary can't delete each others memos,
  // but can delete their own and coaches
  late var canDelete = widget.model?.isCoach == true
      ? widget.model?.userId == widget.model?.noteModel.authorUserId
      : widget.model?.noteModel.authorUserId != widget.model?.budgetPartnerId;

  //anyone can edit only their own memo
  late var canEdit =
      widget.model?.userId == widget.model?.noteModel.authorUserId;
  var submittedIsCompleted = true;
  @override
  Widget build(BuildContext context) {
    var buttonItemText = widget.model?.noteModel == null
        ? AppLocalizations.of(context)!.addComment
        : AppLocalizations.of(context)!.saveComment;

    var visibleReplies = getVisibleReplies();
    enabled = controller.text.isNotEmpty &&
        controller.text != noteModel?.note &&
        submittedIsCompleted;
    return Column(
      key: Key(
          '${noteModel?.id}${widget.parentNote?.id}$isReplyFormOpen${noteModel?.replies.length}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.model != null)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: AvatarWidget(
                  imageUrl: widget.model!.noteModel.authorImageUrl,
                  initials: widget.model!.noteModel.initials,
                  size: 36,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: '${widget.model!.noteModel.authorFirstName ?? ''} '
                          '${widget.model!.noteModel.authorLastName ?? ''}',
                      type: LabelType.General,
                    ),
                    if (widget.model!.noteModel.creationDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Label(
                            text: CustomDateFormats.timeAndDay(widget
                                .model!.noteModel.creationDate!
                                .toLocal()),
                            type: LabelType.HintSmall),
                      ),
                  ],
                ),
              ),
              if (canDelete)
                CustomMaterialInkWell(
                  type: InkWellType.Red,
                  onTap: () {
                    if (isReply) {
                      widget.model!.onDeleteReply!(
                          widget.parentNote!, noteModel!.id);
                    } else {
                      widget.model!.onDelete(noteModel!);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: ImageIcon(
                      AssetImage('assets/images/icons/delete.png'),
                      color: CustomColorScheme.inputErrorBorder,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!collapsed && !isReply)
              Padding(
                padding: const EdgeInsets.only(top: 14.0, left: 2),
                child: Label(
                  text: noteModel?.isTransaction == true ||
                          widget.isTransactionMenu
                      ? AppLocalizations.of(context)!.transactionComment
                      : AppLocalizations.of(context)!.cellComment,
                  type: LabelType.GeneralBold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        if (!collapsed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              focusNode: node,
              enabled: canEdit,
              keyboardType: TextInputType.text,
              style: CustomTextStyle.LabelTextStyle(context)
                  .copyWith(fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                fillColor: CustomColorScheme.inputFill,
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: CustomColorScheme.button,
                  ),
                ),
                hintText: hintText,
                hintStyle: CustomTextStyle.HintTextStyle(context)
                    .copyWith(fontSize: 14),
              ),
              onTap: () {
                setState(() {});
              },
              onChanged: (_) {
                setState(() {});
              },
              onSubmitted: (value) async {
                if (value.isNotEmpty && enabled) {
                  enabled = false;
                  setState(() {});
                  onSubmitted(value);
                }
              },
              controller: controller,
              inputFormatters: [LengthLimitingTextInputFormatter(250)],
            ),
          ),
        if ((!collapsed && widget.model == null) ||
            (!collapsed && widget.model != null && node.hasFocus && canEdit))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ButtonItem(
                  context,
                  text: AppLocalizations.of(context)!.cancel,
                  buttonType: ButtonType.White,
                  isSmallButton: true,
                  onPressed: () {
                    if (widget.model == null) {
                      widget.onCancel();
                    } else {
                      controller.text = widget.model!.noteModel.note;
                      node.unfocus();
                      setState(() {});
                    }
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: ButtonItem(
                  context,
                  text: buttonItemText,
                  enabled: enabled,
                  isSmallButton: true,
                  onPressed: enabled
                      ? () {
                          enabled = false;
                          setState(() {});
                          onSubmitted(controller.text);
                        }
                      : () {},
                ),
              ),
            ],
          ),
        if (!collapsed && widget.model?.noteModel.canAddReply == true)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: CustomMaterialInkWell(
              borderRadius: BorderRadius.circular(12),
              type: InkWellType.Purple,
              onTap: () {
                isReplyFormOpen = true;
                setState(() {});
                widget.onOpenReplyField!(visibleReplies?.length ?? 0);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/icons/reply.png',
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Label(
                      text: AppLocalizations.of(context)!.reply,
                      type: LabelType.GeneralBold,
                      color: CustomColorScheme.mainDarkBackground,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!collapsed && (visibleReplies != null || isReplyFormOpen))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: CustomDivider(),
          ),
        if (!collapsed && visibleReplies != null)
          for (var item in visibleReplies)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: _MemoItem(
                model: MemoItemModel(
                  noteModel: item,
                  userId: widget.model!.userId,
                  budgetPartnerId: widget.model!.budgetPartnerId,
                  isCoach: widget.model!.isCoach,
                  onEditReply: widget.model!.onEditReply,
                  onDeleteReply: widget.model!.onDeleteReply,
                  onDelete: (_) {},
                  onEdit: (_) {},
                  isPartner: widget.model!.isPartner,
                ),
                isTransactionMenu: widget.isTransactionMenu,
                parentNote: widget.model!.noteModel,
                withDivider:
                    visibleReplies.indexOf(item) != visibleReplies.length - 1,
                onCancel: () {
                  widget.onCancel();
                },
              ),
            ),
        if (noteModel?.canShowMore == true &&
            widget.model?.expanded == false &&
            widget.model?.onShowMore != null)
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 4, bottom: 4),
            child: CustomMaterialInkWell(
              borderRadius: BorderRadius.circular(12),
              type: InkWellType.Purple,
              onTap: () {
                widget.model!.onShowMore!();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Label(
                  text: AppLocalizations.of(context)!.showMore,
                  type: LabelType.Link,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        if (isReplyFormOpen)
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: _MemoItem(
              onReply: (text, model) {
                isReplyFormOpen = false;
                widget.model!.onReply!(text, model);
              },
              isTransactionMenu: widget.isTransactionMenu,
              parentNote: widget.model!.noteModel,
              onCancel: () {
                widget.onCancel();
              },
            ),
          ),
        if (!collapsed && widget.withDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: CustomDivider(),
          ),
        if (collapsed)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomDivider(),
              ),
              CustomMaterialInkWell(
                borderRadius: BorderRadius.circular(12),
                type: InkWellType.Purple,
                onTap: () {
                  setState(() {
                    collapsed = false;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: CustomColorScheme.mainDarkBackground,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.addComment,
                        type: LabelType.GeneralBold,
                        color: CustomColorScheme.mainDarkBackground,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  void onSubmitted(String value) {
    submittedIsCompleted = false;
    if (!isReply) {
      if (widget.model != null) {
        //edit note
        noteModel = widget.model!.noteModel.copyWith(note: value);
        widget.model!.onEdit(noteModel!);
        node.unfocus();
        setState(() {});
      } else {
        if (widget.onAdd != null) {
          //add note
          node.unfocus();
          widget.onAdd!(value);
        }
      }
    } else {
      if (widget.model == null) {
        assert(widget.onReply != null);
        //add reply
        widget.onReply!(value, widget.parentNote!);
      } else {
        //edit reply
        assert(widget.model!.onEditReply != null);
        node.unfocus();
        noteModel = widget.model!.noteModel.copyWith(note: value);
        widget.model!.onEditReply!(widget.parentNote!, noteModel!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    collapsed = widget.showPlus;
    if (widget.model != null) {
      controller.text = widget.model!.noteModel.note;
      noteModel = widget.model?.noteModel;
    } else {
      node.requestFocus();
    }
  }

  List<MemoNoteModel>? getVisibleReplies() {
    if (noteModel == null || noteModel?.replies.isEmpty == true) {
      return null;
    } else if (!widget.model!.expanded) {
      return [noteModel!.replies.first];
    } else {
      return noteModel!.replies;
    }
  }
}
