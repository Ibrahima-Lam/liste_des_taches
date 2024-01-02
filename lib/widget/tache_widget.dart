import 'package:flutter/material.dart';
import 'package:liste_des_taches/taches/tache.dart';

Color bleu = const Color.fromARGB(255, 10, 41, 242);

class TacheWidget extends StatelessWidget {
  final Tache tache;
  const TacheWidget({super.key, re, required this.tache});

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
                  itemBuilder: (context) => [],
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
                        color: bleu,
                        height: 2,
                        width: 200,
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
}
