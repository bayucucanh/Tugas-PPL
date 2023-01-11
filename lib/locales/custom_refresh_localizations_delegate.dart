import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IdRefreshString implements RefreshString {
  @override
  String? canLoadingText = "Lepaskan untuk memuat lebih banyak";

  @override
  String? canRefreshText = "Lepaskan untuk menyegarkan";

  @override
  String? canTwoLevelText = "Lepaskan untuk masuk lantai 2";

  @override
  String? idleLoadingText = "Tarik ke atas untuk muat lebih banyak";

  @override
  String? idleRefreshText = "Segarkan";

  @override
  String? loadFailedText = "Memuat data gagal";

  @override
  String? loadingText = "Menunggu…";

  @override
  String? noMoreText = "Tidak ada data lagi";

  @override
  String? refreshCompleteText = "Penyegaran Selesai";

  @override
  String? refreshFailedText = "Penyegaran Gagal";

  @override
  String? refreshingText = "Menyegarkan…";
}

class CustomRefreshLocalizations extends RefreshLocalizations {
  static const CustomRefreshLocalizationsDelegate delegate =
      CustomRefreshLocalizationsDelegate();

  CustomRefreshLocalizations(Locale locale) : super(locale) {
    values.addAll({
      'id': IdRefreshString(),
    });
  }

  static CustomRefreshLocalizations? of(BuildContext context) {
    return Localizations.of(context, CustomRefreshLocalizations);
  }

  @override
  RefreshString? get currentLocalization {
    if (values.containsKey(locale.languageCode)) {
      return values[locale.languageCode];
    }
    return values["en"];
  }
}

class CustomRefreshLocalizationsDelegate extends RefreshLocalizationsDelegate {
  const CustomRefreshLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'id',
      'zh',
      'fr',
      'ru',
      'uk',
      'ja',
      'it',
      'de',
      'ko',
      'pt',
      'sv',
      'nl',
      'es'
    ].contains(locale.languageCode);
  }

  @override
  Future<CustomRefreshLocalizations> load(Locale locale) {
    return SynchronousFuture<CustomRefreshLocalizations>(
        CustomRefreshLocalizations(locale));
  }
}
