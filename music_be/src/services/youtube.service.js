const youtube = require("../config/youtube");
const ytdl = require("@distube/ytdl-core");

class YoutubeService {
  static async getMp3Url(songTitle, artist) {
    try {
      // 1. Tìm kiếm bài hát trên YouTube
      const searchQuery = `${songTitle} ${artist} official audio`;
      const searchResponse = await youtube.search.list({
        part: "snippet",
        q: searchQuery,
        maxResults: 1,
        type: "video",
      });

      if (
        !searchResponse.data.items ||
        searchResponse.data.items.length === 0
      ) {
        throw new Error("No YouTube results found");
      }

      const videoId = searchResponse.data.items[0].id.videoId;

      // 2. Lấy URL trực tiếp của file MP3 từ YouTube
      const info = await ytdl.getInfo(videoId);
      const audioFormat = ytdl.chooseFormat(info.formats, {
        filter: "audioonly",
      });

      if (!audioFormat || !audioFormat.url) {
        throw new Error("No MP3 streaming URL found");
      }

      return { mp3Url: audioFormat.url };
    } catch (error) {
      console.error("Error getting MP3 URL:", error);
      throw new Error(`Failed to get MP3 URL: ${error.message}`);
    }
  }

  static async getVideoId(songTitle, artist) {
    try {
      const searchQuery = `${songTitle} ${artist} official audio`;
      const searchResponse = await youtube.search.list({
        part: "snippet",
        q: searchQuery,
        maxResults: 1,
        type: "video",
      });

      if (
        !searchResponse.data.items ||
        searchResponse.data.items.length === 0
      ) {
        throw new Error("No YouTube results found");
      }

      return searchResponse.data.items[0].id.videoId;
    } catch (error) {
      console.error("Error searching for video:", error);
      throw new Error(`Failed to search for video: ${error.message}`);
    }
  }

  static async getStreamUrl(songTitle, artist) {
    try {
      if (!songTitle || !artist) {
        throw new Error("Missing song title or artist");
      }

      // Lấy videoId từ YouTube
      const videoId = await this.getVideoId(songTitle, artist);

      if (!videoId) {
        throw new Error("Failed to get videoId");
      }

      // Encode các tham số để đảm bảo URL an toàn
      const encodedTitle = encodeURIComponent(songTitle);
      const encodedArtist = encodeURIComponent(artist);

      // Tạo URL stream nhạc
      const streamUrl = `http://localhost:3000/api/youtube/stream?songTitle=${encodedTitle}&artist=${encodedArtist}`;

      return { streamUrl };
    } catch (error) {
      console.error("Error generating stream URL:", error);
      throw new Error(`Failed to generate stream URL: ${error.message}`);
    }
  }
}

module.exports = YoutubeService;
