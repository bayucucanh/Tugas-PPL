import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/premium/controller/premium_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PremiumPackages extends StatefulWidget {
  final PremiumPlayerController vm;
  const PremiumPackages({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  State<PremiumPackages> createState() => _PremiumPackagesState();
}

class _PremiumPackagesState extends State<PremiumPackages> {
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
      'Pilih Paket Langganan'.text.semiBold.lg.make(),
      UiSpacer.verticalSpace(space: 20),
      Obx(() => widget.vm.isStoreAvailable.value
          ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.vm.products?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final product = widget.vm.products?[index];
                    return HStack(
                      [
                        Image.asset(ticketImage),
                        UiSpacer.horizontalSpace(),
                        VStack([
                          HStack([
                            (product?.name ?? '-').text.lg.make().expand(),
                            if (widget.vm.selectedProduct.value.productId ==
                                product?.productId)
                              const Icon(
                                Icons.check,
                                color: primaryColor,
                              ),
                          ]),
                          UiSpacer.verticalSpace(space: 5),
                          (product?.durationSubscription ?? '-')
                              .text
                              .semiBold
                              .make(),
                          (product?.description ?? '-').text.make(),
                          UiSpacer.verticalSpace(space: 10),
                        ]).expand()
                      ],
                      crossAlignment: CrossAxisAlignment.start,
                    )
                        .p8()
                        .box
                        .shadowXs
                        .roundedSM
                        .color(Get.theme.cardColor)
                        .border(
                          color: widget.vm.selectedProduct.value.productId ==
                                  product?.productId
                              ? primaryColor
                              : Get.theme.backgroundColor,
                          width: 3,
                        )
                        .make()
                        .p4()
                        .onInkTap(() {
                      widget.vm.selectSubscription(product);
                      setState(() {});
                    });
                  })
              .box
              .withConstraints(const BoxConstraints(
                minHeight: 100,
                maxHeight: 500,
              ))
              .make()
          : EmptyWithButton(
              emptyMessage: GetPlatform.isIOS
                  ? 'Maaf, app store belum tersedia pada daerah anda.'
                  : 'Maaf, paket premium belum tersedia pada daerah anda.',
              showButton: false,
              showImage: true,
            )),
      UiSpacer.verticalSpace(),
      if (widget.vm.selectedProduct.value.productId != null)
        VStack([
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
                      'Hemat ${(widget.vm.order.savedPrice(widget.vm.selectedProduct.value, voucher: widget.vm.voucher.value))}'
                          .text
                          .xs
                          .bold
                          .make(),
                    ])
                  : null,
              trailing: 'Gunakan'.text.color(primaryColor).make().onTap(() {
                Get.focusScope?.unfocus();
                widget.vm.applyPromo();
                setState(() {});
              }),
            ),
          UiSpacer.verticalSpace(),
          HStack([
            VStack([
              (widget.vm.order.totalPrice(widget.vm.selectedProduct.value,
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
              .continuousRectangle(
                height: 55,
                backgroundColor:
                    widget.vm.selectedProduct.value.productId != null
                        ? primaryColor
                        : Get.theme.backgroundColor,
              )
              .onInkTap(widget.vm.selectedProduct.value.productId != null
                  ? widget.vm.checkout
                  : null),
          UiSpacer.verticalSpace()
        ]),
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
