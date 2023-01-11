import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:velocity_x/velocity_x.dart';

class Formation {
  static List<Widget> fourThreeThree(Player? player, bool isMobileSize) => [
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 4
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 4
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              left: isMobileSize ? 80 : 350,
              bottom: isMobileSize ? 125 : 125,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 2
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 2
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              left: isMobileSize ? 110 : 400,
              top: isMobileSize ? 80 : 70,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 3
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 3
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              left: isMobileSize ? 110 : 400,
              bottom: isMobileSize ? 80 : 70,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 4
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 4
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              top: isMobileSize ? 125 : 125,
              left: isMobileSize ? 80 : 350,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 6
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 6
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              left: isMobileSize ? 150 : 460,
              bottom: isMobileSize ? 160 : 200,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 7
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 7
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              top: isMobileSize ? 100 : 100,
              left: isMobileSize ? 180 : 500,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 7
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 7
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              left: isMobileSize ? 180 : 500,
              bottom: isMobileSize ? 95 : 95,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 8
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 8
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              bottom: isMobileSize ? 80 : 80,
              right: isMobileSize ? 70 : 330,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 10
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 10
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              top: isMobileSize ? 80 : 80,
              right: isMobileSize ? 70 : 330,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 9
              ? null
              : CachedNetworkImageProvider(player!.photo!),
          onForegroundImageError: player?.position?.id != 9
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              top: isMobileSize ? 160 : 200,
              right: isMobileSize ? 70 : 330,
            ),
        CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundImage: player?.position?.id != 1
              ? null
              : CachedNetworkImageProvider(
                  player!.photo!,
                ),
          onForegroundImageError: player?.position?.id != 1
              ? null
              : (obj, error) => const Icon(Icons.error_outline_rounded),
        ).h(isMobileSize ? 30 : 150).positioned(
              top: isMobileSize ? 160 : 200,
              left: isMobileSize ? 30 : 270,
            ),
      ];
}
