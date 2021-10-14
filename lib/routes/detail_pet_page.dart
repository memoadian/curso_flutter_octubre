import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPetPage extends StatelessWidget {
  const DetailPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle amigo"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset('assets/flutter_logo.png'),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  "Nombre",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: const Text("Lorem ipsum ammet sit consectetur"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
