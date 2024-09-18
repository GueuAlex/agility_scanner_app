import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner/bloc/visite_history_bloc/qr_code_event.dart';

import '../../../bloc/visite_history_bloc/qr_code_bloc.dart';
import '../../../bloc/visite_history_bloc/qr_code_sate.dart';
import '../../../config/functions.dart';
import '../../../model/qr_code_model.dart';
import '../../../model/scan_history_model.dart';
import 'scan_history_card.dart';

class TabBarViewBody extends StatelessWidget {
  const TabBarViewBody({
    super.key,
    required this.size,
    required this.date,
  });
  final DateTime date;

  final Size size;

  Future<List<QrCodeModel>> _loadData() async {
    //LocalService localService = LocalService();
    /*  DeviceModel? device = await localService.getDevice();
    if (device == null) {
      return [];
    } */
    // Obtient la liste des ScanHistoryModel pour la date sélectionnée
    List<ScanHistoryModel> scanList =
        await Functions.getSelectedDateScanHistory(selectedDate: date);
    // Utilise cette liste pour obtenir les VisiteModel
    return await Functions.getScannedVisites(
      scanList: scanList,
      //localisationId: device.localisationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCodeBloc, QrCodeState>(
      builder: (context, state) {
        if (state is QrCodeLoading) {
          // Si les données sont en cours de chargement, afficher un indicateur de chargement
          return Center(
            child: Text('chargement en cours'),
          );
        } else if (state is QrCodeLoaded) {
          // Une fois les données chargées, afficher les visites scannées
          List<QrCodeModel> visits = state.qrCodeData;

          return visits.isNotEmpty
              ? Container(
                  height: size.height,
                  width: double.infinity,
                  color: Colors.white,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            visits.length,
                            (index) => ScanHistoryCard(
                              qrCodeModel: visits[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'Pas de scan enregistré\npour cette date !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                );
        } else if (state is QrCodeError) {
          // Si une erreur s'est produite lors du chargement des données, afficher un message d'erreur
          return Center(
            child: Text(
              'Erreur lors du chargement des données: ${state.message}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else {
          // Si aucun état n'est défini, déclencher l'événement pour charger les données
          BlocProvider.of<QrCodeBloc>(context).add(LoadQrCodeData(date: date));
          return Center(child: Text('Chargement en cours 1'));
        }
      },
    );
  }
}
