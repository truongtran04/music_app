import '../../../domain/entities/track/track.dart';

class TrackModel extends TrackEntity {
  TrackModel({
    required String id,
    required String title,
    required String artist,
    required String album,
    required Duration duration,
    required DateTime releaseDate,
    required String imageUrl,
    required String mp3Url,

  }) : super(id: id, title: title, artistID: artist, albumID: album, duration: duration, releaseDate: releaseDate, imageUrl: imageUrl, mp3Url: mp3Url);

  factory TrackModel.fromJson(Map<String, dynamic> json) {

    // Chuyển đổi duration từ milliseconds sang Duration
    final durationMs = json['duration'] is int ? json['duration'] : int.parse(json['duration'].toString());

    // Chuyển đổi releaseDate từ string sang DateTime
    DateTime releaseDate;
    try {
      releaseDate = DateTime.parse(json['releaseDate']);
    } catch (e) {
      // Nếu format datetime không chuẩn, lấy ngày hiện tại
      releaseDate = DateTime.now();
    }
    return TrackModel(
      id: json['_id'],
      title: json['title'],
      artist: json['artists'],
      album: json['albumID'],
      duration: Duration(milliseconds: durationMs),
      releaseDate: releaseDate,
      imageUrl: json['imageUrl'],
      mp3Url: json['mp3Url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "artists": artistID,
      "albumID": albumID,
      "duration": duration.inMilliseconds,
      "releaseDate": releaseDate.toIso8601String(),
      "imageUrl": imageUrl,
      "mp3Url": mp3Url,
    };
  }
}