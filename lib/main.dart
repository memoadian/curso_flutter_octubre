import 'package:flutter/material.dart';
import 'package:mi_proyecto/routes/add_pet_page.dart';
import 'package:mi_proyecto/routes/admin_pet_page.dart';
import 'package:mi_proyecto/routes/detail_pet_page.dart';
import 'package:mi_proyecto/routes/edit_pet_page.dart';
import 'package:mi_proyecto/routes/home_pet_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'add': (context) => const AddPetPage(),
        'admin': (context) => const AdminPetPage(),
        'detail': (context) => const DetailPetPage(),
        'edit': (context) => const EditPetPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Mi primer app"),
          ),
          body: const HomePetPage(),
          drawer: Drawer(
            child: ListView(
              children: [
                /*DrawerHeader(
                  child: CircleAvatar(
                    child: Text("Algo"),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/flutter_logo.png"),
                    ),
                  ),
                ),*/
                const UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("assets/flutter_logo.png"),
                  ),
                  accountName: Text("memoadian"),
                  accountEmail: Text("memoadian@gmail.com"),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Inicio"),
                  subtitle: const Text("Descripcion de lo que hace"),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text("Administrar"),
                  subtitle: const Text("Admin pets"),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPetPage(),
                      ),
                    );*/
                    Navigator.pushNamed(context, 'admin');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
