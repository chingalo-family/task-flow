import 'package:flutter/material.dart';
import 'package:task_manager/core/components/input_fields/input_checked_icon.dart';
import 'package:task_manager/models/input_field.dart';

class PhoneNumberInputFieldContainer extends StatefulWidget {
  const PhoneNumberInputFieldContainer(
      {Key? key,
      required this.inputField,
      required this.onInputValueChange,
      this.inputValue})
      : super(key: key);

  final InputField inputField;
  final Function onInputValueChange;
  final String? inputValue;

  @override
  _PhoneNumberInputFieldContainerState createState() =>
      _PhoneNumberInputFieldContainerState();
}

class _PhoneNumberInputFieldContainerState
    extends State<PhoneNumberInputFieldContainer> {
  TextEditingController? phoneNumberController;
  String? _value;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.inputValue;
    });
    phoneNumberController = TextEditingController(text: widget.inputValue);
  }

  void onValueChange(String value) {
    // @TODO handling error messages
    setState(() {
      _value = value;
    });
    widget.onInputValueChange(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: widget.inputField.isReadOnly!,
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              onChanged: onValueChange,
              style: const TextStyle().copyWith(
                color: widget.inputField.inputColor,
              ),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorText: null,
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 20.0,
                  minHeight: 20.0,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputCheckedIcon(
                      showTickedIcon: _value != null && '$_value'.trim() != '',
                      color: widget.inputField.inputColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
