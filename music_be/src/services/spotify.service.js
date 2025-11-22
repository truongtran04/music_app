const spotifyApi = require("../config/spotify");
const ArtistService = require("./artist.service");
const Album = require("../models/album.model");
const Artist = require("../models/artist.model");
const supabaseService = require("./supabase.service");

class SpotifyService {
  static accessToken = null;
  static tokenExpiresAt = 0; // Thời gian hết hạn của token (timestamp)

  // Lấy Access Token mới nếu chưa có hoặc đã hết hạn
  static async getAccessToken() {
    const currentTime = Math.floor(Date.now() / 1000); // Timestamp hiện tại

    if (
      SpotifyService.accessToken &&
      currentTime < SpotifyService.tokenExpiresAt
    ) {
      return SpotifyService.accessToken; // Nếu token còn hạn, dùng lại
    }

    try {
      const data = await spotifyApi.clientCredentialsGrant();
      SpotifyService.accessToken = data.body["access_token"];
      SpotifyService.tokenExpiresAt = currentTime + data.body["expires_in"]; // Lưu thời gian hết hạn
      spotifyApi.setAccessToken(SpotifyService.accessToken);
      return SpotifyService.accessToken;
    } catch (error) {
      console.error("Failed to get Spotify token:", error);
      throw new Error("Spotify authentication failed");
    }
  }

  // Gọi API Spotify và tự động refresh token nếu gặp lỗi 401
  static async fetchWithAuth(apiMethod, ...params) {
    try {
      await SpotifyService.getAccessToken(); // Đảm bảo có token hợp lệ
      return await apiMethod(...params);
    } catch (error) {
      if (error.statusCode === 401) {
        console.log("Access token expired! Fetching a new Access Token...");
        await SpotifyService.getAccessToken();
        return await apiMethod(...params); // Thử gọi lại API sau khi refresh token
      }
      console.error("Spotify API error:", error);
      throw error;
    }
  }

  // Lấy thông tin bài hát từ Spotify
  static async getSongByID(songID) {
    if (!songID) throw new Error("Invalid song ID");

    try {
      // Gọi API Spotify để lấy thông tin bài hát
      const response = await SpotifyService.fetchWithAuth(() =>
        spotifyApi.getTrack(songID)
      );

      if (!response || !response.body) {
        throw new Error("No song found");
      }

      const track = response.body;

      // Lấy thông tin thể loại từ API album hoặc artist
      const artistId = track.artists[0]?.id; // Lấy ID của nghệ sĩ đầu tiên
      let genres = [];

      if (artistId) {
        const artistResponse = await SpotifyService.fetchWithAuth(() =>
          spotifyApi.getArtist(artistId)
        );
        genres = artistResponse.body.genres || [];
      }

      const songData = {
        spotifyId: track.id,
        title: track.name,
        artistsID: track.artists.map((artist) => artist.id).join(", "),
        artists: track.artists.map((artist) => artist.name).join(", "),
        album: track.album.name,
        duration: track.duration_ms,
        releaseDate: track.album.release_date,
        imageUrl:
          track.album.images.length > 0 ? track.album.images[0].url : null,
        genres: genres.join(", "), // Danh sách thể loại của nghệ sĩ (nếu có)
      };

      return songData;
    } catch (error) {
      console.error("Error fetching song:", error);
      throw new Error("Failed to fetch song details");
    }
  }

  // // Lấy top 3 album nhiều lượt nghe nhất của nghệ sĩ
  // static async getTopAlbumsByArtistId(artistId) {
  //   const response = await SpotifyService.fetchWithAuth(() =>
  //     spotifyApi.getArtistAlbums(artistId, { limit: 50 })
  //   );
  //   let albums = response.body.items;

  //   const albumDetails = await Promise.all(
  //     albums.map((album) =>
  //       SpotifyService.fetchWithAuth(() => spotifyApi.getAlbum(album.id))
  //     )
  //   );

