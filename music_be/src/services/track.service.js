const spotifyAPI = require("../config/spotify");
const spotifyService = require("./spotify.service");
const youtubeService = require("./youtube.service");
const supabaseService = require("./supabase.service");
const TrackModel = require("../models/track.model");

class TrackService {
  static async getById(id) {
    return await TrackModel.findById(id).populate("artist album genres");
  }

  static async getTrending() {
    return await TrackModel.find()
      .sort({ playCount: -1 })
      .limit(10)
      .populate("artist album genres");
  }

  static async getNewReleases() {
    return await TrackModel.find()
      .sort({ createdAt: -1 })
      .limit(10)
      .populate("artist album genres");
  }

  static async incrementPlay(id) {
    const track = await TrackModel.findById(id);
    if (!track) throw new Error("Track not found");
    track.playCount += 1;
    return await track.save();
  }

  static async getSongByName(songName) {
    try {
      const response = await spotifyService.fetchWithAuth(
        spotifyAPI.searchTracks.bind(spotifyAPI),
        songName,
        { limit: 1 }
      );

      if (
        !response ||
        !response.body ||
        !response.body.tracks ||
        !response.body.tracks.items.length
      ) {
        throw new Error("No song found");
      }

      return response.body.tracks.items[0];
    } catch (error) {
      console.error("Error fetching song: ", error);
      throw error;
    }
  }

  static async createSong(songData) {
    try {
      const song = new TrackModel({
        _id: songData.songID,
        title: songData.title,
        artists: songData.artists,
        artistsID: songData.artistsID,
        albumID: songData.albumID,
        duration: songData.duration,
        releaseDate: new Date(songData.releaseDate),
        imageUrl: songData.imageUrl,
        mp3Url: songData.mp3Url,
      });
      return await song.save();
    } catch (error) {
      console.error("Error creating song: ", error);
      throw error;
    }
  }

  // static async fetchAndSaveSong(songName) {
  //   try {
  //     if (!songName) {
  //       throw new Error("Track name is required");
  //     }

  //     // Check if song already exists in database
  //     const existingSong = await TrackModel.findOne({ title: songName });

  //     if (existingSong) {
  //       console.log(`Track already exists in DB: ${existingSong.title}`);
  //       return existingSong;
  //     }

  //     // Get song data from SpotifyService (đã map đúng model)
  //     const song = await spotifyService.getSongByID(
  //       (
  //         await this.getSongByName(songName)
  //       ).id
  //     );

  //     if (!song || !song.artist) {
  //       throw new Error("Invalid song data");
  //     }

  //     // Upload cover image to Supabase
  //     let coverImageUrl = song.coverImageUrl;
  //     if (coverImageUrl) {
  //       const imageUploadResult = await supabaseService.uploadImage(
  //         coverImageUrl,
  //         song._id
  //       );
  //       if (imageUploadResult && imageUploadResult.url) {
  //         coverImageUrl = imageUploadResult.url;
  //       }
  //     }

  //     // Get MP3 URL from YouTube
  //     const artistName = song.artist; // Nếu cần tên, phải lấy từ DB Artist
  //     const songMp3 = await youtubeService.getMp3Url(song.title, artistName);

  //     let audioUrl = null;
  //     if (songMp3 && songMp3.mp3Url) {
  //       // Upload MP3 to Supabase
  //       const mp3UploadResult = await supabaseService.uploadMP3(
  //         songMp3.mp3Url,
  //         song._id
  //       );
  //       if (mp3UploadResult && mp3UploadResult.url) {
  //         audioUrl = mp3UploadResult.url;
  //       }
  //     }

  //     // Chuẩn bị dữ liệu đúng với TrackModel
  //     const songData = {
  //       _id: track._id,
  //       title: track.title,
  //       duration: track.duration,
  //       audioUrl: audioUrl,
  //       coverImageUrl: coverImageUrl,
  //       artist: track.artist.name,
  //       album: track.album.name,
  //       genres: track.genres,
  //       releaseDate: new Date(track.releaseDate),
  //       playCount: track.playCount || 0,
  //     };

  //     // Create and save the song
  //     return await this.createSong(songData);
  //   } catch (error) {
  //     console.error("Error in fetchAndSaveSong:", error);
  //     throw error;
  //   }
  // }
  static async fetchAndSaveSongsByAlbumId(albumId) {
    try {
      const tracks = await spotifyService.getTracksByAlbumId(albumId);
      const results = [];

      for (const track of tracks) {
        try {
          const song = await spotifyService.getSongByID(track.id);

          let imageUploadResult = { url: null };
          if (song.imageUrl) {
            imageUploadResult = await supabaseService.uploadImage(
              song.imageUrl,
              song.spotifyId
            );
            if (!imageUploadResult || !imageUploadResult.url)
              throw new Error("Failed to upload image");
          }

          const songMp3 = await youtubeService.getStreamUrl(
            song.title,
            song.artists
          );
          console.log("songMp3", songMp3);
          if (!songMp3 || !songMp3.streamUrl)
            throw new Error("Could not retrieve MP3 URL");

          const mp3UploadResult = await supabaseService.uploadMP3(
            songMp3.streamUrl,
            song.spotifyId
          );
          if (!mp3UploadResult || !mp3UploadResult.url)
            throw new Error("Failed to upload MP3");

          const songData = {
            songID: song.spotifyId,
            title: song.title,
            artistsID: Array.isArray(song.artists)
              ? song.artists.map((a) => a.id).join(", ")
              : song.artistsID || "",
            artists: Array.isArray(song.artists)
              ? song.artists.map((a) => a.name).join(", ")
              : song.artists,
            albumID: albumId,
            duration: song.duration,
            releaseDate: song.releaseDate,
            imageUrl: imageUploadResult.url,
            mp3Url: mp3UploadResult.url,
          };

          const savedSong = await this.createSong(songData);
          results.push(savedSong);
        } catch (err) {
          console.error(`Error processing track ${track.id}:`, err.message);
        }
      }
      return results;
    } catch (error) {
      console.error("Error in fetchAndSaveSongsByAlbumId:", error);
      throw error;
    }
  }
}

module.exports = TrackService;
