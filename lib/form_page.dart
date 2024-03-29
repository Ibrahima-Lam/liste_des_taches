import 'package:flutter/material.dart';
import 'package:liste_des_taches/main.dart';
import 'package:liste_des_taches/service/tache_service.dart';
import 'package:liste_des_taches/taches/tache.dart';
import 'package:liste_des_taches/widget/scafold_widget.dart';

Color grisClair = const Color.fromARGB(255, 233, 231, 231);

class FormPage extends StatefulWidget {
  final Tache? tache;
  final bool insert;
  const FormPage({super.key, this.tache, this.insert = true});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController titreController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  int? avancement;
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
    etat = widget.tache?.etat;
    type = widget.tache?.type;
    avancement = widget.tache?.avancement;
    titreController.text = widget.tache?.titre ?? '';
    dateDebutController.text = widget.tache?.dateDebut ?? '';
    dateFinController.text = widget.tache?.dateFin ?? '';

    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _insert() {
    Tache tache = Tache(
        titre: titreController.text,
        type: type!,
        dateDebut: dateDebutController.text,
        dateFin: dateFinController.text,
        etat: etat!,
        avancement: avancement ?? 0);
    setIsSending(true);
    TacheService().setTacheToFirebase(tache: tache);
    setIsSending(false);
    Navigator.pop(context);
  }

  void _update() {
    Tache tache = Tache(
        idTache: widget.tache!.idTache,
        titre: titreController.text,
        type: type ?? 'Personnelle',
        dateDebut: dateDebutController.text,
        dateFin: dateFinController.text,
        etat: etat ?? 'A faire',
        avancement: avancement ?? 0);
    setIsSending(true);
    TacheService().setTacheToFirebase(tache: tache);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Container(
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
                            dropdownColor: grisClair,
                            iconEnabledColor: bleu,
                            value: type,
                            items: ['Scollaire', 'Personnelle']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                type = val;
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
                  const Text(
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
            submitGroupe(),
          ],
        ),
      ),
    );
  }

  Widget submitGroupe() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          isSending
              ? Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bleu,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bleu,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      widget.insert ? _insert() : _update();
                    },
                    child: widget.insert
                        ? const Text('Creer une Tache')
                        : const Text('Modifier la Tache'),
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
                width: 160,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: grisClair,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                    iconSize: 50,
                    dropdownColor: grisClair,
                    iconEnabledColor: bleu,
                    value: etat,
                    items: ['A faire', 'En progress', 'Termine']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        etat = val;
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
                child: TextFormField(
                  initialValue: (avancement ?? 0).toString(),
                  validator: (value) {
                    if ((value as int) > 100 || (value as int) < 0) {
                      return 'La valeur doit etre 0 et 100';
                    }
                    return null;
                  },
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
