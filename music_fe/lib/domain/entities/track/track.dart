class TrackEntity {
  final String id;
  final String title;
  final String artistID;
  final String albumID;
  final Duration duration;
  final DateTime releaseDate;
  final String imageUrl;
  final String mp3Url;

  TrackEntity({
    required this.id,
    required this.title,
    required this.artistID,
    required this.albumID,
    required this.duration,
    required this.releaseDate,
    required this.imageUrl,
    required this.mp3Url,
  });
}