import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/config/palette.dart';
import 'package:scanner/model/entreprise_model.dart';
import 'package:scanner/model/livraison_model.dart';
import 'package:scanner/remote_service/remote_service.dart';
import 'package:scanner/screens/delivering/deliverig_screen.dart';
import 'package:scanner/screens/scanner/widgets/infos_column.dart';

class AddDeliScree extends StatefulWidget {
  static String routeName = 'add_deli_screen';
  const AddDeliScree({super.key});

  @override
  State<AddDeliScree> createState() => _AddDeliScreeState();
}

class _AddDeliScreeState extends State<AddDeliScree> {
  ///////////////////////////
  Livraison? _widgetDeli;
  bool swhowForm = false;
  /////////////// text editing Controllers //////////////////////////:
  final TextEditingController bonCommandeController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController carIdController = TextEditingController();

  ///
  ///
  @override
  void dispose() {
    bonCommandeController.dispose();
    nomController.dispose();
    prenomsController.dispose();
    emailController.dispose();
    telController.dispose();
    carIdController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final _name = ModalRoute.of(context)!.settings.arguments as String;
    final String prefix = 'BC_';
    Entreprise? _ent =
        getEntreprise(name: _name, entList: Entreprise.entrepriseList);

    final size = MediaQuery.of(context).size;

    ///////////////:::
    final Widget bonCommandeTextField = TextField(
      enabled: !swhowForm,
      controller: bonCommandeController,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefix: AppText.medium(prefix),
        border: InputBorder.none,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: !swhowForm
          ? FloatingActionButton(
              onPressed: () async {
                Functions.showLoadingSheet(ctxt: context);
                String _bc = '$prefix${bonCommandeController.text}';
                await getLivraison(bc: _bc, deliList: _ent!.livraisons)
                    .then((deli) {
                  if (deli == null) {
                    Navigator.pop(context);
                    Functions.showToast(msg: 'Bon de commande invalide !');
                  } else {
                    setState(() {
                      _widgetDeli = deli;
                      //////// set controllers ///////////:::
                      nomController.text = deli.nom;
                      prenomsController.text = deli.prenoms;
                      telController.text = deli.telephone;
                      emailController.text = deli.email;
                      carIdController.text = deli.immatriculation;
                      swhowForm = true;
                    });
                    Navigator.pop(context);
                  }
                  return deli;
                });
              },
              backgroundColor: Palette.primaryColor,
              child: Center(
                child: Icon(
                  CupertinoIcons.search,
                  color: Palette.whiteColor,
                  size: 20,
                ),
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                if (nomController.text.trim().isEmpty) {
                  Functions.showToast(msg: 'Renseigner le nom du livreur');
                } else if (prenomsController.text.trim().isEmpty) {
                  Functions.showToast(msg: 'Renseigner le prénom du livreur');
                } else if (telController.text.trim().isEmail) {
                  Functions.showToast(msg: 'Renseigner le numéro du livreur');
                } else if (carIdController.text.trim().isEmpty) {
                  Functions.showToast(msg: 'Renseigner n° d\'immatriculation');
                } else {
                  Functions.showLoadingSheet(ctxt: context);
                  String dateDeli = DateTime.now().toString();

                  Map<String, dynamic> _paload = {
                    "nom": nomController.text,
                    "prenoms": prenomsController.text,
                    "telephone": telController.text,
                    "immatriculation": carIdController.text,
                    "date_livraison": dateDeli,
                    "statut_livraison": 1
                  };

                  //////////////:: up to API ///////////////////:
                  ///
                  RemoteService()
                      .putSomethings(
                    api: 'livraisons/${_widgetDeli!.id}',
                    data: _paload,
                  )
                      .then((_) {
                    /////////////////////////
                    ///

                    _widgetDeli!.copyWith(
                      // heureDeDeli: heure,
                      nom: nomController.text,
                      prenoms: prenomsController.text,
                      telephone: telController.text,
                      immatriculation: carIdController.text,
                      statutLivraison: true,
                    );
                    Livraison _upDeli = _widgetDeli!;
                    for (Livraison element in Livraison.livraisonList) {
                      if (element.id == _upDeli.id) {
                        setState(() {
                          element.statutLivraison = true;
                        });
                      }
                    }

                    ///
                    /////////////////////////////
                    Navigator.pop(context);
                    Functions.showToast(msg: 'Livraison enregistrée');

                    Functions.allLivrason();
                    Future.delayed(const Duration(milliseconds: 500)).then(
                      (value) => Navigator.restorablePushNamedAndRemoveUntil(
                        context,
                        DeliveringScreen.routeName,
                        (route) => false,
                      ),
                    );
                  });

                  /*  */

                  /* now update via API (_widgetDeli) */
                  /* when complete */
                  //Future.delayed(const Duration(seconds: 3)).then((value) {});
                }
              },
              backgroundColor: Palette.primaryColor,
              child: Center(
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  color: Palette.whiteColor,
                  size: 20,
                ),
              ),
            ),
      appBar: AppBar(
        title: AppText.medium(_name),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: _ent != null
              ? _ent.livraisons.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        InfosColumn(
                          height: 50,
                          opacity: 0.2,
                          label: 'Bon de commande',
                          widget: Container(
                            padding: const EdgeInsets.only(top: 5),
                            width: double.infinity,
                            height: 30,
                            child: bonCommandeTextField,
                          ),
                        ),
                        const SizedBox(height: 10),
                        /* CustomButton(
                  color: Palette.primaryColor,
                  width: double.infinity,
                  height: 45,
                  radius: 5,
                  text: 'Ok',
                  onPress: () {},
                ) */
                        swhowForm
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AppText.small('Livreur :'),
                                  InfosColumn(
                                    height: 50,
                                    opacity: 0.2,
                                    label: 'Nom',
                                    widget: Container(
                                      width: double.infinity,
                                      height: 30,
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Functions.getTextField(
                                        controller: nomController,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  InfosColumn(
                                    height: 50,
                                    opacity: 0.2,
                                    label: 'Prenoms',
                                    widget: Container(
                                      width: double.infinity,
                                      height: 30,
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Functions.getTextField(
                                        controller: prenomsController,
                                      ),
                                    ),
                                  ),

                                  //
                                  const SizedBox(height: 5),

                                  InfosColumn(
                                    height: 50,
                                    opacity: 0.2,
                                    label: 'Numéro tel',
                                    widget: Container(
                                      width: double.infinity,
                                      height: 30,
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Functions.getTextField(
                                        controller: telController,
                                      ),
                                    ),
                                  ),

                                  //
                                  const SizedBox(height: 10),
                                  AppText.small('Entreprises : '),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfosColumn(
                                          height: 50,
                                          opacity: 0.2,
                                          label: 'Par',
                                          widget: Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: AppText.medium(
                                                _widgetDeli!.entreprise,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: InfosColumn(
                                          height: 50,
                                          opacity: 0.2,
                                          label: 'Plaque immatriculation',
                                          widget: Container(
                                            width: double.infinity,
                                            height: 30,
                                            padding: const EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            child: Functions.getTextField(
                                              controller: carIdController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfosColumn(
                                          height: 50,
                                          opacity: 0.2,
                                          label: 'Pour',
                                          widget: Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: AppText.medium(_name),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: InfosColumn(
                                          height: 50,
                                          opacity: 0.2,
                                          label: 'Entrpot',
                                          widget: Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 2,
                                                ),
                                                child: AppText.medium(
                                                  _widgetDeli!.entrepotVisite,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )
                  : SizedBox(
                      height: size.height / 1.2,
                      width: size.width,
                      child: Center(
                        child: AppText.medium(
                          'Aucune livraison n\'est disponibl\n pour cette entreprese',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
              : Container(),
        ),
      ),
    );
  }

  Entreprise? getEntreprise(
      {required String name, required List<Entreprise> entList}) {
    Entreprise? _ent = entList.firstWhereOrNull((element) =>
        element.nom.trim().toLowerCase() == name.trim().toLowerCase());
    return _ent;
  }

  Future<Livraison?> getLivraison({
    required String bc,
    required List<Livraison> deliList,
  }) async {
    Livraison? _deli = deliList.firstWhereOrNull((element) =>
        element.numBonCommande.trim().toLowerCase() == bc.trim().toLowerCase());
    return _deli;
  }
}
