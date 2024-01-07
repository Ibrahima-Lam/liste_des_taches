class Tache {
  final String titre;
  final String? idTache;
  final String type;
  final String dateDebut;
  final String dateFin;
  final String etat;
  final int avancement;

  Tache(
      {this.titre = '',
      this.idTache,
      this.type = 'Personnelle',
      this.dateDebut = '',
      this.dateFin = '',
      this.etat = 'A faire',
      this.avancement = 0});
}
