const express = require("express");
const router = express.Router();
const ArtistController = require("../controllers/artist.controller");

// // Lấy thông tin nghệ sĩ theo id
// router.get("/:id", ArtistController.getById);
// // Lấy top nghệ sĩ
// router.get("/", ArtistController.getTopArtists);

// // Import nghệ sĩ và album từ Spotify qua tên nghệ sĩ
// router.get("/import", ArtistController.fetchFromSpotifyAndSave);

// // Lấy top tracks của nghệ sĩ theo id
// router.get("/:id/top-tracks", ArtistController.getTopTracks);

router.get("/artist-id", ArtistController.getArtistIdByName);
router.get("/artist-detail", ArtistController.getArtistDetailById);
module.exports = router;