  //   const topAlbums = albumDetails
  //     .map((res) => res.body)
  //     .sort((a, b) => (b.popularity || 0) - (a.popularity || 0))
  //     .slice(0, 5)
  //     .map((album) => ({
  //       _id: album.id,
  //       name: album.name,
  //       artist: album.artists.map((a) => a.name).join(", "),
  //       releaseDate: album.release_date ? new Date(album.release_date) : null,
  //       coverImageUrl:
  //         album.images && album.images.length > 0 ? album.images[0].url : "",
  //       genres: album.genres || [],
  //       tracks: album.tracks.items.map((track) => track.id),
  //       description: album.label || "",
  //     }));

  //   return topAlbums;
  // }
  // // Tìm kiếm bài hát trên Spotify theo từ khóa
  // static async searchTrack(query, limit = 10, offset = 0) {
  //   if (!query) throw new Error("Missing search query");
  //   try {
  //     const response = await SpotifyService.fetchWithAuth(() =>
  //       spotifyApi.searchTracks(query, { limit, offset })
  //     );
  //     return response.body;
  //   } catch (error) {
  //     console.error("Error searching tracks:", error);
  //     throw new Error("Failed to search tracks");
  //   }
  // }

  // static async searchAlbums(query, limit = 8, offset = 0) {
  //   if (!query) throw new Error("Missing search query");
  //   try {
  //     const response = await SpotifyService.fetchWithAuth(() =>
  //       spotifyApi.searchAlbums(query, { limit, offset })
  //     );
  //     const albums = response.body.albums.items;
  //     return albums.slice(0, limit).map((album) => ({
  //       _id: album.id,
  //       name: album.name,
  //       artist: album.artists.map((a) => a.name).join(", "),
  //       releaseDate: album.release_date ? new Date(album.release_date) : null,
  //       coverImageUrl:
  //         Array.isArray(album.images) && album.images.length > 0
  //           ? album.images[0].url
  //           : null,
  //       genres: [],
  //       tracks: album.total_tracks || 0,
  //       description: album.label || "",
  //     }));
  //   } catch (error) {
  //     console.error("Error searching albums:", error);
  //     throw new Error("Failed to search albums");
  //   }
  // }

  // static async searchArtist(query, limit = 10, offset = 0) {
  //   if (!query) throw new Error("Missing search query");
  //   try {
  //     const response = await SpotifyService.fetchWithAuth(() =>
  //       spotifyApi.searchArtists(query, { limit, offset })
  //     );
  //     return response.body.artists.items.map((artist) => ({
  //       _id: artist.id,
  //       name: artist.name,
  //       avatarUrl: artist.images?.[0]?.url || "",
  //       genres: artist.genres || [],
  //       followers: artist.followers?.total || 0,
  //       popularity: artist.popularity || 0,
  //     }));
  //   } catch (error) {
  //     console.error("Error searching artist:", error);
  //     throw new Error("Failed to search artist");
  //   }
  // }

  // static async getAlbumById(id) {
  //   try {
  //     const response = await SpotifyService.fetchWithAuth(() =>
  //       spotifyApi.getAlbum(id)
  //     );
  //     const album = response.body;
  //     return {
  //       _id: album.id,
  //       name: album.name,
  //       artist: album.artists.map((a) => a.name).join(", "),
  //       releaseDate: album.release_date ? new Date(album.release_date) : null,
  //       coverImageUrl: album.images?.[0]?.url || null,
  //       genres: album.genres || [],
  //       // Lấy chi tiết từng track trong album, map đúng với track.model.js
  //       tracks: album.tracks.items.map((t) => ({
  //         _id: t.id,
  //         title: t.name,
  //         duration: Math.floor((t.duration_ms || 0) / 1000), // chuyển ms sang giây
  //         audioUrl: t.preview_url || "",
  //         coverImageUrl: album.images?.[0]?.url || null,
  //         artist: t.artists[0]?.name || "",
  //         album: album.id,
  //         genres: [], // Spotify không trả genres cho track ở đây
  //         playCount: 0,
  //       })),
  //       description: album.label || "",
  //     };
  //   } catch (error) {
  //     console.error("Error fetching album by id:", error);
  //     return null;
  //   }
  // }

