const SupabaseService = require('../services/supabase.service');

exports.uploadMP3 = async (req, res) => {
    try {
        const { url, fileName } = req.body;
        if (!url || !fileName) {
            return res.status(400).json({ error: 'URL và fileName là bắt buộc!' });
        }
        // Gọi service upload lên Supabase
        const result = await SupabaseService.uploadMP3(url, fileName);

        if (!result) {
            return res.status(500).json({ error: 'Lỗi khi upload MP3 lên Supabase' });
        }

        return res.status(200).json({
            message: 'MP3 uploaded successfully',
            url: result.url,
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}

exports.uploadImage = async (req, res) =>  {
    try {
        const { url, fileName } = req.body;
        if (!url || !fileName) return res.status(400).json({ error: 'URL và fileName là bắt buộc!' });

        const result = await SupabaseService.uploadImage(url, fileName);
        if (!result) return res.status(500).json({ error: 'Lỗi khi upload ảnh' });

        res.status(200).json({ message: 'Image uploaded successfully', url: result.url });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}
