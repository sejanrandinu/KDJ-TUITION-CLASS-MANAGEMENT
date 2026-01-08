
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || process.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_KEY || process.env.VITE_SUPABASE_KEY

if (!supabaseUrl || !supabaseKey) {
    console.error('Supabase credentials missing! Check your .env file or environment variables.')
} else {
    console.log('Initializing Supabase with Project ID:', supabaseUrl.split('//')[1]?.split('.')[0])
}

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    storageKey: 'classmaster-auth-token' // Fixed storage key to avoid project mismatch drift
  },
  global: {
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  },
  db: {
    schema: 'public'
  }
})

// For Debugging
if (typeof window !== 'undefined') {
  window.supabase = supabase
  window.__SUPABASE_URL__ = supabaseUrl
}
