const spotifyService = require("../services/spotify.service");
const youtubeService = require("../services/youtube.service");
const supabaseService = require("../services/supabase.service");
const TrackModel = require("../models/track.model");
const ArtistModel = require("../models/artist.model");
const AlbumModel = require("../models/album.model");
const GenreModel = require("../models/genre.model");
const fs = require("fs");

class SearchController {
  static async searchAll(req, res) {
    const query = req.query.q;
    if (!query) return res.status(400).json({ message: "Missing query" });

    try {
      // 1. Tìm kiếm metadata bài hát bằng Spotify
      const tracks = await spotifyService.searchTrack(query);

      const result = await Promise.all(
        (tracks.tracks.items || []).map(async (track) => {
          // Lấy metadata chuẩn từ Spotify
          const trackMeta = await spotifyService.getSongByID(track.id);

          // Xử lý nghệ sĩ: lưu vào DB nếu chưa có
          let artist = await ArtistModel.findOneAndUpdate(
            { _id: track.artists[0]?.id },
            {
              $setOnInsert: {
                name: track.artists[0]?.name,
                bio: "",
                avatarUrl: track.artists[0]?.images?.[0]?.url || null,
                genres: [],
              },
            },
            { upsert: true, new: true }
          );

          // Xử lý album: lưu vào DB nếu chưa có
          let albumId = null;
          if (track.album?.id) {
            let album = await AlbumModel.findOne({ _id: track.album.id });
            if (!album) {
              album = new AlbumModel({
                _id: track.album.id,
                name: track.album.name,
                coverImageUrl: track.album.images?.[0]?.url || null,
                releaseDate: track.album.release_date || null,
                artist: artist._id,
                tracks: [],
              });
              await album.save();
            }
            albumId = album._id;
          }

          // Xử lý genres: lấy từ Spotify artist, lưu vào DB nếu chưa có
          let genreIds = [];
          try {
            const artistSpotify = await spotifyService.fetchWithAuth(
              spotifyService.spotifyApi.getArtist.bind(
                spotifyService.spotifyApi
              ),
              track.artists[0]?.id
            );
            const genresFromSpotify = artistSpotify.body.genres || [];
            for (const genreName of genresFromSpotify) {
              let genre = await GenreModel.findOne({ name: genreName });
              if (!genre) {
                genre = new GenreModel({
                  _id: genreName.toLowerCase().replace(/\s+/g, "_"),
                  name: genreName,
                  description: "",
                  coverImageUrl: "",
                });
                await genre.save();
              }
              genreIds.push(genre._id);
            }
            if (genreIds.length > 0 && artist) {
              artist.genres = genreIds;
              await artist.save();
            }
          } catch (err) {
            genreIds = [];
          }

          // 2. Upload cover image lên Supabase
          let coverImageUrl = trackMeta.coverImageUrl;
          if (coverImageUrl) {
            const imageUploadResult = await supabaseService.uploadImage(
              coverImageUrl,
              trackMeta._id
            );
            if (imageUploadResult && imageUploadResult.url) {
              coverImageUrl = imageUploadResult.url;
            }
          }

          // 3. Tìm MP3 trên YouTube, tải về, upload lên Supabase
          let audioUrl = null;
          try {
            const songMp3 = await youtubeService.getMp3Url(
              trackMeta.title,
              artist.name
            );
            if (
              songMp3 &&
              songMp3.localFilePath &&
              fs.existsSync(songMp3.localFilePath)
            ) {
              // Upload file mp3 local lên Supabase
              const mp3UploadResult = await supabaseService.uploadMP3File(
                songMp3.localFilePath,
                trackMeta._id
              );
              if (mp3UploadResult && mp3UploadResult.url) {
                audioUrl = mp3UploadResult.url;
              }
              // Xóa file local sau khi upload thành công
              fs.unlink(songMp3.localFilePath, () => {});
            } else if (songMp3 && songMp3.mp3Url) {
              // Nếu không có file local, thử upload từ URL (nếu supabaseService hỗ trợ)
              const mp3UploadResult = await supabaseService.uploadMP3(
                songMp3.mp3Url,
                trackMeta._id
              );
              if (mp3UploadResult && mp3UploadResult.url) {
                audioUrl = mp3UploadResult.url;
              }
            }
          } catch (err) {
            console.error("Error getting MP3 URL:", err.message || err);
            audioUrl = null;
          }

          // 4. Lưu track vào database với link ảnh và nhạc từ Supabase
          let savedTrack = await TrackModel.findOne({ _id: trackMeta._id });
          if (!savedTrack) {
            // Lấy genres từ metadata của bài hát (trackMeta.genres)
            let trackGenres = genreIds;
            if (
              Array.isArray(trackMeta.genres) &&
              trackMeta.genres.length > 0
            ) {
              const genreDocs = await GenreModel.find({
                name: { $in: trackMeta.genres },
              });
              const metaGenreIds = genreDocs.map((g) => g._id);
              trackGenres = Array.from(new Set([...genreIds, ...metaGenreIds]));
            }

            savedTrack = new TrackModel({
              _id: trackMeta._id,
              title: trackMeta.title,
              duration: trackMeta.duration,
              audioUrl: audioUrl,
              coverImageUrl: coverImageUrl,
              artist: artist._id,
              album: albumId,
              genres: trackGenres,
              playCount: 0,
            });
            await savedTrack.save();
            if (albumId) {
              await AlbumModel.findByIdAndUpdate(albumId, {
                $addToSet: { tracks: savedTrack._id },
              });
            }
          }

          // Populate genres
          const genres = await GenreModel.find({
            _id: { $in: savedTrack.genres },
          });

          const artistGenres = await GenreModel.find({
            _id: { $in: artist.genres },
          });

          return {
            _id: savedTrack._id,
            title: savedTrack.title,
            duration: savedTrack.duration,
            audioUrl: savedTrack.audioUrl,
            coverImageUrl: savedTrack.coverImageUrl,
            artist: {
              _id: artist._id,
              name: artist.name,
              bio: artist.bio,
              avatarUrl: artist.avatarUrl,
              genres: artistGenres.map((g) => ({
                _id: g._id,
                name: g.name,
                description: g.description,
                coverImageUrl: g.coverImageUrl,
              })),
              createdAt: artist.createdAt,
              updatedAt: artist.updatedAt,
            },
            album: savedTrack.album,
            genres: genres.map((g) => ({
              _id: g._id,
              name: g.name,
              description: g.description,
              coverImageUrl: g.coverImageUrl,
            })),
            playCount: savedTrack.playCount,
            createdAt: savedTrack.createdAt,
            updatedAt: savedTrack.updatedAt,
          };
        })
      );

      res.json({ tracks: result });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }
}

module.exports = SearchController;
