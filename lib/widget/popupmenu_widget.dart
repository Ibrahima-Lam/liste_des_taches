import 'package:flutter/material.dart';
import 'package:liste_des_taches/form_page.dart';
import 'package:liste_des_taches/liste.dart';

// ignore: must_be_immutable
class PopupMenuWidget extends StatelessWidget {
  BuildContext contxt;
  PopupMenuWidget({super.key, required this.contxt}) {
    // TODO: implement PopupMenuWidget
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(Icons.menu),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Liste des Taches'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListePage()));
                },
              ),
              PopupMenuItem(
                child: Text('Ajouter une Tache'),
                onTap: () async {
                  await Navigator.of(contxt)
                      .push(MaterialPageRoute(builder: (contxt) => FormPage()));
                },
              ),
            ]);
  }
}
