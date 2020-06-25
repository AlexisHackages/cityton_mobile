import 'package:json_annotation/json_annotation.dart';

part 'mediaMinimal.g.dart';

@JsonSerializable()
class MediaMinimal {
  final int id;
  final String url;
  final DateTime createdAt;

  MediaMinimal(this.id, this.url, this.createdAt);

  factory MediaMinimal.fromJson(Map<String, dynamic> json) =>
      _$MediaMinimalFromJson(json);
  Map<String, dynamic> toJson() => _$MediaMinimalToJson(this);
}
