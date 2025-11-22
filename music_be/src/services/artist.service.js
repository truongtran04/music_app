const Artist = require("../models/artist.model");
const spotifyService = require("./spotify.service");
const spotifyApi = require("../config/spotify");

class ArtistService {
  static async getById(id) {
    return await Artist.findById(id);
  }

  static async getTopArtists() {
    return await Artist.find().sort({ popularity: -1 }).limit(10);
  }

  static async fetchFromSpotifyAndSave(artistName) {
    const existing = await Artist.findOne({ name: artistName });
    if (existing) return existing;

    const artist = await spotifyService.searchArtist(artistName);
    const imageUrl = artist?.images?.[0]?.url;

    const newArtist = new Artist({
      _id: artist.id,
      name: artist.name,
      imageUrl,
      genres: artist.genres,
      popularity: artist.popularity,
    });

    return await newArtist.save();
  }

  static async getTopTracks(id) {
    return await spotifyService.getArtistTopTracks(id);
  }
  static async importArtistAndAlbums(artistName) {
    // 1. Lấy id nghệ sĩ từ tên
    const artistIdObj = await spotifyService.getArtistIdByName(artistName);
    if (!artistIdObj) throw new Error("Không tìm thấy nghệ sĩ");

    // 2. Lấy thông tin nghệ sĩ
    const artistDetail = await spotifyService.getArtistDetailById(
      artistIdObj.id
    );

    // 3. Upload ảnh nghệ sĩ lên Supabase
    let avatarUrl = "";
    if (artistDetail.avatarUrl) {
      const uploadResult = await supabaseService.uploadImageArtist(
        artistDetail.avatarUrl,
        artistDetail._id
      );
      avatarUrl = uploadResult ? uploadResult.url : "";
    }

    // 4. Lưu nghệ sĩ vào DB
    const artistDoc = await Artist.findByIdAndUpdate(
      artistDetail._id,
      { ...artistDetail, avatarUrl },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );

    // 5. Lấy top 5 album
    const topAlbums = await this.getTopAlbumsByArtistId(artistDetail._id);
    const top5Albums = topAlbums.slice(0, 5);

    // 6. Upload ảnh album và lưu vào DB, đồng thời lưu thông tin album đã cập nhật
    const savedAlbums = [];
    for (const album of top5Albums) {
      let coverImageUrl = "";
      if (album.coverImageUrl) {
        const uploadResult = await supabaseService.uploadImageAlbum(
          album.coverImageUrl,
          album._id
        );
        coverImageUrl = uploadResult ? uploadResult.url : "";
      }
      const albumDoc = await Album.findByIdAndUpdate(
        album._id,
        { ...album, coverImageUrl, artist: artistDetail._id },
        { upsert: true, new: true, setDefaultsOnInsert: true }
      );
      savedAlbums.push(albumDoc);
    }

    return {
      artist: artistDoc,
      albums: savedAlbums, // Trả về toàn bộ thông tin 5 album đã lưu vào DB
    };
  }
  // Lấy id nghệ sĩ từ tên
  static async getArtistIdByName(name) {
    const response = await spotifyService.fetchWithAuth(() =>
      spotifyApi.searchArtists(name, { limit: 1 })
    );
    const artists = response.body.artists.items;
    if (!artists.length) return null;
    return { id: artists[0].id, name: artists[0].name };
  }
  // Lấy thông tin nghệ sĩ từ id
  static async getArtistDetailById(artistId) {
    const response = await spotifyService.fetchWithAuth(() =>
      spotifyApi.getArtist(artistId)
    );
    const artist = response.body;
    return {
      _id: artist.id,
      name: artist.name,
      bio: "",
      avatarUrl:
        artist.images && artist.images.length > 0 ? artist.images[0].url : "",
      genres: artist.genres || [],
    };
  }
}

module.exports = ArtistService;
