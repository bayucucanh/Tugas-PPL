import 'package:mobile_pssi/data/model/secure_document.dart';

class ActivatePartnerFeature {
  SecureDocument? secureDocument;
  bool isActive;

  ActivatePartnerFeature({
    this.isActive = false,
    this.secureDocument,
  });
}
