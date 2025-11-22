const express = require('express');
const SupabaseController = require('../controllers/supabase.controller');

const router = express.Router();

router.post('/upload-mp3', SupabaseController.uploadMP3);
router.post('/upload-image', SupabaseController.uploadImage);

module.exports = router;
