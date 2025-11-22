const express = require("express");
const router = express.Router();
const TrackController = require("../controllers/track.controller");

// Tạo bài hát từ tên (tìm trên Spotify rồi lưu về DB)
router.post("/create", TrackController.createSong);

// Lấy bài hát theo ID
router.get("/:id", TrackController.getById);

// Tăng lượt nghe bài hát (play)
router.post("/:id/play", TrackController.play);

// Lấy danh sách bài hát trending
router.get("/trending/all", TrackController.getTrending);

// Lấy danh sách bài hát mới phát hành
router.get("/new-releases/all", TrackController.getNewReleases);

// Import bài hát từ 1 album theo albumId Spotify
router.post("/import-album", TrackController.importAlbum);

module.exports = router;
