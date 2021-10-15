import 'package:flutter/material.dart';
import 'package:mi_proyecto/models_api/pet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PetsList extends StatefulWidget {
  const PetsList({Key? key}) : super(key: key);

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  List<Pet> _pets = [];

  @override
  initState() {
    super.initState();
    _getPets();
  }

  Future<Null> _getPets() async {
    const String url = "https://pets.memoadian.com/api/pets";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      Iterable list = result["data"];
      setState(() {
        _pets = list.map((model) => Pet.fromJson(model)).toList();
      });
    } else {
      throw Exception("Fallo al cargar datos del servidor");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _pets.length,
      itemBuilder: _buildItemsForListView,
    );
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(_pets[index].image),
            const Text("Este es el contenido de mi card"),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Ver detalle"),
            ),
          ],
        ),
      ),
    );
  }
}
