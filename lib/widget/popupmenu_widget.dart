import 'package:flutter/material.dart';
import 'package:liste_des_taches/form_page.dart';
import 'package:liste_des_taches/liste.dart';

import 'package:liste_des_taches/service/storage_sevice.dart';

// ignore: must_be_immutable
class PopupMenuWidget extends StatelessWidget {
  BuildContext contxt;
  final Function? onTap;
  PopupMenuWidget({super.key, required this.contxt, this.onTap});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(Icons.menu),
        position: PopupMenuPosition.under,
        color: grisClair,
        itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Liste des Taches'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ListePage()));
                },
              ),
              PopupMenuItem(
                child: const Text('Ajouter une Tache'),
                onTap: () async {
                  await Navigator.of(contxt)
                      .push(MaterialPageRoute(builder: (contxt) => FormPage()));
                  onTap!();
                },
              ),
              PopupMenuItem(
                child: const Text('Deconnexion'),
                onTap: () async {
                  StorageService().setData(email: '', password: '');
                  Navigator.pop(context);
                },
              ),
            ]);
  }
}
