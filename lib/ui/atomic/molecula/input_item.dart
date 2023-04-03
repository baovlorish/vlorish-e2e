import 'package:burgundy_budgeting_app/ui/atomic/atom/hint_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/input_decoration_mixin.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class InputItem extends StatefulWidget {
  @override
  final Key? key;
  final String? labelText;
  final String hintText;
  final int hintMaxLines;
  final bool isPassword;
  final String? Function(String?, BuildContext context)? validateFunction;
  final void Function(String)? onChanged;
  final String? value;
  final String? prefix;
  final String? errorText;
  final int maxLines;
  final int minLines;
  final List<TextInputFormatter>? textInputFormatters;
  final FocusNode? focusNode;
  final bool showErrorText;
  final void Function()? onEditingComplete;
  final bool autofocus;
  final List<String>? autofillHints;
  final IconButton? suffixIconButton;
  final TextInputType? textInputType;

  final AutovalidateMode? autovalidateMode;

  final TextStyle? style;

  final Function? onValueUpdate;
  final bool enabledTextStyleAnyway;
  final bool enabled;
  final String? tooltipText;

  InputItem({
    this.labelText,
    this.isPassword = false,
    this.hintText = '',
    this.hintMaxLines = 1,
    this.validateFunction,
    this.onChanged,
    this.value,
    this.key,
    this.errorText,
    this.prefix,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputFormatters,
    this.focusNode,
    this.showErrorText = true,
    this.onEditingComplete,
    this.autofocus = false,
    this.autofillHints,
    this.suffixIconButton,
    this.autovalidateMode,
    this.style,
    this.textInputType,
    this.onValueUpdate,
    this.enabled = true,
    this.enabledTextStyleAnyway = false,
    this.tooltipText,
  }) : super(key: key ?? UniqueKey());

  @override
  State<StatefulWidget> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> with InputDecorationMixin {
  late var obscureText = widget.isPassword;

  late final focusNode = widget.focusNode ?? FocusNode();

  late final TextEditingController _controller = TextEditingController()
    ..addListener(() {
      if (widget.onValueUpdate != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              var newValue = widget.onValueUpdate!();
              if (newValue != null) {
                _controller.text = newValue;
                _controller.selection = TextSelection.collapsed(offset: newValue.length);
              }
            }));
      }
    });

  @override
  void initState() {
    super.initState();
    if (widget.value != null) _controller.text = widget.value!;
  }

  void toggleObscure() => setState(() => obscureText = !obscureText);

  bool get showLabel => widget.labelText != null;

  bool get showTooltip => widget.tooltipText != null;

  // added to fix setState() or markNeedsBuild called during build
  // setState() or markNeedsBuild called during build
  Future<bool> rebuild() async {
    if (!mounted) return false;

    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }

    setState(() {});
    return true;
  }

  // todo: (andreyK) make sure that this is needed
  void checkValidation() async {
    await rebuild();
    setState(() {
      final noError = widget.validateFunction?.call(_controller.text, context) == null;
      final hasText = _controller.text.isNotEmpty;
      isValid = !isHovered && noError && hasText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Row(
              children: [
                Label(text: widget.labelText!, type: LabelType.GeneralNew),
                SizedBox(width: 8),
                if (showTooltip) HintWidget(hint: widget.tooltipText!)
              ],
            ),
          if (widget.labelText != null) SizedBox(height: 10),
          Focus(
            onFocusChange: (isFocused) => isHovered = isFocused,
            child: TextFormField(
              enabled: widget.enabled,
              keyboardType: widget.textInputType,
              autofocus: widget.autofocus,
              focusNode: focusNode,
              autovalidateMode: widget.autovalidateMode,
              inputFormatters: widget.textInputFormatters ?? [],
              obscureText: obscureText,
              controller: _controller,
              validator: (value) {
                checkValidation();
                if (widget.errorText != null) return widget.errorText;
                return widget.validateFunction?.call(value, context);
              },
              style: widget.enabledTextStyleAnyway
                  ? CustomTextStyle.LabelTextStyle(context)
                  : widget.enabled
                      ? widget.style ?? CustomTextStyle.LabelTextStyle(context)
                      : CustomTextStyle.HintTextStyle(context),
              minLines: widget.minLines,
              maxLines: obscureText ? 1 : widget.maxLines,
              textInputAction: TextInputAction.next,
              onTapOutside: (_) {
                focusNode.unfocus();
                checkValidation();
              },
              onFieldSubmitted: (_) => checkValidation(),
              onSaved: (_) => checkValidation(),
              onEditingComplete: () {
                checkValidation();
                widget.onEditingComplete?.call();
              },
              autofillHints: widget.autofillHints,
              onChanged: (value) => setState(() => widget.onChanged?.call(value)),
              decoration: InputDecoration(
                contentPadding: InputDecorationMixin.contentPadding,
                fillColor: fillColor,
                filled: true,
                prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIcon: widget.prefix == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Label(
                          text: widget.prefix!,
                          type: _controller.text.isNotEmpty ? LabelType.General : LabelType.Hint,
                        ),
                      ),
                suffixIcon: !widget.isPassword
                    ? widget.suffixIconButton
                    : ExcludeFocus(
                        child: IconButton(
                          onPressed: toggleObscure,
                          icon: ImageIcon(
                            size: 16,
                            AssetImage(
                              obscureText
                                  ? 'assets/images/icons/trailing.png'
                                  : 'assets/images/icons/trailing_open.png',
                            ),
                          ),
                        ),
                      ),
                focusColor: focusColor,
                hoverColor: focusColor,
                border: border,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
                focusedErrorBorder: focusedErrorBorder,
                errorStyle: errorStyle(context),
                errorMaxLines: 5,
                errorText: widget.errorText,
                helperText: widget.showErrorText ? null : '',
                hintMaxLines: widget.hintMaxLines,
                hintText: widget.hintText,
                hintStyle: hintStyle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
