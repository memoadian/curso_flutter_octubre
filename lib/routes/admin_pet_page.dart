import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_proyecto/models/fav.dart';
import 'package:mi_proyecto/models/fav_helper.dart';
import 'package:mi_proyecto/models_api/pet.dart';

class AdminPetPage extends StatefulWidget {
  const AdminPetPage({Key? key}) : super(key: key);

  @override
  State<AdminPetPage> createState() => _AdminPetPageState();
}

class _AdminPetPageState extends State<AdminPetPage> {
  List<Pet> _pets = [];
  List<Fav> _favorites = [];

  final _dbHelper = FavHelper();

  @override
  void initState() {
    super.initState();
    _getPets();
    _getFavs();
  }

  void _getFavs() {
    _dbHelper.getAllFavs().then(
          (favs) => {
            for (var fav in favs)
              {
                _favorites.add(
                  Fav.fromMap(fav),
                ),
              },
            setState(() {})
          },
        );
  }

  Future<void> _getPets() async {
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
    return _tabs();
  }

  Widget _tabs() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Administrar mascotas"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Favoritos"),
              Tab(text: "Todos"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _favs(),
            _server(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'add'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _favs() {
    return ListView.builder(
      itemBuilder: _listFavs,
      itemCount: _favorites.length,
    );
  }

  Widget _server() {
    return ListView.builder(
      itemBuilder: _listServer,
      itemCount: _pets.length,
    );
  }

  Widget _listServer(context, index) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Text(_pets[index].name),
        subtitle: Text("Edad: ${_pets[index].age} años"),
        leading: Image.network(_pets[index].image),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'edit');
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _deleteAlert(context, index, _pets[index].id),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listFavs(context, index) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Text(_favorites[index].name),
        subtitle: Text("Edad: ${_favorites[index].age} años"),
        leading: Image.network(_favorites[index].image),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _deleteFav(
                context,
                _favorites[index].id,
                index,
              ),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  _deleteFav(context, id, position) {
    _dbHelper.deleteFav(id).then((fav) => {
          _favorites.removeAt(position),
          setState(() {}),
        });
  }

  Future _deleteAlert(context, position, id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Esta acción no puede deshacerse'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _deletePet(context, position, id);
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePet(context, position, id) {
    String url = "https://pets.memoadian.com/api/pets/$id";
    http.delete(Uri.parse(url)).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error al eliminar el elemento");
      }

      _pets.removeAt(position);
      setState(() {});

      Navigator.of(context).pop();
    });
  }
}
