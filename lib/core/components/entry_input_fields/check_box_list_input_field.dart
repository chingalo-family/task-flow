import 'package:flutter/material.dart';
import 'package:task_manager/core/components/entry_input_fields/check_box_input_field_container.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field_option.dart';

class CheckBoxListInputField extends StatefulWidget {
  final InputField inputField;
  final Map dataObject;
  final Function? onInputValueChange;
  final bool isReadOnly;

  const CheckBoxListInputField({
    super.key,
    required this.inputField,
    required this.dataObject,
    this.isReadOnly = false,
    this.onInputValueChange,
  });

  @override
  State<CheckBoxListInputField> createState() => _CheckBoxListInputFieldState();
}

class _CheckBoxListInputFieldState extends State<CheckBoxListInputField> {
  final Map _inputValue = {};

  @override
  void initState() {
    super.initState();
    updateInputValueState();
  }

  updateInputValueState() {
    for (InputFieldOption option in widget.inputField.options!) {
      _inputValue[option.code] = widget.dataObject[option.code] ?? false;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant CheckBoxListInputField oldWidget) {
    super.didUpdateWidget(widget);
    if (oldWidget.dataObject != widget.dataObject) updateInputValueState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.inputField.options!
            .map(
              (InputFieldOption option) => CheckBoxInputFieldContainer(
                isReadOnly: widget.isReadOnly,
                label: option.name,
                value: widget.dataObject[option.code],
                color: widget.inputField.inputColor,
                onInputValueChange: (dynamic value) =>
                    widget.onInputValueChange!(option.code, '$value'),
              ),
            )
            .toList(),
      ),
    );
  }
}
