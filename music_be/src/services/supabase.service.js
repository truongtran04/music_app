const supabase = require("../config/supabase");
const fetch = require("node-fetch");
const axios = require("axios");
const { streamToBuffer } = require("@jorgeferrero/stream-to-buffer");
const fs = require("fs");

class SupabaseService {
  static async uploadMP3(url, fileName) {
    try {
      // Tải MP3 bằng Axios (Stream)
      const response = await axios({
        method: "GET",
        url,
        responseType: "stream", // Dùng stream để giảm RAM sử dụng
      });

      if (!response || response.status !== 200) {
        throw new Error(
          `Không thể tải MP3 từ URL (Status: ${response.status})`
        );
      }

      // Chuyển Stream thành Buffer
      const mp3Buffer = await streamToBuffer(response.data);

      // Upload lên Supabase Storage
      const { data, error } = await supabase.storage
        .from(process.env.SUPABASE_BUCKET_NAME)
        .upload(`mp3/${fileName}.mp3`, mp3Buffer, {
          contentType: "audio/mpeg",
          upsert: true, // Ghi đè nếu file đã tồn tại
        });

      if (error) {
        console.error("Lỗi khi upload lên Supabase:", error.message);
        return null;
      }

      // URL công khai của MP3 trên Supabase
      const mp3Url = `${process.env.SUPABASE_URL}/storage/v1/object/public/${process.env.SUPABASE_BUCKET_NAME}/mp3/${fileName}.mp3`;

      return { url: mp3Url };
    } catch (error) {
      console.error("Lỗi upload MP3:", error.message);
      return null;
    }
  }

  /**
   * Upload Ảnh từ URL lên Supabase
   */
  static async uploadImage(url, fileName) {
    try {
      // Tải ảnh bằng Fetch API
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(
          `Không thể tải ảnh từ URL (Status: ${response.status})`
        );
      }

      // Chuyển đổi dữ liệu ảnh sang Buffer
      const imageBuffer = Buffer.from(await response.arrayBuffer());

      // Upload lên Supabase Storage
      const { data, error } = await supabase.storage
        .from(process.env.SUPABASE_BUCKET_NAME)
        .upload(`images/${fileName}.jpg`, imageBuffer, {
          contentType: "image/jpeg",
          upsert: true, // Ghi đè nếu file đã tồn tại
        });

      if (error) {
        console.error("Lỗi khi upload lên Supabase:", error.message);
        return null;
      }

      // Tạo URL công khai của ảnh trên Supabase
      const imageUrl = `${process.env.SUPABASE_URL}/storage/v1/object/public/${process.env.SUPABASE_BUCKET_NAME}/images/${fileName}.jpg`;

      return { url: imageUrl };
    } catch (error) {
      console.error("Lỗi upload ảnh:", error.message);
      return null;
    }
  }

  /**
   * Upload file MP3 local lên Supabase
   * @param {string} filePath - Đường dẫn file mp3 local
   * @param {string} fileName - Tên file (không có đuôi)
   */
  static async uploadMP3File(filePath, fileName) {
    try {
      if (!fs.existsSync(filePath)) {
        throw new Error("File MP3 không tồn tại");
      }
      const mp3Buffer = fs.readFileSync(filePath);

      const { data, error } = await supabase.storage
        .from(process.env.SUPABASE_BUCKET_NAME)
        .upload(`mp3/${fileName}.mp3`, mp3Buffer, {
          contentType: "audio/mpeg",
          upsert: true,
        });

      if (error) {
        console.error("Lỗi khi upload lên Supabase:", error.message);
        return null;
      }

      const mp3Url = `${process.env.SUPABASE_URL}/storage/v1/object/public/${process.env.SUPABASE_BUCKET_NAME}/mp3/${fileName}.mp3`;

      return { url: mp3Url };
    } catch (error) {
      console.error("Lỗi upload MP3 file:", error.message);
      return null;
    }
  }
  static async uploadImageArtist(url, fileName) {
    try {
      // Tải ảnh bằng Fetch API
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(
          `Không thể tải ảnh từ URL (Status: ${response.status})`
        );
      }

      // Chuyển đổi dữ liệu ảnh sang Buffer
      const imageBuffer = Buffer.from(await response.arrayBuffer());

      // Upload lên Supabase Storage
      const { data, error } = await supabase.storage
        .from(process.env.SUPABASE_BUCKET_NAME)
        .upload(`artists/${fileName}.jpg`, imageBuffer, {
          contentType: "image/jpeg",
          upsert: true, // Ghi đè nếu file đã tồn tại
        });

      if (error) {
        console.error("Lỗi khi upload lên Supabase:", error.message);
        return null;
      }

      // Tạo URL công khai của ảnh trên Supabase
      const imageUrl = `${process.env.SUPABASE_URL}/storage/v1/object/public/${process.env.SUPABASE_BUCKET_NAME}/artists/${fileName}.jpg`;

      return { url: imageUrl };
    } catch (error) {
      console.error("Lỗi upload ảnh:", error.message);
      return null;
    }
  }

  static async uploadImageAlbum(url, fileName) {
    try {
      // Tải ảnh bằng Fetch API
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(
          `Không thể tải ảnh từ URL (Status: ${response.status})`
        );
      }

      // Chuyển đổi dữ liệu ảnh sang Buffer
      const imageBuffer = Buffer.from(await response.arrayBuffer());

      // Upload lên Supabase Storage
      const { data, error } = await supabase.storage
        .from(process.env.SUPABASE_BUCKET_NAME)
        .upload(`albums/${fileName}.jpg`, imageBuffer, {
          contentType: "image/jpeg",
          upsert: true, // Ghi đè nếu file đã tồn tại
        });

      if (error) {
        console.error("Lỗi khi upload lên Supabase:", error.message);
        return null;
      }

      // Tạo URL công khai của ảnh trên Supabase
      const imageUrl = `${process.env.SUPABASE_URL}/storage/v1/object/public/${process.env.SUPABASE_BUCKET_NAME}/albums/${fileName}.jpg`;

      return { url: imageUrl };
    } catch (error) {
      console.error("Lỗi upload ảnh:", error.message);
      return null;
    }
  }
}

module.exports = SupabaseService;
