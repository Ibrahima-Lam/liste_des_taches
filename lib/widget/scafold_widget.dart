import 'package:flutter/material.dart';
import 'package:liste_des_taches/widget/drawer_widget.dart';
import 'package:liste_des_taches/widget/popupmenu_widget.dart';

class ScaffoldWidget extends StatelessWidget {
  final Widget body;
  final Function? onTap;
  const ScaffoldWidget({super.key, required this.body, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text('A'),
          ),
        ),
        title: const Column(
          children: [
            Text(
              'nom',
              style: TextStyle(fontSize: 13),
            ),
            Text(
              'Prenom',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuWidget(
            contxt: context,
            onTap: onTap,
          )
        ],
      ),
      body: body,
      drawer: DrawerWidget(),
    );
  }
}
