class ArtistEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String? bio;
  final List<String>? genres;

  ArtistEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.bio,
    this.genres,
  });
}