import '../../../domain/entities/album/album.dart';

class AlbumModel extends AlbumEntity {
  AlbumModel({
    required String id,
    required String name,
    required String imageUrl,
    required String artist,
    DateTime? releaseDate,
    String? description,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          artist: artist,
          releaseDate: releaseDate,
          description: description,
        );

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['coverImageUrl'] as String,
      artist: json['artist'] as String,
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'] as String)
          : null,
      description: json['description'] as String?,
    );
  }
}
