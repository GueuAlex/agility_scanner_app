import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner/bloc/visite_history_bloc/qr_code_event.dart';
import 'package:scanner/bloc/visite_history_bloc/qr_code_sate.dart';

import '../../config/functions.dart';
import '../../model/qr_code_model.dart';
import '../../model/scan_history_model.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  final QrCodeRepository qrCodeRepository;

  QrCodeBloc({required this.qrCodeRepository}) : super(QrCodeInitial()) {
    on<LoadQrCodeData>(_onLoadQrCodeData);
  }

  Future<void> _onLoadQrCodeData(
    LoadQrCodeData event,
    Emitter<QrCodeState> emit,
  ) async {
    emit(QrCodeLoading());
    try {
      final List<QrCodeModel> qrCodeData =
          await qrCodeRepository.fetchQrCodesForDate(event.date);
      emit(QrCodeLoaded(qrCodeData: qrCodeData));
    } catch (e) {
      emit(QrCodeError(message: e.toString()));
    }
  }
}

class QrCodeRepository {
  // Cette méthode simule une requête API pour récupérer les données de QR codes
  Future<List<QrCodeModel>> fetchQrCodesForDate(DateTime date) async {
    print('Fetching QR codes for date: $date');
    List<ScanHistoryModel> scanList =
        await Functions.getSelectedDateScanHistory(selectedDate: date);
    print('Scan history: $scanList');

    List<QrCodeModel> visites =
        await Functions.getScannedVisites(scanList: scanList);
    print('Scanned visites: $visites');

    return visites;
  }
}
