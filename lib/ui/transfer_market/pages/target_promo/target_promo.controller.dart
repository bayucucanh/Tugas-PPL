import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promo_target.dart';

class TargetPromoController extends BaseController {
  final _targets = <PromoTarget>[
    PromoTarget(
        id: 'pelatih',
        name: 'Pelatih',
        imagePath: 'assets/images/soccer-player-svgrepo-com.svg'),
    PromoTarget(
        id: 'pemain',
        name: 'Pemain',
        imagePath: 'assets/images/athletic-soccer-player-svgrepo-com.svg'),
  ].obs;
  final _selectedTarget = PromoTarget().obs;

  selectTarget(PromoTarget targetPromo) {
    _selectedTarget(targetPromo);
  }

  toJson() => {
    'target': _selectedTarget.value.id,
  };

  List<PromoTarget> get targets => _targets;
  PromoTarget? get selectedTarget => _selectedTarget.value;
}
