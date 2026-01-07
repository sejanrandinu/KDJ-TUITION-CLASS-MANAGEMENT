<template>
  <router-view />
</template>

<script setup>
import { onMounted } from 'vue'
import { supabase } from 'src/supabase'

onMounted(() => {
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
          }
        }
      } catch (err) {
        console.error('Error in auth state change handler:', err)
      }
    }
  })
})
</script>
