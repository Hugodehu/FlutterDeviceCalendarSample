import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LeoMobileCalendarEvent {
  int id;
  int idUtilisateur;
  String identifiantUtilisateur;
  String identifiantCreateur;
  DateTime dateDebut;
  DateTime dateFin;
  String type;
  String sujet;
  String description;
  String invite;
  String lieu;
  int idCategorie;
  OrigineRendezVous origine;
  DateTime? dateCreationExterne;

  LeoMobileCalendarEvent({
    required this.id,
    required this.idUtilisateur,
    required this.identifiantUtilisateur,
    required this.identifiantCreateur,
    required this.dateDebut,
    required this.dateFin,
    required this.type,
    required this.sujet,
    required this.description,
    required this.invite,
    required this.lieu,
    required this.idCategorie,
    required this.origine,
    required this.dateCreationExterne,
  });
}

enum OrigineRendezVous {
  LEO,
  MilleEtUnRdv,
  TOMI,
}
