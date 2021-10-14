import 'package:flutter/material.dart';
import 'package:mi_proyecto/widgets/Drawer.dart';

class AdminPetPage extends StatefulWidget {
  const AdminPetPage({Key? key}) : super(key: key);

  @override
  State<AdminPetPage> createState() => _AdminPetPageState();
}

class _AdminPetPageState extends State<AdminPetPage> {
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
                IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
