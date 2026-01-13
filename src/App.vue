<template>
  <router-view />
</template>

<script setup>
import { onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'
import PaymentDialog from 'src/components/PaymentDialog.vue'

const $q = useQuasar()

onMounted(async () => {
    // Force unregister any Service Workers to prevent caching issues
    if ('serviceWorker' in navigator) {
        try {
            const registrations = await navigator.serviceWorker.getRegistrations()
            for (const registration of registrations) {
                await registration.unregister()
            }
            if (registrations.length > 0) {
                console.log('Unregistered zombie service workers')
                window.location.reload()
            }
        } catch (e) {
            console.warn('SW Cleanup error:', e)
        }
    }

  supabase.auth.onAuthStateChange(async (event, session) => {
    if (event === 'SIGNED_IN' && session) {
      try {
        // Check if profile exists
        const { data: profile } = await supabase
          .from('profiles')
          .select('id')
          .eq('id', session.user.id)
          .single()

        if (!profile) {
          // If no profile, create one with default role
          const { error } = await supabase
            .from('profiles')
            .insert({
              id: session.user.id,
              email: session.user.email,
              full_name: session.user.user_metadata.full_name || session.user.user_metadata.name || session.user.email,
              avatar_url: session.user.user_metadata.avatar_url || session.user.user_metadata.picture,
              role: 'pending', // Default role upon Google registration
              created_at: new Date().toISOString()
            })
            
          if (error) {
              console.error('Error creating profile for Google user:', error)
          } else {
            // Show Payment Dialog for new Google users
            $q.dialog({
              component: PaymentDialog
            })
          }
        }
      } catch (err) {
        console.error('Error in auth state change handler:', err)
        if (err.message && err.message.includes('SecurityError')) {
           console.warn('Storage security error handled in App.vue')
        }
      }
    }
  })
})
</script>
