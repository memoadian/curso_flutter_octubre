import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mi_proyecto/models_api/pet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPetPage extends StatelessWidget {
  const DetailPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;

    Future<Pet> _fetchPet() async {
      final response = await http
          .get(Uri.parse('https://pets.memoadian.com/api/pets/${args['id']}'));

      if (response.statusCode == 200) {
        return Pet.fromJson(json.decode(response.body));
      } else {
        throw Exception('Fallo al cargar la mascota');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle amigo"),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<Pet>(
        future: _fetchPet(),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Cargando..."),
                ),
                const CircularProgressIndicator(),
              ],
            ),
          );
        },
      )),
    );
  }
}
