import 'package:flutter/material.dart';
import 'package:liste_des_taches/form_page.dart';
import 'package:liste_des_taches/service/tache_service.dart';
import 'package:liste_des_taches/taches/tache.dart';

Color bleu = const Color.fromARGB(255, 10, 41, 242);

// ignore: must_be_immutable
class TacheWidget extends StatelessWidget {
  final Tache tache;
  final Function? callback;
  TacheWidget({super.key, this.callback, required this.tache});
  TacheService tacheService = TacheService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tache.type,
                    style: TextStyle(
                      color: bleu,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    tache.titre,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: grisClair,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'editer',
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FormPage(
                              tache: tache,
                              insert: false,
                            ),
                          ),
                        );
                        callback!();
                      },
                      child: const Text(
                        'Editer',
                        style: TextStyle(
                            color: Color.fromARGB(255, 10, 48, 239),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'supprimer',
                      onTap: () {
                        _supprimerTache(context: context);
                      },
                      child: const Text(
                        'Supprimer',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Progress'),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 2,
                        width: 200,
                        child: LinearProgressIndicator(
                          value: (tache.avancement / 100).toDouble(),
                          color: bleu,
                        ),
                      ),
                      Text('${tache.avancement}%'),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: bleu,
              ),
              Text(tache.dateDebut),
              const SizedBox(
                width: 20,
              ),
              Icon(
                Icons.flag_outlined,
                color: bleu,
              ),
              Text(tache.dateFin),
            ],
          )
        ],
      ),
    );
  }

  void _supprimerTache({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Suppression'),
              content: const Text('Voulez vous supprimer cette tache ?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'annuler');
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ok');
                  },
                  child: const Text('Ok'),
                ),
              ],
            )).then((value) async {
      if (value == 'ok') {
        await tacheService.deleteTacheFromFirebase(tache.idTache);
        callback!();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Suppression avec succees'),
          ),
        );
      }
    });
  }
}