  // static async getArtistTopTracks(artistId, country = "VN") {
  //   try {
  //     const response = await SpotifyService.fetchWithAuth(() =>
  //       spotifyApi.getArtistTopTracks(artistId, country)
  //     );
  //     // Map về đúng model Track
  //     return response.body.tracks.map((t) => ({
  //       _id: t.id,
  //       title: t.name,
  //       duration: Math.floor((t.duration_ms || 0) / 1000),
  //       audioUrl: t.preview_url || "",
  //       coverImageUrl: t.album.images?.[0]?.url || null,
  //       artist: artistId,
  //       album: t.album.id,
  //       genres: [],
  //       playCount: 0,
  //     }));
  //   } catch (error) {
  //     console.error("Error fetching artist top tracks:", error);
  //     return [];
  //   }
  // }
  // static async getTracksByAlbumId(albumId) {
  //   try {
  //     const response = await SpotifyService.fetchWithAuth(() =>
  //       spotifyApi.getAlbumTracks(albumId, { limit: 50 })
  //     );
  //     const trackItems = response.body.items;

  //     // Lấy chi tiết từng track để lấy popularity
  //     const trackDetails = await Promise.all(
  //       trackItems.map((track) =>
  //         SpotifyService.fetchWithAuth(() => spotifyApi.getTrack(track.id))
  //       )
  //     );

  //     // Sắp xếp theo popularity giảm dần và lấy 3 bài đầu tiên
  //     const topTracks = trackDetails
  //       .map((res) => res.body)
  //       .sort((a, b) => b.popularity - a.popularity)
  //       .slice(0, 5)
  //       .map((track) => ({
  //         id: track.id,
  //       }));

  //     return topTracks;
  //   } catch (error) {
  //     console.error("Error fetching album tracks:", error);
  //     throw new Error("Failed to fetch album tracks");
  //   }
  // }
  // static async importArtistAndAlbums(artistName) {
  //   // 1. Lấy id nghệ sĩ từ tên
  //   const artistIdObj = await ArtistService.getArtistIdByName(artistName);
  //   if (!artistIdObj) throw new Error("Không tìm thấy nghệ sĩ");

  //   // 2. Lấy thông tin nghệ sĩ
  //   const artistDetail = await ArtistService.getArtistDetailById(
  //     artistIdObj.id
  //   );

  //   // 3. Upload ảnh nghệ sĩ lên Supabase
  //   let avatarUrl = "";
  //   if (artistDetail.avatarUrl) {
  //     const uploadResult = await supabaseService.uploadImageArtist(
  //       artistDetail.avatarUrl,
  //       artistDetail._id
  //     );
  //     avatarUrl = uploadResult ? uploadResult.url : "";
  //   }

  //   // 4. Lưu nghệ sĩ vào DB
  //   const artistDoc = await Artist.findByIdAndUpdate(
  //     artistDetail._id,
  //     { ...artistDetail, avatarUrl },
  //     { upsert: true, new: true, setDefaultsOnInsert: true }
  //   );

  //   // 5. Lấy top 5 album
  //   const topAlbums = await this.getTopAlbumsByArtistId(artistDetail._id);
  //   const top5Albums = topAlbums.slice(0, 5);

  //   // 6. Upload ảnh album và lưu vào DB, đồng thời lưu thông tin album đã cập nhật
  //   const savedAlbums = [];
  //   for (const album of top5Albums) {
  //     let coverImageUrl = "";
  //     if (album.coverImageUrl) {
  //       const uploadResult = await supabaseService.uploadImageAlbum(
  //         album.coverImageUrl,
  //         album._id
  //       );
  //       coverImageUrl = uploadResult ? uploadResult.url : "";
  //     }
  //     const albumDoc = await Album.findByIdAndUpdate(
  //       album._id,
  //       { ...album, coverImageUrl, artist: artistDetail.name },
  //       { upsert: true, new: true, setDefaultsOnInsert: true }
  //     );
  //     savedAlbums.push(albumDoc);
  //   }

