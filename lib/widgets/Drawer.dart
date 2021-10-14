import 'package:flutter/material.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({Key? key}) : super(key: key);

  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
