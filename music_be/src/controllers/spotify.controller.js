const spotifyService = require("../services/spotify.service");

exports.getSong = async (req, res) => {
  try {
    const { songID } = req.query;

    if (!songID) {
      return res.status(400).json({ error: "Song ID is required" });
    }

    const song = await spotifyService.getSongByID(songID);

    return res.json(song); // Trả về JSON chứa preview_url & image
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to fetch song", details: error.message });
  }
};
exports.getTopAlbumsByArtistId = async (req, res) => {
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
};
exports.importArtistAndAlbums = async (req, res) => {
  try {
    const { name } = req.body;
    if (!name) return res.status(400).json({ message: "Thiếu tên nghệ sĩ" });

    const result = await spotifyService.importArtistAndAlbums(name);
    res.json({ message: "Thành công", data: result });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
