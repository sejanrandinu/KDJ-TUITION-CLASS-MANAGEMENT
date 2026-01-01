<template>
  <q-page class="q-pa-lg bg-grey-1">
    <div class="row q-col-gutter-lg">
      <div class="col-12">
        <h1 class="text-h4 text-weight-bold text-grey-9 q-mb-lg">My Profile</h1>
      </div>

      <!-- Profile Card -->
      <div class="col-12 col-md-4">
        <q-card flat bordered class="rounded-borders bg-white">
          <q-card-section class="text-center q-pa-xl">
            <q-avatar size="120px" font-size="52px" color="primary" text-color="white" class="shadow-10 q-mb-md">
              {{ profile.email ? profile.email.charAt(0).toUpperCase() : 'U' }}
            </q-avatar>
            <div class="text-h5 text-weight-bold text-grey-9">{{ profile.email }}</div>
            <q-chip color="green-1" text-color="green-8" class="q-mt-sm text-weight-bold" icon="verified">
              {{ profile.is_approved ? 'Approved Member' : 'Pending Approval' }}
            </q-chip>
          </q-card-section>
          
          <q-separator />
          
          <q-card-section>
            <div class="text-subtitle2 text-grey-6 q-mb-xs">Member Since</div>
            <div class="text-body1 text-weight-medium">{{ formatDate(profile.created_at) }}</div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Edit Profile Form -->
      <div class="col-12 col-md-8">
        <q-card flat bordered class="rounded-borders bg-white">
          <q-card-section>
            <div class="text-h6 text-weight-bold q-mb-md">Profile Details</div>
            <q-form @submit="updateProfile" class="q-gutter-md">
              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-6">
                  <q-input 
                    outlined 
                    v-model="profile.email" 
                    label="Email Address" 
                    readonly 
                    bg-color="grey-1"
                  >
                    <template v-slot:prepend><q-icon name="email" color="grey-7" /></template>
                  </q-input>
                </div>
                <div class="col-12 col-sm-6">
                  <q-input 
                    outlined 
                    v-model="profile.whatsapp_number" 
                    label="WhatsApp Number" 
                    mask="###-#######"
                    hint="Format: 077-1234567"
                  >
                    <template v-slot:prepend><q-icon name="fa-brands fa-whatsapp" color="green-7" /></template>
                  </q-input>
                </div>
              </div>

              <div class="row justify-end q-mt-md">
                <q-btn 
                  label="Update Profile" 
                  type="submit" 
                  color="primary" 
                  unelevated 
                  class="q-px-xl"
                  :loading="loading"
                />
              </div>
            </q-form>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'src/supabase'

const $q = useQuasar()
const loading = ref(false)
const profile = ref({
  email: '',
  whatsapp_number: '',
  is_approved: false,
  created_at: ''
})

onMounted(() => {
  fetchProfile()
})

const fetchProfile = async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (user) {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()
    
    if (!error && data) {
      profile.value = data
    }
  }
}

const updateProfile = async () => {
  loading.value = true
  const { data: { user } } = await supabase.auth.getUser()
  
  const { error } = await supabase
    .from('profiles')
    .update({
      whatsapp_number: profile.value.whatsapp_number,
      updated_at: new Date()
    })
    .eq('id', user.id)

  loading.value = false
  
  if (error) {
    $q.notify({ type: 'negative', message: 'Update failed: ' + error.message })
  } else {
    $q.notify({ type: 'positive', message: 'Profile updated successfully' })
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}
</script>
