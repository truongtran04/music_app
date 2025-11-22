 class ApiConstants {
  //  static const String baseUrl = 'http://10.0.2.2:3000/api/';
  static const String baseUrl = 'http://10.0.2.2:5000/';

  //  // Tracks
  //  static const String tracksBase = '${baseUrl}track/';
  //  static const String getAllTracks = '${tracksBase}allSong';

  //  //Albums
  // static const String albumBase = '${baseUrl}album/';
  // static const String getAllAlbums = '${albumBase}hot';

  // //Artists
  static const String artistBase = '${baseUrl}artist/';
  static const String getAllArtists = '${baseUrl}hot';
  
  static const String getAllTracks = '${baseUrl}song/allSong';

  static const String getAllAlbums = '${baseUrl}spotify/albums';
  static const String getAlbumById = '${baseUrl}spotify/album-detail/';
  static const String getTracksByAlbumId = '${baseUrl}spotify/albums/';

  //Search
  static const String search = '${baseUrl}spotify/search';
 }