import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/withdraw/controller/withdraws.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Withdraws extends GetView<WithdrawsController> {
  static const routeName = '/withdraws';
  const Withdraws({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WithdrawsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Penarikan Dana'.text.sm.make(),
      resizeToAvoidBottomInset: true,
      actions: controller.userData.value.hasRole('finance')
          ? [
              Obx(
                () => IconButton(
                  onPressed: controller.listChecked!.isEmpty
                      ? null
                      : controller.showOtpForm,
                  icon: const Icon(FontAwesomeIcons.moneyBillTransfer),
                  tooltip: 'Transfer Dana',
                ),
              ),
            ]
          : [
              IconButton(
                onPressed: controller.openBankAccount,
                icon: const Icon(FontAwesomeIcons.vault),
                tooltip: 'Alamat Penarikan Dana',
              ),
              IconButton(
                onPressed: controller.openSelectBank,
                icon: const Icon(FontAwesomeIcons.moneyBillTransfer),
                tooltip: 'Penarikan Dana',
              ),
            ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onLoading: controller.loadMore,
          onRefresh: controller.refreshData,
          child: controller.withdraws == null || controller.withdraws!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum ada penarikan dana',
                  showImage: true,
                  showButton: false,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final withdraw = controller.withdraws?[index];
                    return Obx(
                      () => ListTile(
                        leading: controller.isFinance == false ||
                                controller.showCheckbox.value == false
                            ? null
                            : Checkbox(
                                value: controller.listChecked
                                            ?.contains(withdraw) ==
                                        true
                                    ? true
                                    : false,
                                onChanged: (value) => controller.addWithdrawId(
                                    withdraw: withdraw),
                              ),
                        onLongPress: controller.isFinance
                            ? controller.showCheckBoxes
                            : null,
                        onTap: controller.isFinance
                            ? () {
                                controller.addWithdrawId(
                                    isSingle: true, withdraw: withdraw);
                                controller.showOtpForm(withdraw: withdraw);
                              }
                            : null,
                        title: 'Penarikan Dana'.text.make(),
                        subtitle: VStack([
                          'No. Referensi : ${withdraw?.referenceNo ?? '-'}'
                              .text
                              .sm
                              .make(),
                          '${withdraw?.accountNumber ?? '-'} - ${withdraw?.bankName ?? '-'}'
                              .text
                              .sm
                              .make(),
                          if (withdraw?.errorMessage != null)
                            (withdraw?.errorMessage ?? '')
                                .text
                                .sm
                                .color(primaryColor)
                                .make(),
                        ]),
                        trailing: VStack(
                          [
                            (withdraw?.amountFormat ?? '').text.make(),
                            (withdraw?.status!.capitalizeFirst ?? '-')
                                .text
                                .semiBold
                                .color(withdraw?.statusColor)
                                .sm
                                .make(),
                          ],
                          alignment: MainAxisAlignment.end,
                          crossAlignment: CrossAxisAlignment.end,
                        ),
                      ),
                    );
                  },
                  itemCount: controller.withdraws?.length ?? 0,
                ).p12(),
        ),
      ),
    );
  }
}
