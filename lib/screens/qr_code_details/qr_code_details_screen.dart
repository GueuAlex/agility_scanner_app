import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';
import '../../model/order_by_date_and_hours.dart';
import '../../model/qr_code_model.dart';
import '../../model/scan_history_model.dart';
import '../../model/user.dart';
import '../scanner/widgets/infos_column.dart';
import 'widgets/deatils.dart';
import 'widgets/detail_header.dart';

class QrCodeDetailsScreen extends StatelessWidget {
  static String routeName = 'qr_code_details_screen';
  const QrCodeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qrCodeModel =
        ModalRoute.of(context)!.settings.arguments as QrCodeModel;
    final User user = qrCodeModel.user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Platform.isIOS
                ? CupertinoIcons.chevron_back
                : CupertinoIcons.arrow_left,
            color: Palette.whiteColor,
          ),
        ),
        backgroundColor: Palette.primaryColor,
        title: AppText.medium(
          'Detailles',
          color: Palette.whiteColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Palette.primaryColor,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  DetailsHeader(
                    user: user,
                    qrCodeModel: qrCodeModel,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  DetailsHeader(
                    isQrcodeInfos: true,
                    user: user,
                    qrCodeModel: qrCodeModel,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: InfosColumn(
                label: 'Historique',
                widget: AppText.medium('Historiques des scans'),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ScanHistoryModel>>(
                future: getThisQrCodeScanHistory(
                    qrCodeId: qrCodeModel.id), // Appel Future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    ); // Affiche un loader pendant le chargement
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Une erreur est survenue'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun historique trouvé'));
                  }

                  // Récupère les données une fois chargées
                  List<ScanHistoryModel> scanList = snapshot.data!;
                  List<OrderByDateAndHours<ScanHistoryModel>> data =
                      getDataByDate(scanList: scanList);

                  return SingleChildScrollView(
                    child: Column(
                      children: data
                          .map(
                            (e) => GFAccordion(
                              titleChild: AppText.medium(
                                dateFormateur(dateTime: e.date),
                              ),
                              contentChild: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3.6,
                                ),
                                itemCount: e.data.length,
                                itemBuilder: (context, index) {
                                  return Details(
                                      scanHistoryModel: e.data[index]);
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // retourne l'historique de scan d'un qr code
// Retourne l'historique de scan d'un QR code
  Future<List<ScanHistoryModel>> getThisQrCodeScanHistory(
      {required int qrCodeId}) async {
    List<ScanHistoryModel> scanHistories = await ScanHistoryModel.scanHistories;
    return scanHistories
        .where((element) => element.qrCodeId == qrCodeId)
        .toList();
  }

////////////////
  /// filtre l'historique de scan d'un qr code et ordonne
  /// par date et heur
  List<OrderByDateAndHours<ScanHistoryModel>> getDataByDate({
    required List<ScanHistoryModel> scanList,
  }) {
    // Triez la liste de ScanHistoryModel par date et heure
    scanList.sort((a, b) {
      final dateComparison = b.scandDate.compareTo(a.scandDate);
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        return a.scanHour.compareTo(b.scanHour);
      }
    });

    List<OrderByDateAndHours<ScanHistoryModel>> data = [];
    DateTime currentDate =
        DateTime(0); // Utilisé pour vérifier la date actuelle

    for (var scan in scanList) {
      // Vérifiez si la date est différente de la date actuelle
      if (!isSameDay(scan.scandDate, currentDate)) {
        currentDate = scan.scandDate;
        // Créez un nouvel objet OrderByDateAndHours avec la date actuelle
        OrderByDateAndHours<ScanHistoryModel> orderByDateAndHours =
            OrderByDateAndHours<ScanHistoryModel>(data: [], date: currentDate);
        data.add(orderByDateAndHours);
      }

      // Ajoutez le ScanHistoryModel à la liste correspondante
      data.last.data.add(scan);
    }

    return data;
  }

// compraison de date
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  ///////////
  /// formatage de date
  String dateFormateur({required DateTime dateTime}) {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (dateTime == today) {
      return "Aujourd'hui";
    }
    if (today.subtract(const Duration(days: 1)) == dateTime) {
      return "Hier";
    }

    if (today.month == dateTime.month) {
      return DateFormat("EEEE \u2022 dd", 'fr_FR').format(dateTime);
    }
    return DateFormat("EEE dd MMM yyyy", 'fr_FR').format(dateTime);
  }
}
