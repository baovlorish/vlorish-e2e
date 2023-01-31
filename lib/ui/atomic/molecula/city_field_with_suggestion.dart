import 'dart:async';

import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TextFieldWithSuggestion<T> extends StatefulWidget {
  final T? model;
  final FutureOr<List<T>> Function(String value) search;
  final void Function(dynamic model) onSelectedModel;
  final FocusNode? focusNode;
  final String? label;
  final String? errorMessageEmpty;
  final String? errorMessageInvalid;
  final String hintText;
  final void Function(String?)? onSaved;
  final bool shouldEraseOnFocus;
  final int? maxSymbols;
  final bool? hideOnEmpty;
  final bool unfocusWhenSuggestion;
  final bool enabled;

  const TextFieldWithSuggestion({
    Key? key,
    this.model,
    required this.search,
    required this.onSelectedModel,
    this.focusNode,
    this.maxSymbols,
    this.errorMessageEmpty,
    this.shouldEraseOnFocus = true,
    this.hideOnEmpty,
    this.errorMessageInvalid,
    required this.hintText,
    this.label,
    this.onSaved,
    this.unfocusWhenSuggestion = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  _TextFieldWithSuggestionState createState() =>
      _TextFieldWithSuggestionState();
}

class _TextFieldWithSuggestionState<T> extends State<TextFieldWithSuggestion> {
  final TextEditingController controller = TextEditingController();

  T? selectedModel;
  late var focusNode = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      controller.text = widget.model.toString();
      selectedModel = widget.model;
    }

    focusNode.addListener(() {
      if (widget.onSaved != null) {
        if (!focusNode.hasFocus) {
          widget.onSaved!(controller.text.isNotEmpty ? controller.text : null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Label(
            text: widget.label!,
            type: LabelType.General,
          ),
        if (widget.label != null)
          SizedBox(
            height: 10,
          ),
        TypeAheadFormField<T>(
          enabled: widget.enabled,
          hideOnEmpty: widget.hideOnEmpty ?? false,
          textFieldConfiguration: TextFieldConfiguration(
            enabled: widget.enabled,
            focusNode: focusNode,
            controller: controller,
            onTap: () {
              if (widget.shouldEraseOnFocus) {
                controller.clear();
                selectedModel = null;
              }
            },
            onEditingComplete: () async {
              if (controller.text.length == 2) {
                var searchResult =
                    await widget.search(controller.text) as List<T>;
                if (searchResult.length == 1) {
                  selectedModel = searchResult.first;
                  widget.onSelectedModel(selectedModel!);
                  controller.text = selectedModel.toString();
                  if (widget.unfocusWhenSuggestion) {
                    focusNode.unfocus();
                  }
                }
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxSymbols)
            ],
            style: CustomTextStyle.LabelTextStyle(context),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              fillColor: CustomColorScheme.inputFill,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: CustomColorScheme.button,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: CustomColorScheme.inputErrorBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColorScheme.inputBorder, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorStyle: CustomTextStyle.ErrorTextStyle(context),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColorScheme.inputErrorBorder, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColorScheme.inputBorder, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorMaxLines: 5,
              hintMaxLines: 2,
              hintText: widget.hintText,
            ),
          ),
          hideOnLoading: true,
          suggestionsCallback: (pattern) async {
            return await widget.search(pattern) as List<T>;
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.toString()),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (T suggestion) {
            selectedModel = suggestion;
            widget.onSelectedModel(selectedModel!);
            controller.text = selectedModel.toString();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return widget.errorMessageEmpty;
            } else if (selectedModel == null) {
              return widget.errorMessageInvalid;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
