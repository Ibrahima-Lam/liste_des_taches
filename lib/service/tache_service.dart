import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liste_des_taches/taches/tache.dart';

class TacheService {
  Future<void> sendTacheTofirebase() async {
    try {
      await FirebaseFirestore.instance.collection('tache').doc('meub1').set({
        'id': '',
        'nom': '',
        'adresse': '',
        'telephone': '',
      });
    } catch (e) {}
  }

  Future<List<Tache>> getTachesFromFirebase() async {
    List<Tache> Taches = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('tache').get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data();
        final String id = documentSnapshot.id;
        Tache tache = Tache(
          idTache: id,
          titre: data['titre'],
          type: data['type'],
          dateDebut: data['dateDebut'],
          dateFin: data['dateFin'],
          avancement: data['avancement'],
          etat: data['etat'],
        );

        Taches.add(tache);
        print(data);
      }
      return Taches;
    } catch (e) {
      return Taches;
    }
  }

  Future<bool> setTacheToFirebase({
    required Tache tache,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('tache')
          .doc(tache.idTache)
          .set({
        'titre': tache.titre,
        'type': tache.type,
        'dateDebut': tache.dateDebut,
        'dateFin': tache.dateFin,
        'etat': tache.etat,
        'avancement': tache.avancement,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteTacheFromFirebase(id) async {
    try {
      await FirebaseFirestore.instance.collection('tache').doc(id).delete();
    } catch (e) {}
  }
}
