import 'package:flutter/material.dart';
import 'package:mi_proyecto/routes/add_pet_page.dart';
import 'package:mi_proyecto/routes/admin_pet_page.dart';
import 'package:mi_proyecto/routes/detail_pet_page.dart';
import 'package:mi_proyecto/routes/edit_pet_page.dart';
import 'package:mi_proyecto/routes/home_pet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isOrange = false;
  SharedPreferences? _prefs;

  @override
  initState() {
    super.initState();
    _loadColor();
  }

  _loadColor() async {
    _prefs = await SharedPreferences.getInstance();
    _isOrange = _prefs?.getBool('orange') ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //'home': (context) => const HomePetPage(),
        'add': (context) => const AddPetPage(),
        'admin': (context) => const AdminPetPage(),
        'detail': (context) => const DetailPetPage(),
        'edit': (context) => const EditPetPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: (_isOrange) ? Colors.deepOrange : Colors.green,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Mi primer app"),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.settings),
                ),
              ),
            ],
          ),
          body: const HomePetPage(),
          drawer: Drawer(
            child: ListView(
              children: [
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
                    Navigator.pushNamed(context, 'admin');
                  },
                ),
              ],
            ),
          ),
          endDrawer: Drawer(
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text("Settings"),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SwitchListTile(
                      value: _isOrange,
                      onChanged: (val) => setState(() {
                        _isOrange = val;
                        _prefs?.setBool('orange', val);
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
