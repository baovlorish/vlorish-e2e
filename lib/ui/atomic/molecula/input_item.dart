import 'package:burgundy_budgeting_app/ui/atomic/atom/hint_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
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
  State<StatefulWidget> createState() => _InputItemState(isPassword);
}

class _InputItemState extends State<InputItem> {
  bool obscureText;

  late final TextEditingController _controller = TextEditingController()
    ..addListener(() {
      if (widget.onValueUpdate != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          var newValue = widget.onValueUpdate!();
          if (newValue != null) {
            _controller.text = newValue;
            _controller.selection =
                TextSelection.collapsed(offset: newValue.length);
          }
          setState(() {});
        });
      }
    });

  _InputItemState(this.obscureText);

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
  }

  void toggleObscure() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  bool get showLabel => widget.labelText != null;

  bool get showTooltip => widget.tooltipText != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Row(
            children: [
              Label(text: widget.labelText!, type: LabelType.General),
              SizedBox(width: 8),
              if (showTooltip) HintWidget(hint: widget.tooltipText!)
            ],
          ),
        if (widget.labelText != null) SizedBox(height: 10),
        TextFormField(
          enabled: widget.enabled,
          keyboardType: widget.textInputType,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          autovalidateMode: widget.autovalidateMode,
          inputFormatters: widget.textInputFormatters ?? [],
          obscureText: obscureText,
          controller: _controller,
          validator: (value) {
            if (widget.validateFunction != null) {
              return widget.validateFunction!(value, context);
            }
          },
          style: widget.enabledTextStyleAnyway
              ? CustomTextStyle.LabelTextStyle(context)
              : widget.enabled
                  ? widget.style ?? CustomTextStyle.LabelTextStyle(context)
                  : CustomTextStyle.HintTextStyle(context),
          minLines: widget.minLines,
          maxLines: obscureText ? 1 : widget.maxLines,
          textInputAction: TextInputAction.next,
          onEditingComplete: widget.onEditingComplete,
          autofillHints: widget.autofillHints,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            setState(() {});
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            fillColor: CustomColorScheme.inputFill,
            filled: true,
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: (widget.prefix != null)
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Label(
                      text: widget.prefix!,
                      type: _controller.text.isNotEmpty
                          ? LabelType.General
                          : LabelType.Hint,
                    ),
                  )
                : null,
            suffixIcon: widget.isPassword
                ? obscureText
                    ? ExcludeFocus(
                        child: IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/icons/trailing.png'),
                            size: 16,
                          ),
                          onPressed: toggleObscure,
                        ),
                      )
                    : ExcludeFocus(
                        child: IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/icons/trailing_open.png'),
                            size: 16,
                          ),
                          onPressed: toggleObscure,
                        ),
                      )
                : widget.suffixIconButton,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColorScheme.inputBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              width: 2.0,
              color: CustomColorScheme.button,
            )),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColorScheme.inputErrorBorder,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0, color: CustomColorScheme.inputErrorBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColorScheme.inputBorder,
              ),
            ),
            errorStyle: CustomTextStyle.ErrorTextStyle(context),
            errorMaxLines: 5,
            errorText: widget.errorText,
            helperText: widget.showErrorText ? null : '',
            hintMaxLines: widget.hintMaxLines,
            hintText: widget.hintText,
            hintStyle: CustomTextStyle.HintTextStyle(context),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