  //   return {
  //     artist: artistDoc,
  //     albums: savedAlbums, // Trả về toàn bộ thông tin 5 album đã lưu vào DB
  //   };
  // }
  // Lấy id nghệ sĩ từ tên
  static async getArtistIdByName(name) {
    const response = await SpotifyService.fetchWithAuth(() =>
      spotifyApi.searchArtists(name, { limit: 1 })
    );
    const artists = response.body.artists.items;
    if (!artists.length) return null;
    return { id: artists[0].id, name: artists[0].name };
  }

  // Lấy thông tin nghệ sĩ từ id
  static async getArtistDetailById(artistId) {
    const response = await SpotifyService.fetchWithAuth(() =>
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

  // Lấy top 3 album nhiều lượt nghe nhất của nghệ sĩ
  static async getTopAlbumsByArtistId(artistId) {
    const response = await SpotifyService.fetchWithAuth(() =>
      spotifyApi.getArtistAlbums(artistId, { limit: 50 })
    );
    let albums = response.body.items;

    const albumDetails = await Promise.all(
      albums.map((album) =>
        SpotifyService.fetchWithAuth(() => spotifyApi.getAlbum(album.id))
      )
    );

    const topAlbums = albumDetails
      .map((res) => res.body)
      .sort((a, b) => (b.popularity || 0) - (a.popularity || 0))
      .slice(0, 2) // co th tuy chinh so album lay
      .map((album) => ({
        _id: album.id,
        name: album.name,
        artist: album.artists.map((a) => a.name).join(", "),
        releaseDate: album.release_date ? new Date(album.release_date) : null,
        coverImageUrl:
          album.images && album.images.length > 0 ? album.images[0].url : "",
        popularity: album.popularity || 0,
        genres: album.genres || [],
        tracks: album.tracks.items.map((track) => track.id),
        description: album.label || "",
      }));

    return topAlbums;
  }

  static async importArtistAndAlbums(artistName) {
    // 1. Lấy id nghệ sĩ từ tên
    const artistIdObj = await this.getArtistIdByName(artistName);
    if (!artistIdObj) throw new Error("Không tìm thấy nghệ sĩ");

    // 2. Lấy thông tin nghệ sĩ
    const artistDetail = await this.getArtistDetailById(artistIdObj.id);

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
        { ...album, coverImageUrl, artist: artistDetail.name },
        { upsert: true, new: true, setDefaultsOnInsert: true }
      );
      savedAlbums.push(albumDoc);
    }

    return {
      artist: artistDoc,
      albums: savedAlbums, // Trả về toàn bộ thông tin 5 album đã lưu vào DB
    };
  }
  static async getTracksByAlbumId(albumId) {
    try {
      const response = await SpotifyService.fetchWithAuth(() =>
        spotifyApi.getAlbumTracks(albumId, { limit: 50 })
      );
      const trackItems = response.body.items;

      // Lấy chi tiết từng track để lấy popularity
      const trackDetails = await Promise.all(
        trackItems.map((track) =>
          SpotifyService.fetchWithAuth(() => spotifyApi.getTrack(track.id))
        )
      );

      // Sắp xếp theo popularity giảm dần và lấy 3 bài đầu tiên
      const topTracks = trackDetails
        .map((res) => res.body)
        .sort((a, b) => b.popularity - a.popularity)
        .slice(0, 5)
        .map((track) => ({
          id: track.id,
        }));

      return topTracks;
    } catch (error) {
      console.error("Error fetching album tracks:", error);
      throw new Error("Failed to fetch album tracks");
    }
  }
}

module.exports = SpotifyService;
