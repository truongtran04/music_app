const mongoose = require("mongoose");
const db = require("../config/db");
const artistSchema = new mongoose.Schema(
  {
    _id: { type: String, required: true },
    name: String,
    bio: String,
    avatarUrl: String,
    genres: [{ type: String, ref: "Genre" }],
  },
  { timestamps: true }
);

module.exports = db.model("Artist", artistSchema);
