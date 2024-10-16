import 'package:flutter/material.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field_option.dart';
import 'package:task_manager/core/constants/app_contant.dart';

class InputField {
  String id;
  String name;
  String? translatedName;
  String? description;
  String? translatedDescription;
  String valueType;
  Color? labelColor;
  Color? inputColor;
  Color? background;
  bool? renderAsRadio;
  bool? isReadOnly;
  int? maxLength;
  bool? isPasswordField;
  bool? shouldCapitalize;
  bool? allowFuturePeriod;
  bool? disablePastPeriod;
  bool? hasError;
  int? minYear;
  int? maxYear;

  // this is an `int` that specifies the minimum number of months that can be captured by the `InputField`
  int? numberOfMonth;
  String? suffixLabel;
  String? prefixLabel;
  String? hint;
  String? translatedHint;
  List<InputFieldOption>? options;
  bool? hasSubInputField;
  InputField? subInputField;
  DateTime? minDate;
  DateTime? maxDate;
  List<int> allowedSelectedLevels;

  bool? disableLocationAutoUpdate;
  InputField({
    required this.id,
    required this.name,
    required this.valueType,
    this.translatedName = '',
    this.description = '',
    this.hint = '',
    this.translatedHint = '',
    this.translatedDescription = '',
    this.prefixLabel = '',
    this.suffixLabel = '',
    this.subInputField,
    this.maxLength,
    this.maxYear,
    this.minYear,
    this.numberOfMonth,
    this.minDate,
    this.maxDate,
    this.inputColor = AppContant.defaultAppColor,
    this.labelColor = const Color(0xFF1A3518),
    this.background = Colors.transparent,
    this.options = const [],
    this.renderAsRadio = false,
    this.isReadOnly = false,
    this.hasSubInputField = false,
    this.isPasswordField = false,
    this.shouldCapitalize = false,
    this.hasError = false,
    this.allowFuturePeriod = false,
    this.disablePastPeriod = false,
    this.allowedSelectedLevels = const [],
    this.disableLocationAutoUpdate = false,
  });

  // `InputField.toString()` is the method to return the `String` representation of the `InputField`
  @override
  String toString() {
    return '$id - $name - $isReadOnly';
  }
}
