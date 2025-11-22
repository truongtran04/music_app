const router = require("express").Router();
const YouTubeController = require("../controllers/youtube.controller");

router.get("/mp3", YouTubeController.getMP3);
router.get("/stream", YouTubeController.stream);
router.get("/streamUrl", YouTubeController.getStreamUrl);

module.exports = router;
