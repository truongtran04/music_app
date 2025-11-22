const TrackService = require("../services/track.service");

class TrackController {
  static async createSong(req, res) {
    try {
      const { songName } = req.query;
      if (!songName) {
        return res.status(400).json({ error: "songName is required" });
      }
      const saveSong = await TrackService.fetchAndSaveSong(songName);
      return res.json({ message: "Song saved successfully", song: saveSong });
    } catch (error) {
      console.error("Error creating song:", error);
      res
        .status(500)
        .json({ error: "Failed to create song", details: error.message });
    }
  }

  static async getById(req, res) {
    try {
      const track = await TrackService.getById(req.params.id);
      if (!track) return res.status(404).json({ message: "Not found" });
      res.json(track);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }

  static async getTrending(req, res) {
    try {
      const tracks = await TrackService.getTrending();
      res.json(tracks);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }

  static async getNewReleases(req, res) {
    try {
      const tracks = await TrackService.getNewReleases();
      res.json(tracks);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }

  static async play(req, res) {
    try {
      const track = await TrackService.incrementPlay(req.params.id);
      res.json({ message: "Play count updated", track });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }
  static async importAlbum(req, res) {
    try {
      const { albumId } = req.body;
      if (!albumId) {
        return res.status(400).json({ error: "albumId is required" });
      }
      const result = await TrackService.fetchAndSaveSongsByAlbumId(albumId);
      res.json({ message: "Album imported successfully", data: result });
    } catch (error) {
      console.error("Error importing album:", error);
      res
        .status(500)
        .json({ error: "Failed to import album", details: error.message });
    }
  }
}

module.exports = TrackController;
