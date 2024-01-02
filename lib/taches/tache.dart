class Tache {
  final String titre;
  final String? idTache;
  final String type;
  final String dateDebut;
  final String dateFin;
  final String etat;
  final int avancement;

  Tache(
      {required this.titre,
      this.idTache,
      required this.type,
      required this.dateDebut,
      required this.dateFin,
      required this.etat,
      required this.avancement});
}
