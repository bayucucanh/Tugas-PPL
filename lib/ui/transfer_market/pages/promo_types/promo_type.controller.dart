import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promo_type.dart';

class PromoTypeController extends BaseController {
  final _selectedType = PromoType().obs;

  List<PromoType> getTypes(String? target) {
    if (target == 'pemain') {
      return [
        PromoType(
            id: 1,
            name: 'Siswa Baru',
            imagePath:
                'assets/images/couple-sharing-reading-a-newspaper-together-svgrepo-com.svg'),
        PromoType(
            id: 2,
            name: 'Buka Seleksi',
            imagePath:
                'assets/images/staff-people-group-in-a-circular-arrow-svgrepo-com.svg'),
      ];
    } else {
      return [
        PromoType(
            id: 2,
            name: 'Buka Seleksi',
            imagePath:
                'assets/images/staff-people-group-in-a-circular-arrow-svgrepo-com.svg'),
      ];
    }
  }

  selectType(PromoType promoType) {
    _selectedType(promoType);
  }

  toJson() => {
        'promo_type': _selectedType.value.id,
      };

  PromoType? get selectedType => _selectedType.value;
}
