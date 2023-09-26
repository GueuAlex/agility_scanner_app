import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/palette.dart';
import 'package:scanner/model/entreprise_model.dart';
import 'package:scanner/model/livraison_model.dart';
import 'package:scanner/screens/scanner/widgets/infos_column.dart';

class DeliDetailSheet extends StatefulWidget {
  final Livraison deli;
  const DeliDetailSheet({required this.deli, super.key});

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
      height: size.height / 1.8,
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
                        AppText.medium('livreur'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'nom et prenoms',
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
                                label: 'numéro',
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
                        AppText.medium('livraison'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'date',
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
                                label: 'heure',
                                widget: AppText.medium(
                                  DateFormat('HH:mm', 'fr_FR')
                                      .format(widget.deli.dateLivraison!),
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
                                label: 'bon de commande',
                                widget: AppText.medium(
                                  '${widget.deli.numBonCommande}',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        AppText.medium('Entreprises'),
                        Row(
                          children: [
                            Expanded(
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'par',
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
                                label: 'véhicule',
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
                                label: 'pour',
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
