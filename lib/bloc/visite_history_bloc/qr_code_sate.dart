import '../../model/qr_code_model.dart';

abstract class QrCodeState {}

class QrCodeInitial extends QrCodeState {}

class QrCodeLoading extends QrCodeState {}

class QrCodeLoaded extends QrCodeState {
  final List<QrCodeModel> qrCodeData;
  QrCodeLoaded({required this.qrCodeData});
}

class QrCodeError extends QrCodeState {
  final String message;
  QrCodeError({required this.message});
}
