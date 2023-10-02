import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/config/palette.dart';
import 'package:scanner/model/entreprise_model.dart';
import 'package:scanner/model/livraison_model.dart';
import 'package:scanner/screens/scanner/widgets/infos_column.dart';
import 'package:scanner/widgets/custom_button.dart';

import '../../remote_service/remote_service.dart';

class DeliDetailSheet extends StatefulWidget {
  final Livraison deli;
  final bool isFinish;
  const DeliDetailSheet({required this.deli, this.isFinish = false, super.key});

  @override
  State<DeliDetailSheet> createState() => _DeliDetailSheetState();
}

class _DeliDetailSheetState extends State<DeliDetailSheet> {
  /////////
  ///
  Entreprise? _ent;
  /////////
  bool isLoading = true;
  ///////////
  ///
  @override
  void initState() {
    getEntreprise(id: widget.deli.id, entList: Entreprise.entrepriseList)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 1.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: isLoading
          ? Center(
              child: Container(
                child: Center(child: AppText.medium('chargement ...')),
              ),
            )
          : Stack(
              children: [
                DetailSheetHeader(
                  size: size,
                  entName: _ent!.nom,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.only(
                    top: size.height / 4.5,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        AppText.medium('Livreur'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Nom et prénoms',
                                widget: AppText.medium(
                                  '${widget.deli.nom} ${widget.deli.prenoms}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Numéro',
                                widget: AppText.medium(
                                  '${widget.deli.telephone}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        AppText.medium('Livraison'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Date',
                                widget: AppText.medium(
                                  DateFormat('EE dd MMM yyyy', 'fr_FR')
                                      .format(widget.deli.dateVisite),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Heure \d’entrée',
                                widget: AppText.medium(
                                  widget.deli.heureEntree!,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Bon de commande',
                                widget: AppText.medium(
                                  '${widget.deli.numBonCommande}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Statut',
                                widget: AppText.medium(
                                  '${widget.deli.status}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        AppText.medium('Entreprises'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Par',
                                widget: AppText.medium(
                                  '${widget.deli.entreprise}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Véhicule',
                                widget: AppText.medium(
                                  '${widget.deli.immatriculation}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Pour',
                                widget: AppText.medium(
                                  '${_ent!.nom}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'Entrepot',
                                widget: AppText.medium(
                                  '${widget.deli.entrepotVisite}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 25),
                        widget.isFinish
                            ? CustomButton(
                                color: Palette.primaryColor,
                                width: double.infinity,
                                height: 35,
                                radius: 5,
                                text: 'Livraison terminée ?',
                                onPress: () {
                                  Functions.showLoadingSheet(ctxt: context);
                                  String heureSortir =
                                      DateFormat('HH:mm', 'fr_FR').format(
                                    DateTime.now(),
                                  );
                                  Map<String, dynamic> data = {
                                    "heure_sortie": heureSortir,
                                    "status": "terminée",
                                  };
                                  RemoteService()
                                      .putSomethings(
                                    api: 'livraisons/${widget.deli.id}',
                                    data: data,
                                  )
                                      .then((value) {
                                    Functions.showToast(
                                      msg: 'Livraison terminée',
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  ////
  Future<void> getEntreprise(
      {required int id, required List<Entreprise> entList}) async {
    setState(() {
      _ent = entList.firstWhereOrNull(
          (element) => element.id.toString() == id.toString());
    });
  }
}

class IconCol extends StatelessWidget {
  final Livraison deli;
  final String assetName;
  const IconCol({
    super.key,
    required this.deli,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: Center(
            child: Image.asset(assetName),
          ),
        ),
      ],
    );
  }
}

class DetailSheetHeader extends StatelessWidget {
  final String entName;
  const DetailSheetHeader({
    super.key,
    required this.size,
    required this.entName,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height / 4.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/deli-cover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: AppText.medium(
            entName,
            color: Palette.whiteColor,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.fade,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
