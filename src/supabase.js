
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || process.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_KEY || process.env.VITE_SUPABASE_KEY

if (!supabaseUrl || !supabaseKey) {
    console.error('Supabase credentials missing! Check your .env file or environment variables.')
} else {
    console.log('Initializing Supabase with Project ID:', supabaseUrl.split('//')[1]?.split('.')[0])
}

// Resilient Storage Check
const getSafeStorage = () => {
  try {
    // Check if window.localStorage is actually accessible
    if (typeof window === 'undefined') return null;
    
    // Attempting to even touch window.localStorage can throw SecurityError in some browsers
    const storage = window.localStorage;
    if (!storage) throw new Error('localStorage not available');
    
    const testKey = '__test__';
    storage.setItem(testKey, '1');
    storage.removeItem(testKey);
    return storage;
  } catch (e) {
    console.warn('Supabase: localStorage is blocked or unavailable. Falling back to memory storage.', e);
    const memoryStorage = {};
    return {
      getItem: (key) => memoryStorage[key] || null,
      setItem: (key, value) => { memoryStorage[key] = value },
      removeItem: (key) => { delete memoryStorage[key] }
    };
  }
};

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    storageKey: 'classmaster-v4-token',
    storage: getSafeStorage()
  }
})

// For Debugging
if (typeof window !== 'undefined') {
  window.supabase = supabase
  window.__SUPABASE_URL__ = supabaseUrl
}
