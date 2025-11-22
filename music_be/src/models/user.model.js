const mongoose = require("mongoose");
const db = require("../config/db");
const userSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      required: true,
    },
    name: String,
    email: { type: String, unique: true },
    password: String,
    avatarUrl: String,
    dateOfBirth: Date,
    gender: String,
    likedTracks: [{ type: mongoose.Schema.Types.ObjectId, ref: "Track" }],
    followedArtists: [{ type: mongoose.Schema.Types.ObjectId, ref: "Artist" }],
    isPremium: { type: Boolean, default: false },
    premiumExpiresAt: { type: Date, default: null },
  },
  { timestamps: true }
);

module.exports = db.model("User", userSchema);
