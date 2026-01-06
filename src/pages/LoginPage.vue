<template>
  <q-page class="bg-black text-white flex flex-center relative-position overflow-hidden">
    <!-- Background Elements -->
    <div class="absolute-full">
      <q-img 
        src="~assets/hero_education_dark_1767203133564.png" 
        class="fit" 
        style="opacity: 0.15; filter: grayscale(100%) brightness(0.7);"
      />
      <div class="absolute-full" style="background: radial-gradient(circle at center, transparent 0%, #000 95%);"></div>
    </div>
    
    <!-- Login Card -->
    <div class="container-sm relative-position z-top q-pa-md" style="width: 100%; max-width: 480px;">
      <div class="glass-card q-pa-xl rounded-borders shadow-24">
         <div class="text-center q-mb-xl">
            <q-avatar size="64px" class="q-mb-md">
               <img src="/favicon.svg">
            </q-avatar>
            <h2 class="text-h3 text-weight-bold q-mb-sm letter-spacing-tight">Welcome Back</h2>
            <p class="text-grey-5">Sign in to manage your institute</p>
         </div>

            <div v-if="errorMessage" class="bg-red-9 text-white q-pa-sm rounded-borders text-center q-mb-lg flex flex-center border-red">
               <q-icon name="error" class="q-mr-sm" /> {{ errorMessage }}
            </div>

            <q-form @submit="onSubmit" class="q-gutter-y-lg">
               <q-input 
                 v-model="email" 
                 label="Email Address" 
                 dark 
                 outlined 
                 dense
                 class="custom-input"
                 :rules="[ val => val && val.length > 0 || 'Please type your email']"
               >
                  <template v-slot:prepend>
                     <q-icon name="email" color="grey-7" size="20px" />
                  </template>
               </q-input>

               <q-input 
                 v-model="password" 
                 label="Password" 
                 type="password" 
                 dark 
                 outlined 
                 dense
                 class="custom-input"
                 :rules="[ val => val && val.length > 0 || 'Please type your password']"
               >
                  <template v-slot:prepend>
                     <q-icon name="lock" color="grey-7" size="20px" />
                  </template>
               </q-input>

               <!-- Cloudflare Turnstile -->
               <TurnstileWidget @verify="onTurnstileVerify" />

               <div class="q-mt-xl">
                 <q-btn 
                   type="submit"
                   label="Sign In" 
                   color="white" 
                   text-color="black" 
                   rounded 
                   unelevated 
                   no-caps 
                   size="lg" 
                   class="full-width text-weight-bold hover-glow" 
                   style="height: 56px;"
                   :loading="loading"
                   :disabled="!turnstileToken"
                 />
               </div>
            </q-form>

            <!-- Divider -->
            <div class="q-mt-xl q-mb-lg flex items-center">
              <div class="flex-1" style="height: 1px; background: rgba(255, 255, 255, 0.1);"></div>
              <span class="q-px-md text-grey-5 text-caption">OR</span>
              <div class="flex-1" style="height: 1px; background: rgba(255, 255, 255, 0.1);"></div>
            </div>

            <!-- Google Sign In Button -->
            <q-btn 
              @click="loginWithGoogle"
              color="white" 
              text-color="black" 
              rounded 
              unelevated 
              no-caps 
              size="lg" 
              class="full-width text-weight-bold google-btn" 
              style="height: 56px;"
              :loading="googleLoading"
            >
              <img 
                src="/google-logo.svg" 
                style="width: 20px; height: 20px; margin-right: 12px;"
                alt="Google"
              />
              Continue with Google
            </q-btn>

            <div class="text-center q-mt-xl text-grey-5">
               Don't have an account? <router-link to="/register" class="text-white text-weight-bold" style="text-decoration: none;">Register Now</router-link>
            </div>
         </div>
      </div>
   </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'
import TurnstileWidget from 'src/components/TurnstileWidget.vue'
import { auth, provider, signInWithPopup } from 'src/boot/firebase'

const router = useRouter()
const $q = useQuasar()

