abstract class QrCodeEvent {}

class LoadQrCodeData extends QrCodeEvent {
  final DateTime date;
  LoadQrCodeData({required this.date});
}
