class AlbumEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String artist;
  final DateTime? releaseDate;    
  final String? description;      

  AlbumEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artist,
    this.releaseDate,
    this.description,
  });
}