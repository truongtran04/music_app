require('dotenv').config();
const mongoose = require('mongoose');

const connection = mongoose.createConnection(process.env.MONGO_DB_CONNECTION).on('open', () => {
    console.log("MongoDB Connected!");
}).on('error', () => {
    console.log("MongoDB Connection Error");
});

module.exports = connection;