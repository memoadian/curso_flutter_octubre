import 'package:flutter/material.dart';
import 'package:mi_proyecto/routes/add_pet_page.dart';
import 'package:mi_proyecto/routes/admin_pet_page.dart';
import 'package:mi_proyecto/routes/detail_pet_page.dart';
import 'package:mi_proyecto/routes/edit_pet_page.dart';
import 'package:mi_proyecto/routes/home_pet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_notification/push_notification.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isOrange = false;
  SharedPreferences? prefs;
  late Notificator notification;
  String _bodyText = 'notification test';
  String notificationKey = 'key';

  @override
  void initState() {
    super.initState();
    _loadColor();
    notification = Notificator(
      onPermissionDecline: () {
        // ignore: avoid_print
        print('permission decline');
      },
      onNotificationTapCallback: (notificationData) {
        setState(
          () {
            _bodyText = 'notification open: '
                '${notificationData[notificationKey].toString()}';
          },
        );
      },
    )..requestPermissions(
        requestSoundPermission: true,
        requestAlertPermission: true,
      );
  }

  void _loadColor() async {
    prefs = await SharedPreferences.getInstance();
    _isOrange = (prefs?.getBool('orange')) ?? false;
    setState(() {});
  }

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
        primarySwatch: (_isOrange) ? Colors.orange : Colors.green,
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
                      title: const Text("Tema naranja"),
                      value: _isOrange,
                      onChanged: (val) {
                        _isOrange = val;
                        prefs?.setBool('orange', val);
                        setState(() {});
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              notification.show(
                1,
                'hello',
                'this is test',
                imageUrl: 'https://www.lumico.io/wp-019/09/flutter.jpg',
                data: {notificationKey: '[notification data]'},
                notificationSpecifics: NotificationSpecifics(
                  AndroidNotificationSpecifics(
                    autoCancelable: true,
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
