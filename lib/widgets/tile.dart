import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  String title;
  String subtitle;
  Color color;
  Color gradient;

  Tile(
      {super.key,
      required this.title,
      required this.color,
      required this.gradient,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: GestureDetector(
        onTap: () {},
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          Card(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      gradient: LinearGradient(
                          colors: [color, gradient],
                          begin: Alignment.topCenter,
                          end: Alignment.topRight)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(title),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          subtitle,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ))),
        ]),
      ),
    );
  }
}
