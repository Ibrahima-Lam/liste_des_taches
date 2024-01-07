import 'package:flutter/material.dart';
import 'package:liste_des_taches/service/storage_sevice.dart';

// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String email = 'Email';
  Future<void> _getUserFromStorage() async {
    final Map<String, String?> data = await StorageService().getData();
    email = data['email']!;
  }

  @override
  void initState() {
    super.initState();
    StorageService().getData().then((value) {
      email = value['email']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              accountName: const Text("Prenom Nom"),
              accountEmail: Text(email),
              currentAccountPictureSize: const Size.square(50),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text('A'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Deconnexion'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
