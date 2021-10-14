import 'package:flutter/material.dart';

class HomePetPage extends StatelessWidget {
  const HomePetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: const Text("Home Screen"),
        ),
      ],
    );
  }
}
