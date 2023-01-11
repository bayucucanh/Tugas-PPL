import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/bank_account/controller/bank_accounts.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class BankAccounts extends GetView<BankAccountsController> {
  static const routeName = '/bank-accounts';
  const BankAccounts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BankAccountsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Daftar Rekening'.text.sm.make(),
      actions: [
        IconButton(
            onPressed: controller.addBankAccount,
            icon: const Icon(FontAwesomeIcons.plus)),
      ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onLoading: controller.loadMore,
          onRefresh: controller.refreshData,
          child: controller.bankAccounts == null ||
                  controller.bankAccounts!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum ada alamat penarikan dana',
                  showImage: true,
                  showButton: false,
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final bankAccount = controller.bankAccounts?[index];
                    return ListTile(
                      title: (bankAccount?.name ?? '-').text.make(),
                      subtitle: VStack([
                        '${bankAccount?.accountNumber ?? '-'} ${bankAccount?.bankName ?? '-'}'
                            .text
                            .sm
                            .make(),
                      ]),
                    );
                  },
                  itemCount: controller.bankAccounts?.length ?? 0,
                ),
        ),
      ),
    );
  }
}
