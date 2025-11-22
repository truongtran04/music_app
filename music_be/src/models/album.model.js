const mongoose = require("mongoose");
const db = require("../config/db");

const albumSchema = new mongoose.Schema(
  {
    _id: { type: String, required: true }, // Thêm dòng này nếu muốn dùng string làm _id
    name: { type: String, required: true },
    artist: [{ type: String, ref: "Artist" }],
    releaseDate: { type: Date },
    coverImageUrl: { type: String },
    genres: [{ type: String }],
    tracks: [{ type: String, ref: "Track" }],
    description: { type: String },
    popularity: { type: Number, default: 0 },
  },
  { timestamps: true }
);

module.exports = db.model("Album", albumSchema);
