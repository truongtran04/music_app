import '../../../domain/entities/artist/artist.dart';

class ArtistModel extends ArtistEntity {
  ArtistModel({
    required String id,
    required String name,
    required String imageUrl,
    String? bio,
    List<String>? genres,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          bio: bio,
          genres: genres,
        );

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      bio: json['bio'] as String?,
      genres: (json['genres'] as List?)?.map((e) => e as String).toList(),
    );
  }
}