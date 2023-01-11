import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/ui/premium/controller/club_store.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:readmore/readmore.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubPackages extends StatefulWidget {
  final ClubStoreController vm;
  final Product product;
  const ClubPackages({Key? key, required this.vm, required this.product})
      : super(key: key);

  @override
  State<ClubPackages> createState() => _ClubPackagesState();
}

class _ClubPackagesState extends State<ClubPackages> {
  double _viewInset = 0.0;
  late BottomInsetObserver _insetObserver;

  @override
  void initState() {
    _insetObserver = BottomInsetObserver()..addListener(_keyboardHandle);
    super.initState();
  }

  _keyboardHandle(BottomInsetChanges change) {
    /// getting current inset and check current status
    setState(() {
      _viewInset = change.currentInset;
    });
  }

  @override
  void dispose() {
    _insetObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VStack([
      (widget.product.name ?? '-').text.semiBold.make(),
      UiSpacer.verticalSpace(space: 10),
      ReadMoreText(
        widget.product.description ?? '-',
        trimLength: 100,
        trimCollapsedText: 'lihat',
        trimExpandedText: ' tutup',
        lessStyle: const TextStyle(
          color: primaryColor,
        ),
        moreStyle: const TextStyle(
          color: primaryColor,
        ),
        trimMode: TrimMode.Length,
      ),
      UiSpacer.verticalSpace(space: 20),
      if (GetPlatform.isAndroid)
        ListTile(
          leading: const Icon(
            Icons.discount_rounded,
            color: primaryColor,
          ),
          title: TextFormField(
            controller: widget.vm.voucherCode,
            decoration: const InputDecoration(
              hintText: 'Masukan kode voucher',
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
            ),
          ),
          subtitle: widget.vm.voucher.value.code != null
              ? VStack([
                  'Potongan diskon ${widget.vm.voucher.value.formatValue()}.'
                      .text
                      .xs
                      .make(),
                  'Hemat ${(widget.vm.order?.savedPrice(widget.product, voucher: widget.vm.voucher.value))}'
                      .text
                      .xs
                      .bold
                      .make(),
                ])
              : null,
          trailing: 'Gunakan'
              .text
              .color(primaryColor)
              .make()
              .onTap(() => widget.vm.applyPromo(widget.product)),
        ),
      UiSpacer.verticalSpace(),
      HStack([
        VStack([
          (widget.vm.order?.totalPrice(widget.product,
                      voucher: widget.vm.voucher.value) ??
                  '-')
              .text
              .white
              .semiBold
              .make(),
          'Sudah termasuk pajak 11%'.text.white.xs.make(),
        ]).expand(),
        'Lanjut Checkout'.text.white.make(),
      ])
          .p8()
          .continuousRectangle(height: 55, backgroundColor: primaryColor)
          .onInkTap(() => widget.vm.checkout(widget.product)),
    ])
        .p12()
        .pOnly(bottom: _viewInset)
        .color(
          Get.theme.backgroundColor,
        )
        .scrollVertical()
        .safeArea(top: false);
  }
}
