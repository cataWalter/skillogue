import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class MultiDropdown extends StatefulWidget {
  final List<String> allValues;

  final String question;
  final String title;
  final List<String> initialValues;
  final IconData iconData;
  final Function(List<String>) setValues;

  const MultiDropdown(this.allValues, this.question, this.title, this.initialValues,
      this.iconData, this.setValues,
      {super.key});

  @override
  State<MultiDropdown> createState() => _MultiDropdownState();
}

class _MultiDropdownState extends State<MultiDropdown> {
  late List<String> selectedValues = widget.initialValues;

  @override
  Widget build(BuildContext context) {
    return MultiSelectBottomSheetField(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color.fromRGBO(235, 235, 235, 1),
      ),
      initialChildSize: 0.4,
      initialValue: widget.initialValues,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText: Text(
        widget.question,
        style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
      ),
      title: Text(widget.title),
      buttonIcon: Icon(widget.iconData),
      searchIcon: const Icon(
        Icons.search,
      ),
      items: widget.allValues.map((s) => MultiSelectItem(s, s)).toList(),
      onConfirm: (values) {
        selectedValues = values.map((e) => e.toString()).toList();
        widget.setValues(selectedValues);
      },
      chipDisplay: MultiSelectChipDisplay(
        chipColor: Colors.blue,
        textStyle: const TextStyle(color: Colors.white),
        onTap: (value) {
          setState(() {
            selectedValues.remove(value.toString());
          });
          widget.setValues(selectedValues);
        },
      ),
    );
  }
}
