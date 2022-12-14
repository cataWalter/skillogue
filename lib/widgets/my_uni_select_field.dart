import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class MyUniSelectField extends StatefulWidget {
  final List<String> toShow;
  final String title;
  String label;
  final String hint;
  String curCity;
  final IconData iconData;

  MyUniSelectField(this.toShow, this.title, this.label, this.hint, this.curCity,
      this.iconData,
      {super.key});

  @override
  State<MyUniSelectField> createState() => _MyUniSelectFieldState();
}

class _MyUniSelectFieldState extends State<MyUniSelectField> {
  List<SelectedListItem> listToSelectedItemList() {
    List<SelectedListItem> res = [];
    for (String c in widget.toShow) {
      res.add(SelectedListItem(name: c));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        cursorHeight: 0,
        cursorWidth: 0,
        onTap: () {
          FocusScope.of(context).unfocus();
          DropDownState(
            DropDown(
              bottomSheetTitle: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              submitButtonChild: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              data: listToSelectedItemList(),
              selectedItems: (List<dynamic> selectedList) {
                setState(() {
                  widget.curCity = selectedList[0].name;
                  widget.label = widget.curCity;
                });
              },
              enableMultipleSelection: false,
            ),
          ).showModal(context);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(40.0),
          ),
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromRGBO(235, 235, 235, 1),
          labelText: widget.label,
          labelStyle:
              TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
          hintText: widget.hint,
          hintStyle:
              TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
          filled: true,
          suffixIcon: Icon(widget.iconData),
        ),
      ),
    );
  }
}
