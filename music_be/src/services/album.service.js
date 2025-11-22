const Album = require("../models/album.model");
const spotifyService = require("./spotify.service");
const SupabaseService = require("./supabase.service");
const YoutubeService = require("./youtube.service");
const spotifyApi = require("../config/spotify");

class AlbumService {
  static async getAllAlbums() {
    return await Album.find().populate("artist");
  }
  static async getAlbumById(id) {
    try {
      const album = await Album.findById(id);

      if (!album) {
        throw new Error("Album not found");
      }

      return album;
    } catch (error) {
      console.error("Error in getAlbumById:", error);
      throw error;
    }
  }
  // static async getById(id) {
  //   let album;
  //   if (!album) {
  //     // Nếu không có trong DB, lấy từ Spotify
  //     const spotifyAlbum = await spotifyService.getAlbumById(id);
  //     const trackDocs = [];

  //     for (const track of spotifyAlbum.tracks) {
  //       const fileName = `${track._id}`;

  //       // 1. Tìm và tải MP3 từ YouTube rồi upload lên Supabase
  //       const mp3Info = await YoutubeService.getMp3Url(
  //         track.title,
  //         track.artist
  //       );
  //       const mp3UploadResult = await SupabaseService.uploadMP3(
  //         mp3Info.mp3Url,
  //         fileName
  //       );

  //       // 2. Tải ảnh album lên Supabase
  //       const imageUploadResult = await SupabaseService.uploadImage(
  //         track.coverImageUrl,
  //         fileName
  //       );

  //       // 3. Tạo track doc
  //       trackDocs.push({
  //         _id: track._id,
  //         title: track.title,
  //         duration: track.duration,
  //         audioUrl: mp3UploadResult?.url || "", // link từ Supabase
  //         coverImageUrl: imageUploadResult?.url || track.coverImageUrl, // fallback nếu upload fail
  //         artist: track.artist,
  //         album: spotifyAlbum._id,
  //         genres: track.genres,
  //         playCount: 0,
  //       });
  //     }

  //     await Track.insertMany(trackDocs);
  //     if (spotifyAlbum) return spotifyAlbum;
  //   } else {
  //     album = await Album.findById(id).populate("artist");
  //   }
  //   return album;
  // }

  // static async getHotAlbums() {
  //   return await Album.find().sort({ popularity: -1 }).limit(10);
  // }

  // static async fetchFromSpotifyAndSave(albumName) {
  //   const existing = await Album.findOne({ title: albumName });
  //   if (existing) return existing;

  //   const album = await spotifyService.searchAlbums(albumName);
  //   const coverImageUrl =
  //     Array.isArray(album.images) && album.images.length > 0
  //       ? album.images[0].url
  //       : null;

  //   const newAlbum = new Album({
  //     _id: album.id,
  //     name: album.name,
  //     artist: album.artists[0]?.name || "Unknown", // hoặc lưu ID nếu có logic mapping riêng
  //     releaseDate: album.release_date ? new Date(album.release_date) : null,
  //     coverImageUrl,
  //     genres: album.genres || [],
  //     tracks: [], // Có thể cập nhật sau bằng 1 hàm fetch tracks
  //     description: album.label || "",
  //   });

  //   return await newAlbum.save();
  // }

  // static async searchAlbumsOnSpotify(query, limit = 8) {
  //   return await spotifyService.searchAlbums(query, limit);
  // }
  // static async saveAlbumsFromSpotify(albums) {
  //   const savedAlbums = [];

  //   for (const album of albums) {
  //     const existing = await Album.findById(album._id);
  //     if (existing) {
  //       savedAlbums.push(existing);
  //     } else {
  //       const newAlbum = new Album(album);
  //       await newAlbum.save();
  //       savedAlbums.push(newAlbum);
  //     }
  //   }

  //   return savedAlbums;
  // }

  // Đề Xuất
  static async getFeaturedAlbums(limit = 10) {
    try {
      const albums = await Album.aggregate([
        { $sample: { size: limit } }, // Lấy ngẫu nhiên 'limit' album
      ]);
      return albums;
    } catch (error) {
      console.error("Error fetching featured albums:", error);
      throw error;
    }
  }
  static async getTopAlbumsBySpotifyPopularity(limit = 100) {
    try {
      const albums = await this.getAllAlbums();
      console.log("All albums:", albums);
      const validAlbums = albums.filter(
        (album) => album.popularity && album.popularity > 0
      );
      // Sắp xếp giảm dần theo popularity
      validAlbums.sort((a, b) => b.popularity - a.popularity);
      console.log("Valid albums:", validAlbums);
      // Giới hạn kết quả
      return validAlbums.slice(0, 10);
    } catch (error) {
      console.error("Error in getTopAlbumsBySpotifyPopularity:", error);
      throw error;
    }
  }
}

module.exports = AlbumService;
