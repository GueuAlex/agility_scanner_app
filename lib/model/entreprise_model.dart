// To parse this JSON data, do
//
//     final entreprise = entrepriseFromJson(jsonString);

import 'dart:convert';

import 'livraison_model.dart';

//////////////////////////// single /////////////////////////////////////////
///
Entreprise entrepriseFromJson(String str) =>
    Entreprise.fromJson(json.decode(str));

String entrepriseToJson(Entreprise data) => json.encode(data.toJson());

//////////////////////////// list /////////////////////////////////////////
///
List<Entreprise> entrepriseListFromJson(String str) =>
    List<Entreprise>.from(json.decode(str).map((x) => Entreprise.fromJson(x)));

String entrepriseListToJson(List<Entreprise> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Entreprise {
  final int id;
  final dynamic logo;
  final String nom;
  final String telephone;
  final String email;
  List<Livraison> livraisons;

  Entreprise({
    required this.id,
    required this.logo,
    required this.nom,
    required this.telephone,
    required this.email,
    this.livraisons = const [],
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) => Entreprise(
        id: json["id"],
        logo: json["logo"],
        nom: json["nom"],
        telephone: json["telephone"],
        email: json["email"],
        livraisons: List<Livraison>.from(
            json["livraisons"].map((x) => Livraison.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "nom": nom,
        "telephone": telephone,
        "email": email,
        "livraisons": List<dynamic>.from(livraisons.map((x) => x.toJson())),
      };

  static List<Entreprise> entrepriseList = [
    Entreprise(
      id: 1,
      logo: 'logo1.png',
      nom: 'Entreprise A',
      telephone: '1234567890',
      email: 'entrepriseA@example.com',
      livraisons: [Livraison.livraisonList[0]],
    ),
    Entreprise(
      id: 2,
      logo: 'logo2.png',
      nom: 'Entreprise B',
      telephone: '9876543210',
      email: 'entrepriseB@example.com',
      livraisons: [Livraison.livraisonList[1]],
    ),
    Entreprise(
      id: 3,
      logo: 'logo3.png',
      nom: 'Entreprise C',
      telephone: '1122334455',
      email: 'entrepriseC@example.com',
      livraisons: [Livraison.livraisonList[2]],
    ),
    Entreprise(
      id: 4,
      logo: 'logo4.png',
      nom: 'Entreprise D',
      telephone: '9988776655',
      email: 'entrepriseD@example.com',
      livraisons: [Livraison.livraisonList[3]],
    ),
    Entreprise(
      id: 5,
      logo: 'logo5.png',
      nom: 'Entreprise E',
      telephone: '5544332211',
      email: 'entrepriseE@example.com',
      livraisons: [Livraison.livraisonList[4]],
    ),
  ];
}
