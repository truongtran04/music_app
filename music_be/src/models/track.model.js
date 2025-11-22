const mongoose = require("mongoose");
const db = require("../config/db");
const { Schema } = mongoose;

const trackSchema = new Schema({
  _id: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  artistsID: {
    type: String,
    required: true,
  },
  artists: {
    type: String,
    required: true,
  },
  albumID: {
    type: String,
    required: true,
  },
  duration: {
    type: Number,
    required: true,
  },
  releaseDate: {
    type: String,
    required: true,
  },
  imageUrl: {
    type: String,
    required: true,
  },
  mp3Url: {
    type: String,
    required: true,
  },
});

const TrackModel = db.model("track", trackSchema);
module.exports = TrackModel;
