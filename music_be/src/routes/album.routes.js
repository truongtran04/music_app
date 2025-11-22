const express = require("express");
const router = express.Router();
const AlbumController = require("../controllers/album.controller");

// Lấy album theo ID
router.get("/:id", AlbumController.getAlbumById);

// Lấy các album "hot"
// router.get("/hot/all", AlbumController.getHotAlbums);

// Tìm kiếm album từ Spotify và lưu
// router.get("/spotify/search", AlbumController.searchAlbumsFromSpotify);
// Tìm kiếm và lưu 1 album cụ thể từ Spotify theo tên
// router.get("/spotify/fetch", AlbumController.fetchFromSpotifyAndSave);
router.get("/get-featured", AlbumController.getFeaturedAlbums);
router.get(
  "/top-featured-popularity",
  AlbumController.getFeaturedAlbumsByPopularity
);
// Lấy tất cả album từ database
router.get("/", AlbumController.getAllAlbums);

module.exports = router;
