const router = require("express").Router();
const SpotifyController = require("../controllers/spotify.controller");

router.get("/song", SpotifyController.getSong);
router.get("/artist-top-albums", SpotifyController.getTopAlbumsByArtistId);
router.post("/import-artist", SpotifyController.importArtistAndAlbums);
module.exports = router;
