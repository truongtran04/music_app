require('dotenv').config();
const { google } = require('googleapis');

const youtube = google.youtube({
    version: 'v3',
    auth: process.env.YOUTUBE_API_KEY,
});

async function connectYouTube() {
    try {
        const response = await youtube.videos.list({
            part: 'id',
            chart: 'mostPopular',
            maxResults: 1,
        });
        if (response.data && response.data.items.length > 0) {
            console.log("YouTube API Connected!");
        } else {
            console.warn("YouTube API Connected but received no data.");
        }
    } catch (error) {
        console.error("YouTube API Connection Error:", error.response ? error.response.data : error.message);
    }
}

connectYouTube();

module.exports = youtube;
