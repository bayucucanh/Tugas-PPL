class Video {
  String? url;
  String? provider;
  String? thumbnail;
  String? duration;

  Video({this.url, this.provider, this.duration, this.thumbnail});

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        url: json['url'] as String?,
        thumbnail: json['thumbnail'] as String?,
        provider: json['provider'] as String?,
        duration: json['duration'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'thumbnail': thumbnail,
        'provider': provider,
        'duration': duration,
      };

  bool get isLocalProvider => provider == 'local';
}
