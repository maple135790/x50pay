import 'package:x50pay/page/scan/qr_pay/qr_pay_data.dart';

sealed class CabPaymentResult {
  const CabPaymentResult();
}

final class CabPaymentCompleted extends CabPaymentResult {
  const CabPaymentCompleted();
}

final class CabPaymentNeedsSelection extends CabPaymentResult {
  final QRPayData qrPayData;

  const CabPaymentNeedsSelection(this.qrPayData);
}
