import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mi_proyecto/const.dart';
import 'package:mi_proyecto/models_api/pet.dart';

class AdminPetPage extends StatefulWidget {
  const AdminPetPage({Key? key}) : super(key: key);

  @override
  State<AdminPetPage> createState() => _AdminPetPageState();
}

class _AdminPetPageState extends State<AdminPetPage> {
  List<Pet> _pets = [];

  @override
  initState() {
    super.initState;
    _getPets();
  }

  Future<void> _getPets() async {
    final response = await http.get(Uri.parse("${Constants.base_url}api/pets"));

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
    return ListView(
      children: [
        const Divider(height: 15),
        Card(
          margin: const EdgeInsets.all(5),
          child: ListTile(
            title: const Text("Amigo"),
            subtitle: const Text("Edad: 0 años"),
            leading: Image.asset('assets/flutter_logo.png'),
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
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _server() {
    return ListView.builder(itemCount: _pets.length, itemBuilder: list);
  }

  Widget list(context, index) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Text("${_pets[index].name}"),
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
