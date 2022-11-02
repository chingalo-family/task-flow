import 'package:flutter/foundation.dart';

class SubTaskFormState with ChangeNotifier {
  final Map _formState = {};
  Map _hiddenFields = {};
  Map _hiddenInputFieldOptions = {};
  Map _hiddenSections = {};
  bool _isEditableMode = true;

  Map get formState => _formState;
  Map get hiddenFields => _hiddenFields;
  Map get hiddenSections => _hiddenSections;
  Map get hiddenInputFieldOptions => _hiddenInputFieldOptions;
  bool get isEditableMode => _isEditableMode;

  void resetFormState() {
    _formState.clear();
    _hiddenFields.clear();
    _hiddenSections.clear();
    _hiddenInputFieldOptions.clear();
    notifyListeners();
  }

  void updateFormEditabilityState({bool isEditableMode = true}) {
    _isEditableMode = isEditableMode;
    notifyListeners();
  }

  void setHiddenInputFieldOptions(Map hiddenInputFieldOptions) {
    _hiddenInputFieldOptions = hiddenInputFieldOptions;
    notifyListeners();
  }

  void setHiddenFields(Map hiddenFields) {
    _hiddenFields = hiddenFields;
    notifyListeners();
  }

  void setHiddenSections(Map hiddenSections) {
    _hiddenSections = hiddenSections;
    notifyListeners();
  }

  void setFormFieldState(String id, dynamic value) {
    _formState[id] = value ?? '';
    notifyListeners();
  }

  void removeFieldFromState(String id) {
    _formState.remove(id);
    notifyListeners();
  }
}
