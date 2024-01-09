import 'package:flutter/material.dart';
import 'package:liste_des_taches/service/tache_service.dart';
import 'package:liste_des_taches/taches/tache.dart';
import 'package:liste_des_taches/widget/animated_list_widget.dart';
import 'package:liste_des_taches/widget/scafold_widget.dart';
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
  List<Tache> get filteredTaches => filtreTaches();
  bool isloading = false;
  String query = '';
  TextEditingController searchController = TextEditingController();

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
      home: ScaffoldWidget(
        onTap: getData,
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
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        query = val;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_outlined),
                        border: InputBorder.none,
                        hintText: "taper le nom d'une tache",
                        hintStyle: const TextStyle(fontSize: 14),
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                onPressed: () {}, icon: const Icon(Icons.clear))
                            : null),
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
                          children: filteredTaches
                              .map(
                                (tache) => AnimatedListWidget(
                                  delay: 500,
                                  child: TacheWidget(
                                    tache: tache,
                                    callback: getData,
                                  ),
                                ),
                              )
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
