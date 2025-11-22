const mongoose = require("mongoose");
const db = require("../config/db");
const historySchema = new mongoose.Schema({
  _id: { type: String, required: true },
  user: { type: String, ref: "User" },
  track: { type: String, ref: "Track" },
  playedAt: { type: Date, default: Date.now },
});

module.exports = db.model("History", historySchema);
