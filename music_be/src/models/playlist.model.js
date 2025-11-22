const mongoose = require("mongoose");
const db = require("../config/db");
const playlistSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      required: true,
    },
    title: String,
    description: String,
    coverImageUrl: String,
    creator: { type: String, ref: "User" },
    tracks: [{ type: String, ref: "Track" }],
    genres: [{ type: String, ref: "Genre" }],
    isFeatured: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = db.model("Playlist", playlistSchema);
