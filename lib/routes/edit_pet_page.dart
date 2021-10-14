import 'package:flutter/material.dart';

class EditPetPage extends StatelessWidget {
  const EditPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: const Text("Editar mascota"),
        )
      ],
    );
  }
}
