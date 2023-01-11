import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/my_class.dart';
import 'package:mobile_pssi/ui/class/controller/my_class.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class RatingDialog extends StatelessWidget {
  final MyClassController vm;
  final MyClass myClass;
  const RatingDialog({
    Key? key,
    required this.vm,
    required this.myClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: VStack([
        'Berikan Ulasan'.text.xl.semiBold.make(),
        'Berikan ulasan untuk kelas ${myClass.className}'
            .text
            .sm
            .gray500
            .make(),
        UiSpacer.verticalSpace(),
        RatingBar.builder(
          initialRating:
              myClass.rating?.rating ?? vm.rateController.rating.value,
          itemCount: 5,
          minRating: 1,
          maxRating: 5,
          itemSize: 50,
          ignoreGestures: myClass.rating == null ? false : true,
          allowHalfRating: true,
          itemBuilder: (context, _) => const Icon(
            Icons.star_rounded,
            color: starColor,
          ),
          glow: true,
          onRatingUpdate: vm.rateController.changeRating,
        ).centered(),
        UiSpacer.verticalSpace(),
        TextFormField(
          controller:
              myClass.rating == null ? vm.rateController.description : null,
          readOnly: myClass.rating == null ? false : true,
          initialValue:
              myClass.rating == null ? null : myClass.rating?.description ?? '',
          decoration: const InputDecoration(
            hintText: 'Deskripsi (Opsional)',
          ),
          minLines: 4,
          maxLines: 4,
        ),
        UiSpacer.verticalSpace(),
        if (myClass.rating == null)
          'Simpan Ulasan'
              .text
              .white
              .semiBold
              .makeCentered()
              .continuousRectangle(
                height: 40,
                backgroundColor: primaryColor,
              )
              .onInkTap(() => vm.rateClass(myClass))
      ]).p12(),
    );
  }
}
