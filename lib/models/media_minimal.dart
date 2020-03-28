class MediaMinimal {
  final int id;
  final String url;

  MediaMinimal({this.id, this.url});

  factory MediaMinimal.fromJson(Map<String, dynamic> json) {
    return MediaMinimal(
      id: json['id'] as int,
      url: json['url'] as String
    );
  }
}