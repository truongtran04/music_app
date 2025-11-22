const mongoose = require("mongoose");
const db = require("../config/db");
const genreSchema = new mongoose.Schema({
  _id: { type: String, required: true },
  name: { type: String, unique: true },
  description: String,
  coverImageUrl: String,
});

module.exports = db.model("Genre", genreSchema);
