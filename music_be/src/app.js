require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");

const spotifyRouter = require("./routes/spotify.route");
const youtubeRouter = require("./routes/youtube.route");
const supabaseRouter = require("./routes/supabase.route");
const authRouter = require("./routes/auth.routes");
const albumRouter = require("./routes/album.routes");
const artistRouter = require("./routes/artist.routes");
const searchRouter = require("./routes/search.routes");
const trackRouter = require("./routes/track.routes");
const premiumRoutes = require("./routes/premium.routes");

const app = express();
app.use(bodyParser.json());

// API routes
app.use("/api/auth", authRouter);
app.use("/api/spotify", spotifyRouter);
app.use("/api/youtube", youtubeRouter);
app.use("/api/supabase", supabaseRouter);
app.use("/api/album", albumRouter);
app.use("/api/artist", artistRouter);
app.use("/api/search", searchRouter);
app.use("/api/track", trackRouter);

app.use("/api/premium", premiumRoutes);

module.exports = app;
