import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_proyecto/models_api/pet.dart';

class DetailPetPage extends StatelessWidget {
  const DetailPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;

    Future<Pet> _getPet() async {
      final response = await http
          .get(Uri.parse('https://pets.memoadian.com/api/pets/${args['id']}'));

      if (response.statusCode == 200) {
        return Pet.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load pet');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle amigo"),
      ),
      body: FutureBuilder<Pet>(
        future: _getPet(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.network(snapshot.data!.image),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        snapshot.data!.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(snapshot.data!.desc),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
