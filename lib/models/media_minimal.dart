class MediaMinimal {
  final int id;
  final String url;
  final DateTime createdAt;

  MediaMinimal({this.id, this.url, this.createdAt});

  factory MediaMinimal.fromJson(Map<String, dynamic> json) {
    return MediaMinimal(
      id: json['id'] as int,
      url: json['url'] as String,
      createdAt: DateTime.parse(json['createdAt'].toString())
    );
  }
}