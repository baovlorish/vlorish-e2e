import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class TransactionMemoMenu extends StatefulWidget {
  final String? initialValue;
  final DateTime? initialValueDate;
  final Future<void> Function(String newNote) onSave;
  final Future<void> Function() onDelete;
  final void Function() onClose;

  const TransactionMemoMenu(
      {Key? key,
        this.initialValue,
        this.initialValueDate,
        required this.onSave,
        required this.onDelete,
        required this.onClose,
      })
      : super(key: key);

  @override
  State<TransactionMemoMenu> createState() => _TransactionMemoMenuState();
}

class _TransactionMemoMenuState extends State<TransactionMemoMenu> {
  late TextEditingController controller;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    if (widget.initialValue != null) controller.text = widget.initialValue!;
    validate();
  }

 bool validate(){
    if (widget.initialValue != null) {
      enabled =
          controller.text.isNotEmpty && controller.text != widget.initialValue!;
    } else {
      enabled = controller.text.isNotEmpty;
    }
    return enabled;
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomMaterialInkWell(
                    type: InkWellType.Grey,
                    onTap: widget.onClose,
                    child: Icon(Icons.close)),
              ],),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: AppLocalizations.of(context)!.transactionComment,
                      type: LabelType.General,
                    ),
                    if(widget.initialValue != null)
                    CustomMaterialInkWell(
                      type: InkWellType.Red,
                      onTap: () async {
                        await widget.onDelete();
                      },
                      child: ImageIcon(
                        AssetImage('assets/images/icons/delete.png'),
                        color: CustomColorScheme.inputErrorBorder,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.initialValueDate != null)
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Label(
                        text: CustomDateFormats.timeAndDay(
                            widget.initialValueDate!.toLocal()),
                        type: LabelType.HintSmall,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  style: CustomTextStyle.LabelTextStyle(context),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    fillColor: CustomColorScheme.inputFill,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: CustomColorScheme.button,
                      ),
                    ),
                    hintText: AppLocalizations.of(context)!.addComment,
                    hintStyle: CustomTextStyle.HintTextStyle(context),
                  ),
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await widget.onSave(value);
                    }
                  },
                  controller: controller,
                  inputFormatters: [LengthLimitingTextInputFormatter(250)],
                  onChanged: (_){
                    setState(() {
                      validate();
                    });
                  },
                ),
              ),
              ButtonItem(
                context,
                enabled: enabled,
                onPressed: enabled ? () async {
                  if (controller.text.isNotEmpty) {
                    await widget.onSave(controller.text);
                  }
                }:(){},
                text: controller.text.isNotEmpty
                    ? AppLocalizations.of(context)!.saveComment
                    : AppLocalizations.of(context)!.addComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}