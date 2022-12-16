import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class MyMultiSelectField extends StatefulWidget {
  List<String> allValues;
  List<String> curValues;

  String question;
  String title;
  List<String> selectedValues;
  IconData iconData;

  MyMultiSelectField(this.allValues, this.curValues, this.question, this.title,
      this.selectedValues, this.iconData, {super.key});

  @override
  State<MyMultiSelectField> createState() => _MyMultiSelectFieldState();
}

class _MyMultiSelectFieldState extends State<MyMultiSelectField> {
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
      initialValue: widget.curValues,
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
        widget.selectedValues = values.map((e) => e.toString()).toList();
      },
      chipDisplay: MultiSelectChipDisplay(
        chipColor: Colors.blue,
        textStyle: const TextStyle(color: Colors.white),
        onTap: (value) {
          setState(() {
            widget.selectedValues.remove(value.toString());
          });
        },
      ),
    );
  }
}
