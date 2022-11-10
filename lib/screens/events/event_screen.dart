import 'package:flutter/material.dart';
import 'package:skillogue/utils/constants.dart';
class EventWidget extends StatefulWidget {
  const EventWidget({Key? key}) : super(key: key);

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    /*return Column(
      children: [
        SizedBox(height: 100,),
        Scaffold(
          body: Text("You want the moon, right?", style: TextStyle(color: Colors.white, fontSize: 50),)
        ),
      ],
    );*/
    return const Padding(
      padding: EdgeInsets.only(top: 60, left: 30, right: 30),
      child: Text(
        newFunctionalityMessage,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
