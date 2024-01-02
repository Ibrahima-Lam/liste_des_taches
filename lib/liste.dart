import 'package:flutter/material.dart';
import 'package:liste_des_taches/service/tache_service.dart';
import 'package:liste_des_taches/taches/tache.dart';
import 'package:liste_des_taches/widget/popupmenu_widget.dart';
import 'package:liste_des_taches/widget/tache_widget.dart';

final Color bleu = Color.fromARGB(255, 10, 41, 242);

// ignore: must_be_immutable
class ListePage extends StatefulWidget {
  ListePage({super.key});

  @override
  State<ListePage> createState() => _ListePageState();
}

class _ListePageState extends State<ListePage> {
  List<Tache> Taches = [];
  bool isloading = false;
  String query = '';

  String etat = 'En progress';

  List<Tache> filtreTaches() {
    final List<Tache> liste = query.isEmpty
        ? Taches.where(
                (element) => element.etat.toUpperCase() == etat.toUpperCase())
            .toList()
        : Taches.where((element) =>
                element.etat.toUpperCase() == etat.toUpperCase() &&
                element.titre.toUpperCase().startsWith(query.toUpperCase()))
            .toList();
    return liste;
  }

  void setIsLoding(bool val) {
    setState(() {
      isloading = val;
    });
  }

  Future<void> getData() async {
    setIsLoding(true);
    Taches = await TacheService().getTachesFromFirebase();
    setIsLoding(false);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              onTap: getData,
            )
          ],
        ),
        body: SafeArea(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 236, 232, 232)),
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        query = val;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined),
                      border: InputBorder.none,
                      hintText: "taper le nom d'une tache",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Mes Taches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    navButton(
                      title: 'En progress',
                      active: etat == 'En progress',
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    navButton(
                      title: 'A faire',
                      active: etat == 'A faire',
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    navButton(
                      title: 'Termine',
                      active: etat == 'Termine',
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: bleu,
                          ),
                        )
                      : Column(
                          children: filtreTaches()
                              .map((tache) => TacheWidget(tache: tache))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget navButton({required title, required active}) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            etat = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? bleu : Colors.white,
          foregroundColor: active ? Colors.white : Colors.black,
          elevation: 1,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(title));
  }
}

// ignore: must_be_immutable
/* 
List<Tache> taches = [
  Tache(
      titre: 'titre',
      type: 'Scolaire',
      dateDebut: '12 jan 2023',
      dateFin: '30 jan 2023',
      etat: 'En progress',
      avancement: 50),
  Tache(
      titre: 'Tache 2',
      type: 'Personelle',
      dateDebut: '12 jan 2024',
      dateFin: '30 jan 2024',
      etat: 'Termine',
      avancement: 50),
  Tache(
      titre: 'Tache 3',
      type: 'Personelle',
      dateDebut: '12 fev 2024',
      dateFin: '30 jan 2024',
      etat: 'a faire',
      avancement: 50),
  Tache(
      titre: 'Tache 3',
      type: 'Personelle',
      dateDebut: '12 fev 2024',
      dateFin: '30 jan 2024',
      etat: 'A faire',
      avancement: 50),
  Tache(
      titre: 'Tache 3',
      type: 'Personelle',
      dateDebut: '12 fev 2024',
      dateFin: '30 jan 2024',
      etat: 'A faire',
      avancement: 50),
  Tache(
      titre: 'Tache 4',
      type: 'Scollaire',
      dateDebut: '12 fev 2024',
      dateFin: '30 jan 2024',
      etat: 'En progress',
      avancement: 50),
];
 */