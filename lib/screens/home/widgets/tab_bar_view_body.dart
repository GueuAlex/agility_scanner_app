import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../model/qr_code_model.dart';
import 'scan_history_card.dart';

class TabBarViewBody extends StatelessWidget {
  const TabBarViewBody({
    super.key,
    required this.size,
    required this.date,
  });
  final DateTime date;

  final Size size;

  @override
  Widget build(BuildContext context) {
    List<QrCodeModel> qrCodesList = Functions.getScannedQrCode(
      scanList: Functions.getSelectedDateScanHistory(selectedDate: date),
    );
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
                  child: qrCodesList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                qrCodesList.length,
                                (index) => ScanHistoryCard(
                                  qrCodeModel: qrCodesList[index],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Center(
                            child: AppText.medium(
                              'Pas de scan enregistré\npour cette date !',
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
