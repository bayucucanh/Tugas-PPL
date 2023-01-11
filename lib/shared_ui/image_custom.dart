import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:octo_image/octo_image.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageCustom extends StatelessWidget {
  final String url;
  final String? blurhash;
  final BoxFit? fit;
  const ImageCustom(
      {Key? key, required this.url, this.blurhash, this.fit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: OctoImage(
        image: CachedNetworkImageProvider(url),
        placeholderBuilder: blurhash == null
            ? null
            : OctoPlaceholder.blurHash(
                blurhash!,
              ),
        errorBuilder: OctoError.icon(color: Colors.red),
        fit: fit,
        progressIndicatorBuilder: blurhash == null
            ? (context, progress) {
                double? value;
                if (progress != null && progress.expectedTotalBytes != null) {
                  value = progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!;
                }
                return CircularProgressIndicator(
                  value: value,
                  color: primaryColor,
                ).centered();
              }
            : null,
      ),
    );
  }
}
