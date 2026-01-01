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
    
    <!-- Register Card -->
    <div class="container-sm relative-position z-top q-pa-md" style="width: 100%; max-width: 480px;">
      <div class="glass-card q-pa-xl rounded-borders">
         <div class="text-center q-mb-xl">
            <q-avatar size="64px" class="q-mb-md">
               <q-icon name="app_registration" size="40px" color="white" />
            </q-avatar>
            <h2 class="text-h3 text-weight-bold q-mb-sm letter-spacing-tight">Create Account</h2>
            <p class="text-grey-5">Join the future of education</p>
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
              :rules="[ 
                val => val && val.length > 0 || 'Please type your password',
                val => val.length >= 6 || 'Password must be at least 6 characters'
              ]"
            >
               <template v-slot:prepend>
                  <q-icon name="lock" color="grey-7" size="20px" />
               </template>
            </q-input>

            <q-input 
              v-model="confirmPassword" 
              label="Confirm Password" 
              type="password" 
              dark 
              outlined 
              dense
              class="custom-input"
              :rules="[ 
                val => val && val === password || 'Passwords do not match'
              ]"
            >
               <template v-slot:prepend>
                  <q-icon name="lock_clock" color="grey-7" size="20px" />
               </template>
            </q-input>

            <q-btn 
              type="submit"
              label="Register" 
              color="white" 
              text-color="black" 
              rounded 
              unelevated 
              no-caps 
              size="lg" 
              class="full-width text-weight-bold hover-glow" 
              :loading="loading"
            />
         </q-form>

         <div class="text-center q-mt-xl text-grey-5">
            Already have an account? <router-link to="/login" class="text-white text-weight-bold" style="text-decoration: none;">Sign In</router-link>
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

const router = useRouter()
const $q = useQuasar()

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const loading = ref(false)

const onSubmit = async () => {
  loading.value = true
  
  try {
    const { error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
    })

    if (error) throw error

    $q.notify({
      type: 'positive',
      message: 'Registration successful! Please check your email.',
      position: 'top'
    })
    
    // Optional: Auto-redirect or wait for confirmation
     router.push('/login')
  } catch (error) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Error registering',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
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
</style>