const email = ref('')
const password = ref('')
const loading = ref(false)
const googleLoading = ref(false)
const errorMessage = ref('')
const turnstileToken = ref(null)

const onTurnstileVerify = (token) => {
  turnstileToken.value = token
}

const loginWithGoogle = async () => {
  googleLoading.value = true
  errorMessage.value = ''
  
  try {
    // Sign in with Firebase Google popup
    const result = await signInWithPopup(auth, provider)
    const user = result.user
    
    // Get the Firebase ID token
    const idToken = await user.getIdToken()
    
    // Sign in to Supabase with the Firebase token
    const { data: supabaseData, error: supabaseError } = await supabase.auth.signInWithIdToken({
      provider: 'google',
      token: idToken,
    })
    
    if (supabaseError) {
      console.error('Supabase sign-in error:', supabaseError)
      // If Supabase integration fails, try email-based sign-in
      // First check if user exists in Supabase
      const { data: existingUser } = await supabase
        .from('users')
        .select('*')
        .eq('email', user.email)
        .single()
      
      if (!existingUser) {
        // Create new user record in Supabase
        const { error: insertError } = await supabase
          .from('users')
          .insert([
            {
              email: user.email,
              full_name: user.displayName,
              avatar_url: user.photoURL,
              auth_provider: 'google',
              created_at: new Date().toISOString()
            }
          ])
        
        if (insertError) {
          console.error('Error creating user record:', insertError)
        }
      }
    }
    
    $q.notify({
      type: 'positive',
      message: `Welcome, ${user.displayName}!`,
      position: 'top'
    })
    
    // Redirect to dashboard
    router.push('/dashboard')
  } catch (error) {
    console.error('Google Login Error:', error)
    
    let msg = error.message || 'Error logging in with Google'
    
    // Handle specific error codes
    if (error.code === 'auth/popup-closed-by-user') {
      msg = 'Login cancelled'
    } else if (error.code === 'auth/unauthorized-domain') {
      msg = 'Google Login is being configured. Please use email/password login for now. (Firebase domain authorization pending)'
    } else if (error.code === 'auth/cancelled-popup-request') {
      msg = 'Login cancelled'
    } else if (error.code === 'auth/network-request-failed') {
      msg = 'Network error. Please check your internet connection.'
    }
    
    errorMessage.value = msg
    
    $q.notify({
      type: 'negative',
      message: msg,
      position: 'top',
      timeout: 5000
    })
  } finally {
    googleLoading.value = false
  }
}

const onSubmit = async () => {
  if (!turnstileToken.value) {
    $q.notify({
      type: 'warning',
      message: 'Please complete the security check',
      position: 'top'
    })
    return
  }

  loading.value = true
  errorMessage.value = ''
  
  try {
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })

    if (error) throw error

    $q.notify({
      type: 'positive',
      message: 'Successfully logged in!',
      position: 'top'
    })
    
    router.push('/dashboard')
  } catch (error) {
    console.error('Login error:', error)
    let msg = error.message || 'Error logging in'
    
    if (msg.includes('Invalid login credentials')) {
      msg = 'Incorrect password or email. Please try again.'
    }
    
    errorMessage.value = msg
    
    $q.notify({
      type: 'negative',
      message: msg,
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.glass-card {
  background: rgba(255, 255, 255, 0.03);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.custom-input {
  :deep(.q-field__control) {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    
    &:before {
      border-color: rgba(255, 255, 255, 0.1);
    }
    
    &:hover:before {
      border-color: rgba(255, 255, 255, 0.3);
    }
  }
  
  :deep(.q-field__native) {
    color: white;
  }
  
  :deep(.q-field__label) {
    color: #888;
  }
}

.hover-glow {
  transition: all 0.3s ease;
  &:hover {
    box-shadow: 0 0 25px rgba(255, 255, 255, 0.3);
    transform: translateY(-2px);
  }
}

.google-btn {
  transition: all 0.3s ease;
  &:hover {
    box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
  }
}

.border-red {
  border: 1px solid rgba(255, 0, 0, 0.2);
}
</style>

