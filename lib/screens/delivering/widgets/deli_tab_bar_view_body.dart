import 'package:flutter/material.dart';
import 'package:scanner/model/livraison_model.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import 'deli_history_card.dart';

class DeliTabBarViewBody extends StatelessWidget {
  const DeliTabBarViewBody({
    super.key,
    required this.size,
    required this.date,
  });
  final DateTime date;

  final Size size;

  @override
  Widget build(BuildContext context) {
    /*   List<QrCodeModel> qrCodesList = Functions.getScannedQrCode(
      scanList: Functions.getSelectedDateScanHistory(selectedDate: date),
    ); */

    List<Livraison> livraisons =
        Functions.getSelectedDateLivraisons(selectedDate: date);

    return Container(
      height: size.height,
      width: double.infinity,
      color: Palette.whiteColor,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: livraisons.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                livraisons.length,
                                (index) => DeliHistoryCard(
                                  //qrCodeModel: qrCodesList[index],
                                  livraison: livraisons[index],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Center(
                            child: AppText.medium(
                              'Aucune livraison enregistrée\npour cette date !',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
