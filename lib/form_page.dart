import 'package:flutter/material.dart';
import 'package:liste_des_taches/main.dart';
import 'package:liste_des_taches/service/tache_service.dart';
import 'package:liste_des_taches/taches/tache.dart';

import 'package:liste_des_taches/widget/popupmenu_widget.dart';

Color grisClair = const Color.fromARGB(255, 233, 231, 231);

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController titreController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  int avancement = 0;
  String? etat;
  String? type;
  bool isSending = false;
  void setIsSending(bool val) {
    setState(() {
      isSending = val;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            margin: const EdgeInsets.only(left: 20),
            child: const CircleAvatar(
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
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Creer une nouvelle tache',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Type',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: grisClair,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton(
                              iconSize: 50,
                              dropdownColor: Colors.grey,
                              iconEnabledColor: bleu,
                              items: const [
                                DropdownMenuItem(
                                  value: Text('Scollaire'),
                                  child: Text('Scollaire'),
                                ),
                                DropdownMenuItem(
                                  value: Text('Personnelle'),
                                  child: Text('Personnelle'),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  type = val!.data;
                                  ;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Titre',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: grisClair,
                      ),
                      child: TextField(
                        controller: titreController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              dateGroupe(),
              etatAvancementGroupe(),
              submitGroupe(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitGroupe({required BuildContext context}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: bleu,
                foregroundColor: Colors.white,
                elevation: 1,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Tache tache = Tache(
                    titre: titreController.text,
                    type: type!,
                    dateDebut: dateDebutController.text,
                    dateFin: dateFinController.text,
                    etat: etat!,
                    avancement: avancement);
                setIsSending(true);
                await TacheService().setTacheToFirebase(tache: tache);
                setIsSending(false);
                Navigator.pop(context);
              },
              child: isSending
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text('Creer une Tache'),
            ),
          ),
        ],
      ),
    );
  }

  Widget etatAvancementGroupe() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Etat',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: grisClair,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                    iconSize: 50,
                    dropdownColor: Colors.grey,
                    iconEnabledColor: bleu,
                    items: const [
                      DropdownMenuItem(
                        value: Text('En progress'),
                        child: Text('En progress'),
                      ),
                      DropdownMenuItem(
                        value: Text('A faire'),
                        child: Text('A faire'),
                      ),
                      DropdownMenuItem(
                        value: Text('Termine'),
                        child: Text('Termine'),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        etat = val!.data;
                      });
                    }),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avancement',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                width: 100,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: grisClair,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    avancement = int.parse(val);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateGroupe() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date debut',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                width: 100,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: grisClair,
                ),
                child: TextField(
                  controller: dateDebutController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date fin',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                width: 100,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: grisClair,
                ),
                child: TextField(
                  controller: dateFinController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
