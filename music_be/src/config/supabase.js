require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error("Supabase connection error: Missing URL or Service Role Key.");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);
console.log("Supabase API Connected!");

module.exports = supabase;
