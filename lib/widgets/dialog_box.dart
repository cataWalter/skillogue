import 'package:flutter/material.dart';
import 'package:skillogue/entities/search_entity.dart';
import 'package:skillogue/utils/constants.dart';
import 'package:skillogue/widgets/checkkie.dart';

class DialogBox extends StatelessWidget {
  Search curSearch;


  DialogBox(this.curSearch, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[800],
      content: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: skills.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: MyCheckBox(skills[index], curSearch),
            );
          },
        ),
      ),
    );
  }


}
