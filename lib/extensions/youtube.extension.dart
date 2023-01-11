class ThumbnailQuality {
  /// 120*90
  static const String defaultQuality = 'default';

  /// 320*180
  static const String medium = 'mqdefault';

  /// 480*360
  static const String high = 'hqdefault';

  /// 640*480
  static const String standard = 'sddefault';

  /// Unscaled thumbnail
  static const String max = 'maxresdefault';
}

extension YoutubeConvert on String {
  String? _getYoutubeId({bool trimWhitespaces = true}) {
    String? url = this;
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var regex in [
      r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$',
      r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$',
      r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$',
    ]) {
      Match? match = RegExp(regex).firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  String? getYoutubeThumbnail({
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) {
    String? videoId = _getYoutubeId(trimWhitespaces: true);

    if (videoId == null) {
      return null;
    }
    return webp
        ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
        : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';
  }
}
