const ArtistService = require("../services/artist.service");
const spotifyService = require("../services/spotify.service");

class ArtistController {
  // static async getById(req, res) {
  //   try {
  //     const artist = await ArtistService.getById(req.params.id);
  //     if (!artist) return res.status(404).json({ message: "Artist not found" });
  //     res.json(artist);
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }

  // static async getTopArtists(req, res) {
  //   try {
  //     const artists = await ArtistService.getTopArtists();
  //     res.json(artists);
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }

  // static async fetchFromSpotifyAndSave(req, res) {
  //   try {
  //     const { artistName } = req.query;
  //     if (!artistName) {
  //       return res.status(400).json({ error: "artistName is required" });
  //     }
  //     const artist = await ArtistService.importArtistAndAlbums(artistName);
  //     res.json({ message: "Artist saved successfully", artist });
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }

  // static async getTopTracks(req, res) {
  //   try {
  //     const tracks = await ArtistService.getTopTracks(req.params.id);
  //     res.json(tracks);
  //   } catch (error) {
  //     res.status(500).json({ message: error.message });
  //   }
  // }
  static async getArtistIdByName(req, res) {
    try {
      const { name } = req.query;
      if (!name)
        return res.status(400).json({ error: "Artist name is required" });

      const artist = await spotifyService.getArtistIdByName(name);
      if (!artist) return res.status(404).json({ error: "Artist not found" });

      return res.json(artist);
    } catch (error) {
      res
        .status(500)
        .json({ error: "Failed to fetch artist ID", details: error.message });
    }
  }
  static async getArtistDetailById(req, res) {
    try {
      const { artistId } = req.query;
      if (!artistId)
        return res.status(400).json({ error: "Artist ID is required" });

      const artist = await spotifyService.getArtistDetailById(artistId);
      return res.json(artist);
    } catch (error) {
      res.status(500).json({
        error: "Failed to fetch artist detail",
        details: error.message,
      });
    }
  }
}

module.exports = ArtistController;
