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

const router = useRouter()
const $q = useQuasar()

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')
const turnstileToken = ref(null)

const onTurnstileVerify = (token) => {
  turnstileToken.value = token
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

.border-red {
  border: 1px solid rgba(255, 0, 0, 0.2);
}
</style>
