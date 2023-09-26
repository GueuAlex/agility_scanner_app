import 'dart:convert';

///////////////////////////////// single /////////////////////////////////////
Livraison livraisonFromJson(String str) => Livraison.fromJson(json.decode(str));

String livraisonToJson(Livraison data) => json.encode(data.toJson());

///////////////////////////////// list /////////////////////////////////////
List<Livraison> livraisonListFromJson(String str) =>
    List<Livraison>.from(json.decode(str).map((x) => Livraison.fromJson(x)));

String livraisonListToJson(List<Livraison> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Livraison {
  final int id;
  /*  final int userId; */
  int compagnyId;
  /* final int active; */
  String nom;
  String prenoms;
  String numBonCommande;
  String codeFournisseur;
  String immatriculation;
  String telephone;
  String email;
  String entreprise;
  String entrepotVisite;
  bool statutLivraison;
  DateTime? dateLivraison;
  DateTime dateVisite;
  DateTime? dateFinVisite;

  Livraison({
    required this.id,
    // required this.userId,
    required this.compagnyId,
    //required this.active,
    required this.nom,
    required this.prenoms,
    required this.numBonCommande,
    required this.codeFournisseur,
    required this.immatriculation,
    required this.telephone,
    required this.email,
    required this.entreprise,
    required this.entrepotVisite,
    required this.statutLivraison,
    required this.dateVisite,
    required this.dateFinVisite,
    required this.dateLivraison,
  });

  factory Livraison.fromJson(Map<String, dynamic> json) => Livraison(
        id: json["id"],
        // userId: json["user_id"],
        compagnyId: json["compagny_id"],
        // active: json["active"],
        nom: json["nom"] == null ? '' : json["nom"],
        prenoms: json["prenoms"] == null ? '' : json["prenoms"],
        numBonCommande:
            json["num_bon_commande"] == null ? '' : json["num_bon_commande"],
        codeFournisseur:
            json["code_fournisseur"] == null ? '' : json["code_fournisseur"],
        immatriculation:
            json["immatriculation"] == null ? '' : json["immatriculation"],
        telephone: json["telephone"] == null ? '' : json["telephone"],
        email: json["email"] == null ? '' : json["email"],
        entreprise: json["entreprise"] == null ? '' : json["entreprise"],
        entrepotVisite:
            json["entrepot_visite"] == null ? '' : json["entrepot_visite"],
        statutLivraison: json["statut_livraison"] == 0 ? false : true,
        dateVisite: DateTime.parse(json["date_visite"]),
        dateFinVisite: json["date_fin_visite"] != null
            ? DateTime.parse(json["date_fin_visite"])
            : null,

        dateLivraison: json["date_livraison"] != null
            ? DateTime.parse(json["date_livraison"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        //"user_id": userId,
        "compagny_id": compagnyId,
        // "active": active,
        "nom": nom,
        "prenoms": prenoms,
        "num_bon_commande": numBonCommande,
        "code_fournisseur": codeFournisseur,
        "immatriculation": immatriculation,
        "telephone": telephone,
        "email": email,
        "entreprise": entreprise,
        "entrepot_visite": entrepotVisite,
        "statut_livraison": statutLivraison,
        "date_visite": dateVisite.toIso8601String(),
        "date_livraison": dateLivraison!.toIso8601String()
      };

/* copy with methode */
  Livraison copyWith({
    int? id,
    int? compagnyId,
    String? nom,
    String? prenoms,
    String? numBonCommande,
    String? codeFournisseur,
    String? immatriculation,
    String? telephone,
    String? email,
    String? entreprise,
    String? entrepotVisite,
    bool? statutLivraison,
    DateTime? dateVisite,
    DateTime? dateFinVisite,
    //String? heureDeDeli,
  }) {
    return Livraison(
      id: id ?? this.id,
      compagnyId: compagnyId ?? this.compagnyId,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      numBonCommande: numBonCommande ?? this.numBonCommande,
      codeFournisseur: codeFournisseur ?? this.codeFournisseur,
      immatriculation: immatriculation ?? this.immatriculation,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      entreprise: entreprise ?? this.entreprise,
      entrepotVisite: entrepotVisite ?? this.entrepotVisite,
      statutLivraison: statutLivraison ?? this.statutLivraison,
      dateVisite: dateVisite ?? this.dateVisite,
      dateFinVisite: dateFinVisite ?? this.dateFinVisite,
      dateLivraison: dateLivraison ?? this.dateLivraison,
    );
  }

  static List<Livraison> livraisonList = [
    Livraison(
      id: 1,
      //userId: 101,
      compagnyId: 1,
      //active: 1,
      nom: 'Doe',
      prenoms: 'John',
      numBonCommande: 'BC_123',
      codeFournisseur: 'CF456',
      immatriculation: 'IM789',
      telephone: '1234567890',
      email: 'john.doe@example.com',
      entreprise: 'Entreprise A',
      entrepotVisite: 'Entrepôt 1',
      statutLivraison: false,
      dateVisite: DateTime(2023, 9, 21),
      dateFinVisite: DateTime(2023, 9, 25),
      dateLivraison: null,
    ),
    Livraison(
      id: 2,
      // userId: 102,
      compagnyId: 2,
      // active: 0,
      nom: 'Smith',
      prenoms: 'Alice',
      numBonCommande: 'BC_456',
      codeFournisseur: 'CF789',
      immatriculation: 'IM101',
      telephone: '9876543210',
      email: 'alice.smith@example.com',
      entreprise: 'Entreprise B',
      entrepotVisite: 'Entrepôt 2',
      statutLivraison: true,
      dateVisite: DateTime(2023, 8, 18),
      dateFinVisite: DateTime(2023, 8, 19),
      dateLivraison: DateTime.now(),
    ),
    Livraison(
      id: 3,
      //userId: 103,
      compagnyId: 3,
      //active: 1,
      nom: 'Johnson',
      prenoms: 'Michael',
      numBonCommande: 'BC_789',
      codeFournisseur: 'CF123',
      immatriculation: 'IM456',
      telephone: '1122334455',
      email: 'michael.johnson@example.com',
      entreprise: 'Entreprise C',
      entrepotVisite: 'Entrepôt 3',
      statutLivraison: true,
      dateVisite: DateTime(2023, 8, 20),
      dateFinVisite: DateTime(2023, 8, 21),
      dateLivraison: DateTime.now(),
    ),
    Livraison(
      id: 4,
      //  userId: 104,
      compagnyId: 1,
      // active: 0,
      nom: 'Brown',
      prenoms: 'Jessica',
      numBonCommande: 'BC_101',
      codeFournisseur: 'CF234',
      immatriculation: 'IM567',
      telephone: '9988776655',
      email: 'jessica.brown@example.com',
      entreprise: 'Entreprise A',
      entrepotVisite: 'Entrepôt 1',
      statutLivraison: true,
      dateVisite: DateTime(2023, 9, 18),
      dateFinVisite: DateTime(2023, 8, 23),
      dateLivraison: DateTime.now(),
    ),
    Livraison(
      id: 5,
      //userId: 105,
      compagnyId: 2,
      //active: 1,
      nom: 'Taylor',
      prenoms: 'Robert',
      numBonCommande: 'BC_234',
      codeFournisseur: 'CF345',
      immatriculation: 'IM678',
      telephone: '1122334455',
      email: 'robert.taylor@example.com',
      entreprise: 'Entreprise B',
      entrepotVisite: 'Entrepôt 2',
      statutLivraison: true,
      dateVisite: DateTime(2023, 9, 19),
      dateFinVisite: DateTime(2023, 9, 25),
      dateLivraison: DateTime.now(),
    ),
  ];
}
