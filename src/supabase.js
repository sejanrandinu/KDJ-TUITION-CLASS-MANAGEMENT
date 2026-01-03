
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://jtdqwusyhqbjlefyboyt.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0ZHF3dXN5aHFiamxlZnlib3l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcyMDI5NDEsImV4cCI6MjA4Mjc3ODk0MX0.HyLZsq_5zEUksrI1qJXfZYtAI0EFdrPJaAp1yZyQkBc'

if (!supabaseUrl || !supabaseKey) {
    console.error('Supabase credentials missing! Check environment variables.')
}

export const supabase = createClient(supabaseUrl, supabaseKey)
