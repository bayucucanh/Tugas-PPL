import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/banner_image.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CardSlider extends StatelessWidget {
  final BannerImage banner;
  final User? user;
  final double height;
  final Function()? onDeleteBanner;
  final bool? showTitle;
  final bool? showDescription;
  const CardSlider({
    Key? key,
    required this.banner,
    this.user,
    this.height = 180,
    this.onDeleteBanner,
    this.showTitle = true,
    this.showDescription = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        ZStack(
          [
            ImageCustom(
              url: banner.imageUrl!,
              blurhash: banner.blurhash,
            ).opacity(value: 0.8).wFull(context).cornerRadius(10),
            if (banner.link != null)
              const Tooltip(
                message: 'Tap untuk membuka link',
                child: Icon(
                  Icons.link_rounded,
                  color: Colors.white,
                ),
              ).positioned(right: 10),
            if (showTitle == true)
              (banner.title ?? '-')
                  .text
                  .white
                  .medium
                  .semiBold
                  .ellipsis
                  .maxLines(2)
                  .make()
                  .positioned(bottom: 30, left: 10),
            UiSpacer.verticalSpace(space: 10),
            if (showDescription == true)
              if (banner.description != null)
                (banner.description ?? '-')
                    .text
                    .medium
                    .white
                    .ellipsis
                    .maxLines(1)
                    .make()
                    .w(Get.width * 0.8)
                    .positioned(bottom: 10, left: 10),
          ],
        ).box.black.height(height).withRounded(value: 10).make().wFull(context),
        if (user != null && user!.hasRole('administrator'))
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: primaryColor,
            ),
            onPressed: onDeleteBanner,
          ).objectCenterRight(),
      ],
      alignment: MainAxisAlignment.start,
      crossAlignment: CrossAxisAlignment.start,
      axisSize: MainAxisSize.max,
    );
  }
}
