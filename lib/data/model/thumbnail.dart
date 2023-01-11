enum ImageQuality {
  low,
  high,
}

class Thumbnail {
  String? origin;
  String? lowQuality;
  String? hightQuality;

  Thumbnail({
    this.origin,
    this.hightQuality,
    this.lowQuality,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        origin: json['origin'] as String?,
        lowQuality: json['lq'] as String?,
        hightQuality: json['hq'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'origin': origin,
        'lq': lowQuality,
        'hq': hightQuality,
      };

  String? defaultImage({ImageQuality? quality}) {
    if (quality != null) {
      if (quality == ImageQuality.low) {
        if (lowQuality != null) {
          return lowQuality;
        }
      } else if (quality == ImageQuality.high) {
        if (hightQuality != null) {
          return hightQuality;
        }
      }
    }
    return origin;
  }
}
