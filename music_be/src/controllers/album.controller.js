const AlbumService = require("../services/album.service");
const spotifyService = require("../services/spotify.service");

class AlbumController {
  static async getAllAlbums(req, res) {
    try {
      const albums = await AlbumService.getAllAlbums();
      res.status(200).json({ success: true, data: albums });
    } catch (error) {
      res
        .status(500)
        .json({ success: false, message: error.message || "Error" });
    }
  }

  static async getAlbumById(req, res) {
    try {
      const albumId = req.params.id;
      const album = await AlbumService.getAlbumById(albumId);

      res.status(200).json({ success: true, data: album });
    } catch (error) {
      res
        .status(404)
        .json({ success: false, message: error.message || "Error" });
    }
  }
  // static async getById(req, res) {
  //   try {
  //     const album = await AlbumService.getById(req.params.id);
  //     if (!album) return res.status(404).json({ message: "Album not found" });
  //     res.json(album);
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }

  // static async getHotAlbums(req, res) {
  //   try {
  //     const albums = await AlbumService.getHotAlbums();
  //     res.json(albums);
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }

  // static async fetchFromSpotifyAndSave(req, res) {
  //   try {
  //     const { albumName } = req.query;
  //     if (!albumName) {
  //       return res.status(400).json({ error: "albumName is required" });
  //     }
  //     const album = await AlbumService.fetchFromSpotifyAndSave(albumName);
  //     res.json({ message: "Album saved successfully", album });
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }

  // static async searchAlbumsFromSpotify(req, res) {
  //   try {
  //     const { query } = req.query;
  //     if (!query) {
  //       return res.status(400).json({ error: "query is required" });
  //     }
  //     const albums = await AlbumService.fetchFromSpotifyAndSave(query, 8);
  //     res.json(albums);
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }
  // static async getAllAlbums(req, res) {
  //   try {
  //     const albums = await AlbumService.getAllAlbums();
  //     res.status(200).json(albums);
  //   } catch (error) {
  //     res.status(500).json({ message: "Lỗi khi lấy danh sách album", error });
  //   }
  // }
  static async getTopAlbumsByArtistId(req, res) {
    try {
      const { artistId } = req.query;
      if (!artistId)
        return res.status(400).json({ error: "Artist ID is required" });

      const albums = await spotifyService.getTopAlbumsByArtistId(artistId);
      return res.json(albums);
    } catch (error) {
      res
        .status(500)
        .json({ error: "Failed to fetch top albums", details: error.message });
    }
  }
  // Đề xuất album
  static async getFeaturedAlbums(req, res) {
    try {
      // Có thể lấy param limit từ query nếu muốn
      const limit = parseInt(req.query.limit) || 10;

      const albums = await AlbumService.getFeaturedAlbums(limit);
      res.status(200).json({ success: true, data: albums });
    } catch (error) {
      console.error(error);
      res.status(500).json({ success: false, message: "Lỗi server" });
    }
  }
  // album nổi bật
  static async getFeaturedAlbumsByPopularity(req, res) {
    try {
      const limit = parseInt(req.query.limit) || 10;
      const albums = await AlbumService.getTopAlbumsBySpotifyPopularity(limit);
      res.status(200).json({ success: true, data: albums });
    } catch (error) {
      res.status(500).json({ success: false, message: "Lỗi server" });
    }
  }
}

module.exports = AlbumController;
