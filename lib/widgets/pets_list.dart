import 'package:flutter/material.dart';
import 'package:mi_proyecto/models/fav.dart';
import 'package:mi_proyecto/models/fav_helper.dart';
import 'package:mi_proyecto/models_api/pet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_proyecto/routes/detail_pet_page.dart';
import 'package:toast/toast.dart';

class PetsList extends StatefulWidget {
  const PetsList({Key? key}) : super(key: key);

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  final _dbHelper = FavHelper();
  List<Pet> _pets = [];

  @override
  initState() {
    super.initState();
    _getPets();
  }

  void _insert(String name, int age, String image) async {
    _dbHelper.saveFav(Fav(name, age.toString(), image)).then(
          (_) => {
            Toast.show(
              "Amigo agregado a favoritos",
              context,
            ),
          },
        );
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
      cacheExtent: 9999,
      physics: const AlwaysScrollableScrollPhysics(),
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
            Text(_pets[index].name),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    'detail',
                    arguments: {
                      "id": _pets[index].id,
                    },
                  ),
                  child: const Text("Ver detalle"),
                ),
                IconButton(
                  onPressed: () => {
                    _insert(
                      _pets[index].name,
                      _pets[index].age,
                      _pets[index].image,
                    )
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Color(0xFF7f710b),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
