import 'package:task_manager/core/components/entry_input_fields/models/input_field.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_contant.dart';

// `SearchInput` is the widget for a search input
class SearchInput extends StatefulWidget {
  // a callback `Function` called on searching
  final Function? onSearch;

  //  `String` placeholder for the search input
  final String? placeHolder;

  // `Color` for the search input borders, placeholder and icons
  final Color? color;

  //
  // is a default constructor for `SearchInput`
  //  the constructor accepts a callback `Function` called on searching, `Color` for the search input and `String` placeholder
  //
  const SearchInput({
    super.key,
    this.onSearch,
    this.placeHolder = 'Search',
    this.color = AppContant.defaultAppColor,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _searchController = TextEditingController();
  bool canClear = false;

  final InputField inputField = InputField(
    id: 'search',
    name: '',
    valueType: 'TEXT',
  );

  void updateClearState(status) {
    setState(() {
      canClear = status;
    });
  }

  void onSearchInputValueChange(String searchedValue) {
    if (searchedValue.isNotEmpty) {
      updateClearState(true);
    } else {
      updateClearState(false);
    }
    widget.onSearch!(searchedValue);
  }

  void onClearSearchInput() {
    _searchController.clear();
    widget.onSearch!('');
    updateClearState(false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: TextField(
          autofocus: false,
          controller: _searchController,
          onChanged: onSearchInputValueChange,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.color!,
                width: 1.0,
              ),
            ),
            hintText: widget.placeHolder,
            prefixIcon: Icon(
              Icons.search,
              color: widget.color,
            ),
            suffixIcon: Visibility(
              visible: canClear,
              child: IconButton(
                onPressed: onClearSearchInput,
                icon: Icon(
                  Icons.clear,
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
