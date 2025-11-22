const youtubeService = require("../services/youtube.service");
const ytdl = require("@distube/ytdl-core");

exports.getMP3 = async (req, res) => {
  try {
    const { songTitle, artist } = req.query;

    if (!songTitle || !artist) {
      return res
        .status(400)
        .json({ success: false, message: "Missing songTitle or artist" });
    }

    const result = await youtubeService.getMp3Url(songTitle, artist);
    res.json({ success: true, data: result });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.stream = async (req, res) => {
  try {
    const { songTitle, artist } = req.query;

    if (!songTitle || !artist) {
      return res.status(400).send("Missing song title or artist");
    }

    // Lấy videoId từ YouTube
    const videoId = await youtubeService.getVideoId(songTitle, artist);

    // Set header để stream audio
    res.setHeader("Content-Type", "audio/mpeg");

    // Stream nhạc từ YouTube
    ytdl(videoId, { filter: "audioonly" }).pipe(res);
  } catch (error) {
    console.error("Streaming error:", error);
    res.status(500).send("Error streaming audio");
  }
};

exports.getStreamUrl = async (req, res) => {
  try {
    const { songTitle, artist } = req.query;

    if (!songTitle || !artist) {
      return res.status(400).json({ error: "Missing song title or artist" });
    }

    // Gọi service để lấy stream URL
    const response = await youtubeService.getStreamUrl(songTitle, artist);

    return res.json(response); // Trả về { streamUrl: "..." }
  } catch (error) {
    console.error("Error in getStreamUrl controller:", error);
    res.status(500).json({ error: "Error generating stream URL" });
  }
};
