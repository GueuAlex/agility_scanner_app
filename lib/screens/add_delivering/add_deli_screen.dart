import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/config/palette.dart';
import 'package:scanner/model/entreprise_model.dart';
import 'package:scanner/model/livraison_model.dart';
import 'package:scanner/remote_service/remote_service.dart';
import 'package:scanner/screens/deli_details/deli_details_sheet.dart';
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
  /////////////////:
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
    //final String prefix = 'BC_';
    Entreprise? _ent =
        getEntreprise(name: _name, entList: Entreprise.entrepriseList);

    final size = MediaQuery.of(context).size;

    ///////////////:::
    final Widget bonCommandeTextField = TextField(
      enabled: !swhowForm,
      controller: bonCommandeController,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        // prefix: AppText.medium(prefix),
        border: InputBorder.none,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: !swhowForm
          ? FloatingActionButton(
              onPressed: () async {
                Functions.showLoadingSheet(ctxt: context);
                String _bc = bonCommandeController.text.toString();
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
                      //
                    });
                    //Navigator.pop(context);
                    if (deli.status.toLowerCase().trim() == 'en cours') {
                      Navigator.pop(context);
                      Functions.showBottomSheet(
                        ctxt: context,
                        widget: DeliDetailSheet(deli: deli, isFinish: true),
                      ).then((_) {});
                    } else {
                      setState(() {
                        swhowForm = true;
                      });
                      Navigator.pop(context);
                    }
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
                if (_widgetDeli!.status.toLowerCase().trim() == 'terminée') {
                  Functions.showToast(msg: 'Livraison terminée');
                } else {
                  if (nomController.text.trim().isEmpty) {
                    Functions.showToast(msg: 'Renseigner le nom du livreur');
                  } else if (prenomsController.text.trim().isEmpty) {
                    Functions.showToast(msg: 'Renseigner le prénom du livreur');
                  } else if (telController.text.trim().isEmpty) {
                    Functions.showToast(msg: 'Renseigner le numéro du livreur');
                  } else if (carIdController.text.trim().isEmpty) {
                    Functions.showToast(
                        msg: 'Renseigner n° d\'immatriculation');
                  } else {
                    Functions.showLoadingSheet(ctxt: context);
                    String dateDeli = DateTime.now().toString();
                    String heureDeli = DateFormat('HH:mm', 'fr_FR').format(
                      DateTime.now(),
                    );

                    Map<String, dynamic> _paload = {
                      "nom": nomController.text,
                      "prenoms": prenomsController.text,
                      "telephone": telController.text,
                      "immatriculation": carIdController.text,
                      "date_livraison": dateDeli,
                      "statut_livraison": 1,
                      "heure_entree": heureDeli,
                      "status": "en cours"
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

                      Functions.allLivrason().then((_) {
                        Navigator.pop(context);
                        Functions.showToast(msg: 'Livraison enregistrée');
                        Future.delayed(const Duration(milliseconds: 500)).then(
                          (value) => Navigator.pushNamedAndRemoveUntil(
                            context,
                            DeliveringScreen.routeName,
                            (route) => false,
                          ),
                        );
                      });
                    });

                    /*  */

                    /* now update via API (_widgetDeli) */
                    /* when complete */
                    //Future.delayed(const Duration(seconds: 3)).then((value) {});
                  }
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
                            padding: const EdgeInsets.only(bottom: 5),
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
                                    label: 'Prénoms',
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

                                  ////////
                                  _widgetDeli!.status.toLowerCase().trim() ==
                                          'terminée'
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            AppText.small('Livraison : '),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InfosColumn(
                                                    height: 50,
                                                    opacity: 0.2,
                                                    label: 'Date',
                                                    widget: Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 2,
                                                        ),
                                                        child: AppText.medium(
                                                          DateFormat(
                                                                  'dd MMM yyyy',
                                                                  'fr_FR')
                                                              .format(
                                                            _widgetDeli!
                                                                .dateLivraison!,
                                                          ),
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
                                                    label: 'Heure d\’entrée',
                                                    widget: Container(
                                                      width: double.infinity,
                                                      height: 30,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 5,
                                                      ),
                                                      child: AppText.medium(
                                                          _widgetDeli!
                                                              .heureEntree!),
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
                                                    label: 'Heure de sortir',
                                                    widget: Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 2,
                                                        ),
                                                        child: AppText.medium(
                                                          _widgetDeli!
                                                              .heureSortie!,
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
                                                    label: 'Status',
                                                    widget: Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 2,
                                                        ),
                                                        child: AppText.medium(
                                                          _widgetDeli!.status,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  ///////
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
                                          label: 'Entrepot',
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

                                  /////////

                                  /////////////
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
