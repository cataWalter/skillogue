import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "Tom Smith",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Table(
              border: TableBorder.all(color: Colors.black),
              children: [
                getSpacing(),
                getRow("f1", "f2", 0),
                getSpacing(),
                getRowSameCategory(),
                getSpacing(),
                getRowSameCategory(),
                getSpacing(),
                getRowSameCategory(),
                getSpacing(),
                getRow("f1", "f2", 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow getSpacing() {
    return TableRow(children: [
      SizedBox(height: 15), //SizeBox Widget
      SizedBox(height: 15), //SizeBox Widget
      SizedBox(height: 15), //SizeBox Widget
    ]);
  }

  TableRow getRow(String first, String second, int n) {
    return TableRow(
      children: [
        getFirstText(first),
        getSecondText(second),
        getThirdText(n),
      ],
    );
  }

  Text getThirdText(int n) {
    if (n == 0)
      return Text(
        "",
        textAlign: TextAlign.center,
        style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
      );
    String res = '★';
    while (n != 1) {
      res = '$res★';
      n--;
    }
    return Text(
      res,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
    );
  }

  TableRow getRowSameCategory() {
    return TableRow(
      children: [
        getFirstText(""),
        getSecondText("Total Players"),
        getThirdText(3),
      ],
    );
  }

  Text getFirstText(String text) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue));
  }

  Text getSecondText(String text) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white));
  }
}
